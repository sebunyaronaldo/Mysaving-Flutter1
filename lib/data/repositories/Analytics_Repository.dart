import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysavingapp/data/models/expenses_model.dart';
import 'package:mysavingapp/data/repositories/dashboard_repository.dart';
import 'package:mysavingapp/data/repositories/interfaces/IAnalyticsRepository.dart';
import '../../config/services/user_manager.dart';
import '../models/Analytics_Model.dart'; // Make sure the path to the model file is correct.
import 'package:intl/intl.dart';

class AnalyticsRepository extends IAnalitycsRepository {
  String mainCollection = dotenv.env['MAIN_COLLECTION']!;
  String aCollection = dotenv.env['A_COLLECTION']!;
  final String? uid;

  AnalyticsRepository({this.uid});

  Future<void> addAnalyticsData(List<AnalitycsModel> analytics) async {
    final CollectionReference expenseCollection = FirebaseFirestore.instance.collection(mainCollection);

    // Get the current month and last month

    List<Map<String, dynamic>> analitycsData = analytics.map((analityc) {
      List<Map<String, dynamic>> mainAnalitycs =
          analityc.mainAnalytics!.map((mainAnalitycs) => mainAnalitycs.toMap()).toList().toList();

      return {
        'id': analityc.id,
        // 'analitycsStatistic': analitycsStatistic,
        'mainAnalitycs': mainAnalitycs,
      };
    }).toList();

    DocumentReference userExpenseDoc = expenseCollection.doc(uid);
    CollectionReference userDashboardCol = userExpenseDoc.collection(aCollection);

    await userDashboardCol.add({
      'analytics': analitycsData,
    });
  }

  Future<List<MainAnalitycs>> getMainAnalitycs() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    List<MainAnalitycs> mainAnalyticsList = [];

    final result =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(aCollection).get();

    for (var mainAnalitycsDoc in result.docs) {
      final mainAnalitycsData = mainAnalitycsDoc.data();
      final mainAnalitycsStats = mainAnalitycsData['analytics'][0]['mainAnalitycs'];

      if (mainAnalitycsStats != null) {
        final mainAnalitycsJson = mainAnalitycsStats[0];

        List<CurrentMonth> currentMonthList = List<CurrentMonth>.from(
          mainAnalitycsJson['currentMonth'].map(
            (jsonData) => CurrentMonth.fromJson(jsonData),
          ),
        );

        List<LastMonth> lastMonthList = List<LastMonth>.from(
          mainAnalitycsJson['lastMonth'].map(
            (jsonData) => LastMonth.fromJson(jsonData),
          ),
        );

        MainAnalitycs mainAnalitycs = MainAnalitycs(
          customCategoryName: 'No name',
          lastmonth: lastMonthList,
          currentmonth: currentMonthList,
        );

        mainAnalyticsList.add(mainAnalitycs);
      }
    }

