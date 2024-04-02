import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysavingapp/data/repositories/premium_user_repository.dart';
import 'package:mysavingapp/data/repositories/profile_repository.dart';
import 'package:mysavingapp/data/repositories/settings_repository.dart';

import '../../config/services/user_manager.dart';
import '../models/Analytics_Model.dart';
import '../models/Statistic_Model.dart';
import '../models/dashboard_model.dart';
import '../models/expenses_model.dart';
import '../models/premium_user_model.dart';
import '../models/profile_model.dart';
import '../models/settings_model.dart';
import 'Analytics_Repository.dart';
import 'Statistic_Repository.dart';
import 'dashboard_repository.dart';
import 'expenses_repository.dart';
import 'package:intl/intl.dart';

class GoogleRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential firebaseUser = await _firebaseAuth.signInWithCredential(credential);
      User? user = firebaseUser.user;
      // Check if the user is already registered

      if (user != null) {
        if (firebaseUser.additionalUserInfo!.isNewUser) {
          String uid = firebaseUser.user!.uid;
          UserManager().setUID(uid);
          await _registerUser(firebaseUser.user!, firebaseUser.user!.uid);
        }
        // User is not registered, so create a new account
      }
      String uid = firebaseUser.user!.uid;
      UserManager().setUID(uid);
      return firebaseUser;
    } catch (e) {
      print('Sign-in with Google error: $e');
      throw e;
    }
  }

  Future<void> _registerUser(User user, String uid) async {
    try {
      // Check if the user already exists in the main collection
      final mainCollectionDoc = await _firestore.collection('mainCollection').doc(uid).get();

      if (mainCollectionDoc.exists) {
        // User already exists, do not create duplicate data
        print('User with UID $uid already exists.');
        return;
      } else {
        // User doesn't exist in the main collection, create data
        List<UserProfile> profile = [
          UserProfile(
            pictureImage: '',
            name: user.displayName!,
            password: '',
            email: user.email!,
            dateOfBirth: '',
            id: 1,
          )
        ];

        await ProfileRepository(uid: uid).updateUserData(profile);
        print('User with UID $uid has been registered.');

        await _createInitialUserData(uid);
      }
    } catch (error) {
      print('Error during registration: $error');
    }
  }

  Future<void> _createInitialUserData(String uid) async {
    // Check if the user already exists in the main collection
    final mainCollectionDoc = await _firestore.collection('mainCollection').doc(uid).get();

    if (mainCollectionDoc.exists) {
      // User already exists, do not create duplicate data
      print('User with UID $uid already exists.');
      return;
    } // Check other collections associated with the user profile
    final profileCollectionDoc = await _firestore.collection('profile').doc(uid).get();
    final premiumCollectionDoc = await _firestore.collection('premium').doc(uid).get();
    final settingsCollectionDoc = await _firestore.collection('settings').doc(uid).get();
    final analyticsCollectionDoc = await _firestore.collection('analytics').doc(uid).get();
    final statisticCollectionDoc = await _firestore.collection('statistics').doc(uid).get();
    final dashboardCollectionDoc = await _firestore.collection('dashboard').doc(uid).get();
    final expensesCollectionDoc = await _firestore.collection('expenses').doc(uid).get();

    if (profileCollectionDoc.exists ||
        premiumCollectionDoc.exists ||
        settingsCollectionDoc.exists ||
        analyticsCollectionDoc.exists ||
        statisticCollectionDoc.exists ||
        dashboardCollectionDoc.exists ||
        expensesCollectionDoc.exists) {
      print('User data for UID $uid already exists in one of the collections.');
    } else {
      List<Category> categories = [
        Category(
          id: 1,
          name: 'No name',
          url: 'assets/images/categories/home.png',
          expenses: [],
          costs: 0,
        ),
        Category(
          id: 2,
          name: 'Food',
          url: 'assets/images/categories/coffe.png',
          expenses: [],
          costs: 0,
        ),
        Category(
          id: 3,
          name: 'Addictions',
          url: 'assets/images/categories/smoke.png',
          expenses: [],
          costs: 0,
        ),
        Category(
          id: 4,
          name: 'Events',
          url: 'assets/images/categories/headphones.png',
          expenses: [],
          costs: 0,
        ),
        Category(
          id: 5,
          name: 'Charges',
          url: 'assets/images/categories/device.png',
          expenses: [],
          costs: 0,
        ),
      ];

      List<DashboardModel> dashboard = [
        DashboardModel(
            dashboardSummary: [
              DashboardSummary(id: 1, saldo: 0, saving: 0, expenses: 0),
            ],
            id: "1",
            dashboardAnalytics: [
              DashboardAnalytics(
                maxExpensesPerDay: 600,
                summary: calculateAnalyticsForWeek(categories),
              ),
            ])
      ];

      List<PremiumUser> premium = [PremiumUser(silverUser: 0, goldUser: 0, diamondUser: 0, id: 1)];

      List<SettingsModel> settings = [
        SettingsModel(
            general: [GeneralSettings(country: 'Poland', currency: 'PLN', language: 'Polish')],
            notifications: [NotificationsSettings(notifications: 0)],
            id: 1)
      ];

// Get the current month and last month
      DateTime currentDate = DateTime.now();
      DateTime lastMonthDate = DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
      // Format the month names
      String currentMonthName = DateFormat('MMMM').format(currentDate);
      String lastMonthName = DateFormat('MMMM').format(lastMonthDate);

// Generate analytics data for current month and last month
// Format the month and year as "mm-rrrr"
      String currentMonthFormatted = DateFormat('MM-yyyy').format(currentDate);
      String lastMonthFormatted = DateFormat('MM-yyyy').format(lastMonthDate);

// Create the AnalyticsModel object
      List<AnalitycsModel> analytics = [
        AnalitycsModel(
          id: "1",
          mainAnalytics: [
            MainAnalitycs(
              customCategoryName: 'No name',
              lastmonth: [
                LastMonth(
                    date: lastMonthFormatted,
                    totalCosts: 0,
                    numberOfMonth: lastMonthDate.month,
                    id: 2,
                    name: lastMonthName,
                    expenses: 0,
                    categories: categories),
              ],
              currentmonth: [
                CurrentMonth(
                    date: currentMonthFormatted,
                    totalCosts: 0,
                    numberOfMonth: currentDate.month,
                    id: 1,
                    name: currentMonthName,
                    expenses: 0,
                    categories: categories)
              ],
            ),
          ],
        )
      ];
      List<StatisticMainModel> statistics = [
        StatisticMainModel(id: "1", analitycsStatistics: [
          StatisticsModel(
            date: Timestamp.now(),
            today: 0,
            yesterday: 0,
            beforeYesterday: 0,
            id: 1,
            total: 0,
          )
        ])
      ];

      // Create initial data entries for categories, dashboard, profile, etc.
      await ExpensesRepository(uid: uid).updateUserData(categories);
      await DashboardRepository(uid: uid).updateUserData(dashboard);
      await PremiumUserRepository(uid: uid).updateUserData(premium);
      await SettingsRepository(uid: uid).updateUserData(settings);
      await AnalyticsRepository(uid: uid).addAnalyticsData(analytics);
      await StatisticRepository(uid: uid).addStatisticData(statistics);
      print('Wykonalo sie mimo ze uzytkownik istienje: $uid');

      print('Initial user data has been created for the user with UID: $uid');
    }
  }

  List<DashboardAnalitycsDay> calculateAnalyticsForMonth(
    List<Category> categories,
    DateTime monthDate,
  ) {
    List<DashboardAnalitycsDay> monthAnalytics = [];

    // Get the first day of the month
    DateTime firstDayOfMonth = DateTime(monthDate.year, monthDate.month, 1);

    // Generate data for 30 consecutive days
    for (int i = 0; i < 30; i++) {
      DateTime day = firstDayOfMonth.add(Duration(days: i));

      int expenses = 0;
      int saldo = 0;
      int saving = 0;

      String formattedDate =
          '${day.year.toString()}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
// Get the name of the day
      String name = DateFormat('EEEE').format(day);
      for (Category category in categories) {
        for (Expense expense in category.expenses!) {
          DateTime expenseDate = expense.expensesTime!.toDate();
          if (expenseDate.year == day.year && expenseDate.month == day.month && expenseDate.day == day.day) {
            expenses += expense.cost!;
          }
        }
      }

      monthAnalytics.add(
        DashboardAnalitycsDay(
          name: name,
          date: formattedDate,
          expenses: expenses,
          id: i + 1,
          saldo: saldo,
          saving: saving,
        ),
      );
    }

    return monthAnalytics;
  }

  List<DashboardAnalitycsDay> calculateAnalyticsForWeek(List<Category> categories) {
    List<DashboardAnalitycsDay> weekAnalytics = [];
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    for (int i = 0; i < 7; i++) {
      DateTime day = monday.add(Duration(days: i));

      int expenses = 0;
      int saldo = 0;
      int saving = 0;

      String formattedDate =
          '${day.year.toString()}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
// Get the name of the day
      String name = DateFormat('EEEE').format(day);
      for (Category category in categories) {
        for (Expense expense in category.expenses!) {
          DateTime expenseDate = expense.expensesTime!.toDate();
          if (expenseDate.year == day.year && expenseDate.month == day.month && expenseDate.day == day.day) {
            expenses += expense.cost!;
          }
        }
      }

      weekAnalytics.add(
        DashboardAnalitycsDay(
          name: name,
          date: formattedDate,
          expenses: expenses,
          id: i + 1,
          saldo: saldo,
          saving: saving,
        ),
      );
    }

    return weekAnalytics;
  }
}
