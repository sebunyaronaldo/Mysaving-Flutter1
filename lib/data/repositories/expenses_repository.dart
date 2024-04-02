import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysavingapp/data/repositories/interfaces/IExpensesRepository.dart';
import 'package:mysavingapp/config/services/user_manager.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_model.dart';
import '../models/expenses_model.dart';
import 'dashboard_repository.dart';

class ExpensesRepository extends IExpensesRepository {
  final String? uid;
  ExpensesRepository({this.uid});
  String mainCollection = dotenv.env['MAIN_COLLECTION']!;
  String eCollection = dotenv.env['E_COLLECTION']!;
  String eSubCollection = dotenv.env['E_CAT']!;

  Future<void> updateUserData(List<Category> categories) async {
    final CollectionReference expenseCollection = FirebaseFirestore.instance.collection(mainCollection);
// Tworzenie referencji do kolekcji wydatków w Firestore.
    List<Map<String, dynamic>> categoriesData = categories.map((category) {
      List<Map<String, dynamic>> expensesData = category.expenses!.map((expense) {
        return {'name': expense.name, 'cost': expense.cost, 'time': expense.expensesTime};
      }).toList();

      int totalCosts = category.expenses!.fold(0, (int previousValue, expense) => previousValue + expense.cost!);
      // Obliczanie łącznego kosztu dla danej kategorii.

      category.costs = totalCosts;

      return {
        'id': category.id,
        'name': category.name,
        'url': category.url,
        'costs': totalCosts,
        eCollection: expensesData,
      };
    }).toList();
// Tworzenie listy danych kategorii wydatków w odpowiednim formacie do zapisu w Firestore.

    DocumentReference userExpenseDoc = expenseCollection.doc(uid);
    CollectionReference userExpensesCol = userExpenseDoc.collection(eCollection);
// Tworzenie referencji do dokumentu użytkownika w kolekcji wydatków.

    await userExpensesCol.add({
      'id': uid,
      'costs': categories.fold(0, (int previousValue, category) => previousValue + category.costs!),
      eSubCollection: categoriesData,
    });
// Dodawanie nowego dokumentu do kolekcji wydatków użytkownika zawierającego informacje o łącznym koszcie oraz listę danych kategorii.
  }

  @override
  Future<List<Category>> getCategory() {
    throw UnimplementedError();
  }
// Metoda getCategory jest niezaimplementowana.

  @override
  Future<List<Expenses>> getExpenses() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
// Pobieranie UID użytkownika za pomocą UserManage.
    List<Expenses> expensesList = [];
    final result = await firestore.collection(mainCollection).doc(userID).collection(eCollection).get();
// Pobieranie dokumentu z wydatkami użytkownika.

    for (var expensesDoc in result.docs) {
      final expensesData = expensesDoc.data();
      final expensesCategories = expensesData[eSubCollection];
      // Pobieranie danych kategorii wydatków.

      if (expensesCategories != null) {
        List<Category> categoryList = [];
        for (var categoryData in expensesCategories) {
          List<Expense> expenseList = [];
          for (var expenseData in categoryData[eCollection]) {
            Expense expense = Expense.fromJson(expenseData);
            expenseList.add(expense);
          }
          // Tworzenie listy obiektów Expense na podstawie danych wydatków.

          Category category = Category.fromJson(categoryData);
          category.expenses = expenseList;
          categoryList.add(category);
          // Tworzenie obiektu Category na podstawie danych kategorii i dodawanie go do listy kategorii.
        }

        Expenses userExpenses = Expenses(
          id: int.tryParse(expensesData['id'].toString()),
          costs: int.tryParse(expensesData['costs'].toString()),
          categories: categoryList,
        );
        expensesList.add(userExpenses);
        // Tworzenie obiektu Expenses na podstawie danych wydatków użytkownika i dodawanie go do listy wydatków.
      }
    }
    return expensesList;
// Zwracanie listy wydatków.
  }

  @override
  Future<void> addExpense(String name, int cost, int categoryId) async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