    return mainAnalyticsList;
  }

  Future<void> addToMainAnalitycs(int categoryId, int cost, String name) async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final result = await firestore.collection(mainCollection).doc(userID).collection(aCollection).get();

    for (var mainAnalitycsDoc in result.docs) {
      final mainAnalitycsData = mainAnalitycsDoc.data();
      final mainAnalitycsStats = mainAnalitycsData['analytics'][0]['mainAnalitycs'];

      if (mainAnalitycsStats != null) {
        final currentMonth = mainAnalitycsStats[0]['currentMonth'];
        for (var categoryData in currentMonth[0]['categories']) {
          if (categoryData != null) {
            final categoryIdData = categoryData['id'];
            if (categoryIdData != null && categoryIdData == categoryId) {
              List<dynamic> expenses = List.from(categoryData['expenses'] ?? []);
              // Tworzenie listy wydatków danej kategorii.

              Expense expense = Expense(
                name: name,
                cost: cost,
                expensesTime: Timestamp.now(),
              );
              expenses.add(expense.toMap());
              // Dodawanie nowego wydatku do listy.

              categoryData['expenses'] = expenses;

              // Update the mainAnalitycsData with the modified mainAnalitycsStats
              mainAnalitycsData['analytics'][0]['mainAnalitycs'] = mainAnalitycsStats;

              await mainAnalitycsDoc.reference.update(mainAnalitycsData);
            }
          }
        }
        print('Update Main: $mainAnalitycsStats');
      }
    }
    updateTotalCostsInCurrentMonth();
  }

  Future<void> moveDataToLastMonth() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final collectionRef =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(aCollection).get();

    if (collectionRef.docs.isNotEmpty) {
      final dashboardDoc = collectionRef.docs.first;
      final dashboardData = dashboardDoc.data();
      final analyticsList = dashboardData['analytics'][0]['mainAnalitycs'];

      for (var analytics in analyticsList) {
        final currentMonthData = analytics['currentMonth'];
        final lastMonthData = analytics['lastMonth'];

        // Move data from currentMonth to lastMonth for each category
        List<dynamic> currentMonthCategories = currentMonthData[0]['categories'];
        List<dynamic> lastMonthCategories = lastMonthData[0]['categories'];

        double totalCostsForLastMonth = 0;
        lastMonthCategories.clear();
        for (var currentCategory in currentMonthCategories) {
          List<dynamic> currentCategoryExpenses = currentCategory['expenses'];
          int categoryId = currentCategory['id'];

          // Find the corresponding category in lastMonthData
          var lastCategory = lastMonthCategories.firstWhere(
            (category) => category['id'] == categoryId,
            orElse: () => null,
          );

          if (lastCategory != null) {
            // Move expenses from currentMonth to lastMonth
            List<dynamic> lastCategoryExpenses = lastCategory['expenses'];
            lastCategoryExpenses.addAll(currentCategoryExpenses);

            // Move totalCosts from currentMonth to lastMonth
            lastCategory['totalCosts'] += currentCategory['totalCosts'];

            // Update the totalCosts for lastMonth
            totalCostsForLastMonth += lastCategory['totalCosts'];

            // Clear the currentMonth expenses and totalCosts for this category
            currentCategory['expenses'] = [];
            currentCategory['totalCosts'] = 0;
          } else {
            // If the category doesn't exist in lastMonthData, add it with expenses
            lastMonthCategories.add({
              'id': categoryId,
              'name': currentCategory['name'],
              'expenses': currentCategoryExpenses,
              'totalCosts': currentMonthData[0]['totalCosts'] ?? 0,
            });

            // Update the totalCosts for lastMonth
            totalCostsForLastMonth += currentCategory['totalCosts'] ?? 0;

            // Clear the currentMonth expenses and totalCosts for this category
            currentCategory['expenses'] = [];
            currentCategory['costs'] = 0;
          }
        }

        // Update the month names and numberOfMonth
        String currentMonthName = DateFormat('MMMM').format(DateTime.now());
        String lastMonthName = DateFormat('MMMM').format(DateTime.now().subtract(Duration(days: 30)));

        analytics['currentMonth'][0]['numberOfMonth'] = DateTime.now().month;
        analytics['lastMonth'][0]['numberOfMonth'] = DateTime.now().month - 1;

        analytics['currentMonth'] = [
          {
            'name': currentMonthName,
            'categories': currentMonthData[0]['categories'],
            'totalCosts': 0,
            'numberOfMonth': DateTime.now().month,
            'id': 1,
          }
        ];
        analytics['lastMonth'] = [
          {
            'name': lastMonthName,
            'categories': lastMonthCategories,
            'totalCosts': totalCostsForLastMonth,
            'numberOfMonth': DateTime.now().month - 1,
            'id': 2,
          }
        ];
        // Update the changes back to the list
        int index = analyticsList.indexOf(analytics);
        analyticsList[index] = analytics;
      }

      // Update the 'analytics' field in the database
      await dashboardDoc.reference.update({
        'analytics': [
          {'mainAnalitycs': analyticsList}
        ],
      });
    }
    updateTotalCostsInLastMonth();
  }

  Future<void> updateTotalCostsInCurrentMonth() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final result =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(aCollection).get();

    if (result.docs.isNotEmpty) {
      final dashboardDoc = result.docs.first;
      final dashboardData = dashboardDoc.data();
      final analyticsList = dashboardData['analytics'][0]['mainAnalitycs'];

      for (var analytics in analyticsList) {
        final currentMonthData = analytics['currentMonth'];
        List<dynamic> currentMonthCategories = currentMonthData[0]['categories'];

        for (var currentCategory in currentMonthCategories) {
          List<dynamic> currentCategoryExpenses = currentCategory['expenses'];

          // Calculate the total costs for this category
          int totalCosts = 0;
          for (var expenseData in currentCategoryExpenses) {
            Expense expense = Expense.fromJson(expenseData);
            totalCosts += expense.cost!;
          }

          // Update the totalCosts field in the currentMonth category
          currentCategory['costs'] = totalCosts;
        }

        // Calculate the overall total costs for the currentMonth
        int overallTotalCosts = 0;
        for (var categoryData in currentMonthCategories) {
          Category category = Category.fromJson(categoryData);
          overallTotalCosts += category.costs!;
        }

        // Update the overall totalCosts field in the currentMonth
        currentMonthData[0]['totalCosts'] = overallTotalCosts;

        // Update the changes back to the list
        int index = analyticsList.indexOf(analytics);
        analyticsList[index] = analytics;
      }

      // Update the 'analytics' field in the database
      await dashboardDoc.reference.update({
        'analytics': [
          {'mainAnalitycs': analyticsList}
        ],
      });
    }
  }

  Future<void> updateTotalCostsInLastMonth() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final result =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(aCollection).get();

    if (result.docs.isNotEmpty) {
      final dashboardDoc = result.docs.first;
      final dashboardData = dashboardDoc.data();
      final analyticsList = dashboardData['analytics'][0]['mainAnalitycs'];

      for (var analytics in analyticsList) {
        final currentMonthData = analytics['lastMonth'];
        List<dynamic> currentMonthCategories = currentMonthData[0]['categories'];

        for (var currentCategory in currentMonthCategories) {
          List<dynamic> currentCategoryExpenses = currentCategory['expenses'];

          // Calculate the total costs for this category
          int totalCosts = 0;
          for (var expenseData in currentCategoryExpenses) {
            Expense expense = Expense.fromJson(expenseData);
            totalCosts += expense.cost!;
          }

          // Update the totalCosts field in the currentMonth category
          currentCategory['costs'] = totalCosts;
        }

        // Calculate the overall total costs for the currentMonth
        int overallTotalCosts = 0;
        for (var categoryData in currentMonthCategories) {
          Category category = Category.fromJson(categoryData);
          overallTotalCosts += category.costs!;
        }

        // Update the overall totalCosts field in the currentMonth
        currentMonthData[0]['totalCosts'] = overallTotalCosts;

        // Update the changes back to the list
        int index = analyticsList.indexOf(analytics);
        analyticsList[index] = analytics;
      }

      // Update the 'analytics' field in the database
      await dashboardDoc.reference.update({
        'analytics': [
          {'mainAnalitycs': analyticsList}
        ],
      });
    }
    DashboardRepository().calculateSavings();
  }

  Future<void> checkMonth() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();

    final collectionRef =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(aCollection).get();

    if (collectionRef.docs.isNotEmpty) {
      final dashboardDoc = collectionRef.docs.first;
      final dashboardData = dashboardDoc.data();
      final analyticsList = dashboardData['analytics'][0]['mainAnalitycs'];

      // Get the current month and year
      DateTime currentDate = DateTime.now();
      int currentMonth = currentDate.month;
      int currentYear = currentDate.year;

      print("CRON:Dzisiejsza data Miesiąc/Rok: $currentMonth/$currentYear");

      bool dataMoved = false; // To track if data was moved to last month

      for (var analytics in analyticsList) {
        final currentMonthData = analytics['currentMonth'];
        // Get the stored month and year from the data
        int storedMonth = currentMonthData[0]['numberOfMonth'];
        int storedYear = currentYear;

        if (storedMonth == 1) {
          storedYear -= 1;
        }

        print("CRON:Aktualna data w bazie LastMonth Miesiąc/Rok: $storedMonth/$storedYear");

        if (currentMonth != storedMonth || currentYear != storedYear) {
          // If the month or year does not match, move data to last month
          await moveDataToLastMonth();
          dataMoved = true;
          print("CRON:Last Month został zaktualizowany.");
        }
      }

      if (!dataMoved) {
        print("CRON:Nie trzeba updatować , wszystko jest w porządku w Last Month");
      }
    } else {
      print("CRON:Collection is empty, method did not execute.");
    }
  }

  Future<void> updateCategoryName(String newName) async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();
    final result = await firestore.collection(mainCollection).doc(userID).collection(aCollection).get();
    // Pobieranie dokumentu z wydatkami użytkownika.

    for (var expensesDoc in result.docs) {
      final expensesData = expensesDoc.data();
      final expensesCategories = expensesData['analytics'][0]['mainAnalitycs'];

      if (expensesCategories != null) {
        for (var categoryData in expensesCategories) {
          // Znaleziono kategorię o ID 1, zmień jej nazwę
          categoryData['customCategoryName'] = newName;

          final updatedProfilesData = expensesCategories.map((categoryData) {
            if (categoryData['customCategoryName'] != null) {
              // Replace '1' with the appropriate condition to identify the element to update
              return {
                ...categoryData,
                'customCategoryName': newName,
              };
            }
            return categoryData;
          }).toList(); // Convert the mapped Iterable back to a List

          await expensesDoc.reference.update({
            aCollection: [
              {
                ...expensesData['analytics'][0],
                'mainAnalitycs': updatedProfilesData,
              },
            ],
          });

          print('Wykonalo sie');
          break; // Przerwij pętlę po zaktualizowaniu nazwy
        }
      }
      setCustomCategoryNameForCategory1();
    }
  }

  Future<void> setCustomCategoryNameForCategory1() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final result =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(aCollection).get();

    if (result.docs.isNotEmpty) {
      final dashboardDoc = result.docs.first;
      final dashboardData = dashboardDoc.data();
      final analyticsList = dashboardData['analytics'][0]['mainAnalitycs'];
      final newCustomCategoryName = analyticsList[0]['customCategoryName'];
      for (var analytics in analyticsList) {
        final currentMonthData = analytics['currentMonth'];
        final lastMonthData = analytics['lastMonth'];

        for (var categoryData in currentMonthData[0]['categories']) {
          if (categoryData != null && categoryData['id'] == 1) {
            // Set the new custom category name
            categoryData['name'] = newCustomCategoryName;
          }
        }

        for (var categoryData in lastMonthData[0]['categories']) {
          if (categoryData != null && categoryData['id'] == 1) {
            // Set the new custom category name
            categoryData['name'] = newCustomCategoryName;
          }
        }
      }

      // Update the changes back to the database
      await dashboardDoc.reference.update({
        'analytics': [
          {'mainAnalitycs': analyticsList}
        ],
      });
    }
  }
}
