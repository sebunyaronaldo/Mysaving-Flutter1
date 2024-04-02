import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysavingapp/data/repositories/interfaces/IDashboardRepository.dart';
import '../models/dashboard_model.dart';
import '../../config/services/user_manager.dart';

class DashboardRepository extends IDashboardRepository {
  final String? uid;

  DashboardRepository({this.uid});
  String mainCollection = dotenv.env['MAIN_COLLECTION']!; //Przekazywanie wartości string z plik .env
  String dCollection = dotenv.env['D_COLLECTION']!;
  String dSubCollection = dotenv.env['D_SUBCOLLECTION']!;
  String dSummary = dotenv.env['D_SUMMARY']!;
  String dAnalitycs = dotenv.env['D_ANALITYCS']!;
  String eCollection = dotenv.env['E_COLLECTION']!;
  String eSubCollection = dotenv.env['E_CAT']!;
  String aCollection = dotenv.env['A_COLLECTION']!;

  Future<void> updateUserData(List<DashboardModel> dashboards) async {
    final CollectionReference expenseCollection =
        FirebaseFirestore.instance.collection(mainCollection); // Deklaracja kolekcji głównej
    List<Map<String, dynamic>> dashboardData = dashboards.map((dashboard) {
      List<Map<String, dynamic>> dashboardSummary = dashboard.dashboardSummary!.map((summary) {
        return {
          'id': summary.id,
          'saldo': summary.saldo,
          'saving': summary.saving,
          'expenses': summary.expenses,
          'addedSavings': summary.addedSavings
        };
      }).toList();

      List<Map<String, dynamic>> dashboardAnalitycs = dashboard.dashboardAnalytics!.map((analitycs) {
        return {
          'maxExpensesPerDay': analitycs.maxExpensesPerDay,
          'summary': analitycs.summary.map((anali) {
            return {
              'id': anali.id,
              'name': anali.name,
              'saldo': anali.saldo,
              'expenses': anali.expenses,
              'saving': anali.saving,
              'date': anali.date.toString(),
            };
          }).toList(),
        };
      }).toList();

      return {
        'id': dashboard.id,
        'dashboardSummary': dashboardSummary,
        'dashboardAnalitycs': dashboardAnalitycs,
      };
    }).toList();

    // Tworzymy nowy dokument w kolekcji "dashboard" z UID użytkownika jako ID dokumentu
    DocumentReference userExpenseDoc = expenseCollection.doc(uid);
    CollectionReference userDashboardCol = userExpenseDoc.collection(dCollection);

    await userDashboardCol.add({
      'dashboards': dashboardData,
    });
  }

  @override
  Future<List<DashboardSummary>> getDashboardSummary() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    List<DashboardSummary> dashboardList = [];
    final result = await firestore.collection(mainCollection).doc(userID).collection(dCollection).get();
    for (var dashboardDoc in result.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData[dSubCollection][0][dSummary];

      if (dashboardSummary != null) {
        DashboardSummary dashboardSummaryModel = DashboardSummary.fromJson(dashboardSummary);

        dashboardList.add(dashboardSummaryModel);
      }
    }

