import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysavingapp/data/models/Statistic_Model.dart';
import 'package:mysavingapp/data/models/dashboard_model.dart';
import 'package:mysavingapp/data/models/premium_user_model.dart';
import 'package:mysavingapp/data/models/profile_model.dart';
import 'package:mysavingapp/data/models/settings_model.dart';
import 'package:mysavingapp/data/repositories/Analytics_Repository.dart';
import 'package:mysavingapp/data/repositories/Statistic_Repository.dart';
import 'package:mysavingapp/data/repositories/dashboard_repository.dart';
import 'package:mysavingapp/data/repositories/expenses_repository.dart';
import 'package:mysavingapp/data/repositories/premium_user_repository.dart';
import 'package:mysavingapp/data/repositories/profile_repository.dart';
import 'package:mysavingapp/data/repositories/settings_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/Analytics_Model.dart';
import '../models/expenses_model.dart';
import '../models/user_model.dart';
import '../../config/services/user_manager.dart';
import 'package:intl/intl.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  var currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });
  }

  Future<void> signUp({required String email, required String password, required String name}) async {
    try {
      final firebase_auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      List<UserProfile> profile = [
        UserProfile(pictureImage: '', name: name, password: password, email: email, dateOfBirth: '', id: 1)
      ];
      String uid = userCredential.user!.uid;
      UserManager().setUID(uid);
      await _createInitialUserData(uid);
      await ProfileRepository(uid: uid).updateUserData(profile);
      print('Expenses data has been updated for the user with UID: $uid');
    } catch (error) {
      print('Błąd podczas logowania lub rejestracji: $error');
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

  Future<void> singIn({required String email, required String password}) async {
    try {
      final firebase_auth.UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;

      UserManager().setUID(uid);
    } catch (error) {
      print('Błąd w funkcji: $error');
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (_) {}
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    final firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final firebase_auth.UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
    final firebase_auth.User user = authResult.user!;
    assert(!user.isAnonymous);
    final firebase_auth.User currentUser = _firebaseAuth.currentUser!;
    assert(user.uid == currentUser.uid);
    // Check if this is the first login for the user
    final DocumentSnapshot userDataSnapshot =
        await FirebaseFirestore.instance.collection('mainCollection').doc(user.uid).get();

    if (!userDataSnapshot.exists) {
      List<UserProfile> profile = [
        UserProfile(pictureImage: '', name: user.displayName!, password: '', email: user.email!, dateOfBirth: '', id: 1)
      ];
      String uid = user.uid;
      UserManager().setUID(uid);
      await _createInitialUserData(uid);
      await ProfileRepository(uid: uid).updateUserData(profile);
    }
    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<bool> get appleSingInAvailable => SignInWithApple.isAvailable();
  Future<bool> checkAuthentication() async {
    // Get the current user from the user stream
    final currentUser = await _firebaseAuth.currentUser;

    // Return true if the user is not null (authenticated), else return false
    return currentUser != null;
  }

  Future<void> _createInitialUserData(String uid) async {
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
        name: 'Shopping',
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
        name: 'InTheCity',
        url: 'assets/images/categories/headphones.png',
        expenses: [],
        costs: 0,
      ),
      Category(
        id: 5,
        name: 'Bills',
        url: 'assets/images/categories/device.png',
        expenses: [],
        costs: 0,
      ),
    ];

    List<DashboardModel> dashboard = [
      DashboardModel(
          dashboardSummary: [
            DashboardSummary(id: 1, saldo: 0, saving: 0, expenses: 0, addedSavings: 0),
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

    print('Initial user data has been created for the user with UID: $uid');
  }

  Future<String> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final firebase_auth.UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
      final firebase_auth.User user = authResult.user!;

      // Check if this is the first login for the user
      final DocumentSnapshot userDataSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (!userDataSnapshot.exists) {
        // Perform initial user data setup
        List<UserProfile> profile = [
          UserProfile(
              pictureImage: '', name: user.displayName!, password: '', email: user.email!, dateOfBirth: '', id: 1)
        ];
        await _createInitialUserData(user.uid);
        UserManager().setUID(user.uid);
        await ProfileRepository(uid: user.uid).updateUserData(profile);
      }

      return 'registerWithGoogle succeeded: $user';
    } catch (error) {
      // Handle error
      return 'registerWithGoogle failed: $error';
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
        // Password updated successfully
      } else {
        // No user is currently signed in
        // Handle this case (e.g., prompt the user to sign in)
      }
    } catch (error) {
      print('Error changing password: $error');
      // Handle the error (e.g., display an error message to the user)
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully
    } catch (error) {
      print('Error sending password reset email: $error');
      // Handle the error (e.g., display an error message to the user)
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName);
  }
}