// Pobieranie UID użytkownika za pomocą UserManager.
    final result = await firestore.collection(mainCollection).doc(userID).collection(eCollection).get();
// Pobieranie dokumentu z wydatkami użytkownika.

    for (var expensesDoc in result.docs) {
      final expensesData = expensesDoc.data();
      final expensesCategories = expensesData[eSubCollection];
      // Pobieranie danych kategorii wydatków.

      if (expensesCategories != null) {
        for (var categoryData in expensesCategories) {
          if (categoryData != null) {
            final categoryIdData = categoryData['id'];
            if (categoryIdData != null && categoryIdData == categoryId) {
              List<dynamic> expenses = List.from(categoryData[eCollection] ?? []);
              // Tworzenie listy wydatków danej kategorii.

              Expense expense = Expense(
                name: name,
                cost: cost,
                expensesTime: Timestamp.now(),
              );
              expenses.add(expense.toMap());
              // Dodawanie nowego wydatku do listy.

              categoryData[eCollection] = expenses;
              // Aktualizacja danych wydatków w kategorii.

              await expensesDoc.reference.update({eSubCollection: expensesCategories});
              // Aktualizacja dokumentu z wydatkami w Firestore.
              await calculateAllExpenses();

              // Dodawanie wydatku do Dashboard Analytics w odpowiednim dniu tygodnia
              DateTime now = DateTime.now();
              String dayName = DateFormat('EEE').format(now);
              int dayIndex = DateFormat('EE').parse(dayName).weekday;
              DashboardAnalitycsDay day = DashboardAnalitycsDay(
                name: dayName,
                id: dayIndex,
                saldo: 0, // Możesz tutaj wstawić odpowiednią wartość salda i oszczędności w danym dniu.
                saving: 0,
                expenses: cost,
                date: now.toString(),
              );
              await DashboardRepository(uid: uid).updateDashboardAnalytics(day);
              break;
            }
          }
        }
      }
    }
  }

  @override
  Future<void> calculateAllExpenses() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    // Pobieranie UID użytkownika za pomocą UserManager.
    final result = await firestore.collection(mainCollection).doc(userID).collection(eCollection).get();
    // Pobieranie dokumentu z wydatkami użytkownika.

    for (var expensesDoc in result.docs) {
      final expensesData = expensesDoc.data();
      final expensesCategories = expensesData[eSubCollection];
      // Pobieranie danych kategorii wydatków.

      if (expensesCategories != null) {
        double totalExpensesCosts = 0;
        for (var categoryData in expensesCategories) {
          List<dynamic> categoryExpenses = categoryData[eCollection];
          double categoryExpensesCosts =
              categoryExpenses.map((expenseData) => (expenseData['cost'] ?? 0)).fold(0.0, (a, b) => a + b);

          totalExpensesCosts += categoryExpensesCosts;

          categoryData['costs'] = categoryExpensesCosts;
        }

        await expensesDoc.reference.update({
          'costs': totalExpensesCosts,
        });
        // Update the 'costs' field in the Firestore document with the total expenses costs and update the expensesCategories with the updated category expenses.
      }
    }
  }

  Future<void> updateCategoryName(String newName) async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();
    final result = await firestore.collection(mainCollection).doc(userID).collection(eCollection).get();
    // Pobieranie dokumentu z wydatkami użytkownika.

    for (var expensesDoc in result.docs) {
      final expensesData = expensesDoc.data();
      final expensesCategories = expensesData[eSubCollection];

      if (expensesCategories != null) {
        for (var categoryData in expensesCategories) {
          final int categoryId = categoryData['id'];

          if (categoryId == 1) {
            // Znaleziono kategorię o ID 1, zmień jej nazwę
            categoryData['name'] = newName;

            // Aktualizuj dane kategorii w Firestore
            await expensesDoc.reference.update({eSubCollection: expensesCategories});
            print('Wykonalo sie');
            break; // Przerwij pętlę po zaktualizowaniu nazwy
          }
        }
      }
    }
  }
}