    return dashboardList;
  }

  @override
  Future<List<DashboardAnalytics>> getDashboardAnalitycs() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    List<DashboardAnalytics> dashboardList = [];
    final result = await firestore.collection(mainCollection).doc(userID).collection(dCollection).get();
    for (var dashboardDoc in result.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardAnalitycs = dashboardData[dSubCollection][0][dAnalitycs];

      if (dashboardAnalitycs != null) {
        List<DashboardAnalitycsDay> summaryList = [];
        int maxExpensesPerDay = dashboardAnalitycs[0]['maxExpensesPerDay'];
        for (var dayData in dashboardAnalitycs[0]['summary']) {
          String dayName = dayData['date'];
          int dayIndex = int.parse(dayName.split('-')[0]);
          int monthIndex = int.parse(dayName.split('-')[1]);
          int yearIndex = int.parse(dayName.split('-')[2].split(' ')[0]);
          DateTime date = DateTime(yearIndex, monthIndex, dayIndex);

          DashboardAnalitycsDay day = DashboardAnalitycsDay(
            id: dayData['id'],
            name: dayData['name'],
            saldo: dayData['saldo'],
            saving: dayData['saving'],
            expenses: dayData['expenses'],
            date: date.toString(),
          );
          summaryList.add(day);
        }

        DashboardAnalytics dashboardAnalytics = DashboardAnalytics(
          maxExpensesPerDay: maxExpensesPerDay,
          summary: summaryList,
        );

        dashboardList.add(dashboardAnalytics);
      }
    }

    return dashboardList;
  }

  @override
  Future<void> addSaldo(int saldo) async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();

    final collectionRef = firestore.collection(mainCollection).doc(userID).collection(dCollection);
    final querySnapshot = await collectionRef.get();

    for (var dashboardDoc in querySnapshot.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData[dSubCollection][0][dSummary];

      final updatedProfilesData = dashboardSummary.map((profile) {
        return {
          ...profile,
          'saldo': saldo, // Replace 'downloadURL' with the updated image URL
        };
      }).toList();

      await dashboardDoc.reference.update({
        dSubCollection: [
          {
            ...dashboardData[dSubCollection][0],
            dSummary: updatedProfilesData,
          },
        ],
      });
    }
  }

  @override
  Future<void> calculateExpenses() async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();
    int totalExpenses = 0;

    final result = await firestore.collection(mainCollection).doc(userID).collection(aCollection).get();

    for (var expensesDoc in result.docs) {
      final expensesData = expensesDoc.data();
      final expensesCategories = expensesData['analytics'][0]['mainAnalitycs'];
      int categoryCost = expensesCategories[0]['currentMonth'][0]['totalCosts'].toInt();

      totalExpenses += categoryCost;
    }

    final collectionRef = firestore.collection(mainCollection).doc(userID).collection(dCollection);
    final querySnapshot = await collectionRef.get();

    for (var dashboardDoc in querySnapshot.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData[dSubCollection][0][dSummary];

      final updatedProfilesData = dashboardSummary.map((profile) {
        return {
          ...profile,
          'expenses': totalExpenses,
        };
      }).toList();

      await dashboardDoc.reference.update({
        dSubCollection: [
          {
            ...dashboardData[dSubCollection][0],
            dSummary: updatedProfilesData,
          },
        ],
      });
    }
  }

  Future<void> calculateSavings() async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();
    int expenses = 0;
    int saldo = 0;
    int savings = 0;
    int addedSavings = 0;
    final result =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(dCollection).get();

    for (var expensesDoc in result.docs) {
      final expensesData = expensesDoc.data()[dSubCollection][0][dSummary];
      final expensesCategories = expensesData[0]['saldo'];
      final expensesCategories2 = expensesData[0]['expenses'];
      final expenseCategories3 = expensesData[0]['addedSavings'];
      if (expensesData != null) {
        int updateSaldo = expensesCategories;
        saldo += updateSaldo;
        int updateExpenses = expensesCategories2;
        expenses += updateExpenses; // Corrected typo: use updateExpenses instead of updateSaldo here
        int updateAddedSavings = expenseCategories3;
        addedSavings += updateAddedSavings;
      }
    }

    int calculateSavings = saldo - expenses;
    savings = calculateSavings + addedSavings;

    final collectionRef = firestore.collection(mainCollection).doc(userID).collection(dCollection);
    final querySnapshot = await collectionRef.get();

    for (var dashboardDoc in querySnapshot.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData[dSubCollection][0][dSummary];

      final updatedProfilesData = dashboardSummary.map((profile) {
        // Replace '1' with the appropriate condition to identify the element to update
        return {
          ...profile,
          'saving': savings, // Replace 'downloadURL' with the updated image URL
        };
      }).toList();

      await dashboardDoc.reference.update({
        dSubCollection: [
          {
            ...dashboardData[dSubCollection][0],
            dSummary: updatedProfilesData,
          },
        ],
      });
    }
  }

  Future<void> updateDashboardAnalytics(DashboardAnalitycsDay day) async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();

    final result = await firestore.collection(mainCollection).doc(userID).collection(dCollection).get();

    DateTime today = DateTime.now(); // Get the current date

    for (var dashboardDoc in result.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardAnalitycs = dashboardData[dSubCollection][0][dAnalitycs];

      if (dashboardAnalitycs != null) {
        for (var dayData in dashboardAnalitycs[0]['summary']) {
          String summaryDateStr = dayData['date'];
          DateTime summaryDate = DateTime.parse(summaryDateStr);

          // Check if the summaryDate is equal to today's date
          if (isSameDay(summaryDate, today)) {
            dayData['expenses'] += day.expenses;
            await dashboardDoc.reference.update({
              dSubCollection: [
                {
                  ...dashboardData[dSubCollection][0],
                  dAnalitycs: dashboardAnalitycs,
                },
              ],
            });
            break;
          }
        }
      }
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String getDayOfWeek(dynamic date) {
    if (date is String) {
      final DateTime parsedDate = DateTime.parse(date);
      final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final currentWeekday = parsedDate.weekday - 1;
      final adjustedIndex = (currentWeekday + 1) % 7;
      return daysOfWeek[adjustedIndex];
    } else if (date is int) {
      final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final currentDayIndex = DateTime.now().weekday;
      final adjustedIndex = (date + currentDayIndex - 1) % 7;
      return daysOfWeek[adjustedIndex];
    }
    return '';
  }

  Future<void> setNextWeekInDashboardAnalyticsSummary() async {
    print('Running setNextWeekInDashboardAnalyticsSummary method...');
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();

    final result =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(dCollection).get();

    for (var dashboardDoc in result.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardAnalitycs = dashboardData[dSubCollection][0][dAnalitycs];

      if (dashboardAnalitycs != null) {
        for (var dayData in dashboardAnalitycs[0]['summary']) {
          DateTime summaryDate = DateTime.parse(dayData['date']);
          DateTime nextWeekDate = summaryDate.add(Duration(days: 7));
          // Get the first day of the month

          String formattedDate =
              '${nextWeekDate.year}-${nextWeekDate.month.toString().padLeft(2, '0')}-${nextWeekDate.day.toString().padLeft(2, '0')}';
          // Reset the expenses, saldo, and saving fields for the day
          dayData['expenses'] = 0;
          dayData['saldo'] = 0;
          dayData['saving'] = 0;

          // Update the date for next week
          dayData['date'] = formattedDate;
        }

        // Update the dashboard analytics in the database
        await dashboardDoc.reference.update({
          dSubCollection: [
            {
              ...dashboardData[dSubCollection][0],
              dAnalitycs: dashboardAnalitycs,
            },
          ],
        });
      }
    }
  }

  Future<void> checkWeek() async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();

    final result =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(dCollection).get();

    DateTime today = DateTime.now(); // Get the current date
    bool noMatchesFound = true; // Flag to track if any match is found

    for (var dashboardDoc in result.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardAnalitycs = dashboardData[dSubCollection][0][dAnalitycs];

      if (dashboardAnalitycs != null) {
        for (var dayData in dashboardAnalitycs[0]['summary']) {
          String summaryDateStr = dayData['date'];
          DateTime summaryDate = DateTime.parse(summaryDateStr);

          // Check if the summaryDate is equal to today's date
          if (isSameDay(summaryDate, today)) {
            // Do something with the matched date
            print('CRON:Znaleziono pasującą datę która występuje w tym tygodniowych statystkach: $summaryDateStr');
            noMatchesFound = false; // A match was found, update the flag
          }
        }
      }
    }
    if (noMatchesFound) {
      setNextWeekInDashboardAnalyticsSummary();
      print('CRON:Aktualizowanie tygodniowych statystyk...');
    }
  }

  Future<void> setBalanceWithTimer(int newBalance) async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();

    final collectionRef = firestore.collection(mainCollection).doc(userID).collection(dCollection);
    final querySnapshot = await collectionRef.get();

    for (var dashboardDoc in querySnapshot.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData[dSubCollection][0][dSummary];

      if (dashboardSummary != null) {
        final updatedProfilesData = dashboardSummary.map((profile) {
          return {
            ...profile,
            'saldo': newBalance,
          };
        }).toList();

        await dashboardDoc.reference.update({
          dSubCollection: [
            {
              ...dashboardData[dSubCollection][0],
              dSummary: updatedProfilesData,
            },
          ],
        });
        print('Balance updated with a timer.');
      } else {
        print('Cannot update balance. Timer not expired yet.');
      }
    }
  }

  Future<void> setMaxExpensesPerDay(int maxExpensesPerDay) async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();

    final result =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(dCollection).get();

    for (var dashboardDoc in result.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardAnalitycs = dashboardData[dSubCollection][0][dAnalitycs];

      if (dashboardAnalitycs != null) {
        // Print the current value of maxExpensesPerDay before updating
        print('Current maxExpensesPerDay: ${dashboardAnalitycs[0]['maxExpensesPerDay']}');

        // Update maxExpensesPerDay
        dashboardAnalitycs[0]['maxExpensesPerDay'] = maxExpensesPerDay;

        // Print the new value of maxExpensesPerDay after updating
        print('Updated maxExpensesPerDay: ${dashboardAnalitycs[0]['maxExpensesPerDay']}');

        // Update the document in the database
        await dashboardDoc.reference.update({
          dSubCollection: [
            {
              ...dashboardData[dSubCollection][0],
              dAnalitycs: dashboardAnalitycs,
            },
          ],
        });

        print('Max Expenses Per Day updated successfully.');
      } else {
        print('Cannot update Max Expenses Per Day. Dashboard Analytics not found.');
      }
    }
  }

  Future<void> addToSavings(int amount) async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();

    final collectionRef = FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(dCollection);
    final querySnapshot = await collectionRef.get();

    for (var dashboardDoc in querySnapshot.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData[dSubCollection][0][dSummary];

      if (dashboardSummary != null) {
        final updatedProfilesData = dashboardSummary.map((profile) {
          int currentSavings = profile['addedSavings'] ?? 0; // Get current savings
          int newSavings = currentSavings + amount; // Add the amount to savings
          return {
            ...profile,
            'addedSavings': newSavings,
          };
        }).toList();

        await dashboardDoc.reference.update({
          dSubCollection: [
            {
              ...dashboardData[dSubCollection][0],
              dSummary: updatedProfilesData,
            },
          ],
        });

        print('Added $amount to savings.');
      }
    }
  }
}
