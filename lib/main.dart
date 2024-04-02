import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mysavingapp/config/routes/mysaving_routes.dart';
import 'package:mysavingapp/common/theme/theme_constants.dart';
import 'package:mysavingapp/data/repositories/Analytics_Repository.dart';
import 'package:mysavingapp/data/repositories/auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysavingapp/data/repositories/dashboard_repository.dart';
import 'package:mysavingapp/data/repositories/expenses_repository.dart';
import 'package:mysavingapp/l10n/l10n.dart';
import 'package:mysavingapp/l10n/locale_provider.dart';
import 'package:mysavingapp/pages/analitycs/config/cubit/analitycs_cubit.dart';
import 'package:mysavingapp/pages/expenses/config/cubit/expense_cubit.dart';
import 'package:mysavingapp/pages/main_page/main_page.dart';
import 'package:mysavingapp/pages/settings/pages/general/general_settings.dart';
import 'package:mysavingapp/pages/settings/settings.dart';
import 'package:provider/provider.dart';
import 'bloc/app_bloc.dart';
import 'common/theme/bloc/theme_bloc.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'data/repositories/Statistic_Repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DarkModeSwitch.initDarkMode(); // Initialize dark mode

  bool isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  await dotenv.load();

  String androidApiKey = dotenv.env['ANDROID_API_KEY']!;
  String androidAppId = dotenv.env['ANDROID_APP_ID']!;
  String androidMessagingSenderId = dotenv.env['ANDROID_MESSAGING_SENDER_ID']!;
  String androidProjectId = dotenv.env['ANDROID_PROJECT_ID']!;
  String androidStorageBucket = dotenv.env['ANDROID_STORAGE_BUCKET']!;

  String iosApiKey = dotenv.env['IOS_API_KEY']!;
  String iosAppId = dotenv.env['IOS_APP_ID']!;
  String iosMessagingSenderId = dotenv.env['IOS_MESSAGING_SENDER_ID']!;
  String iosProjectId = dotenv.env['IOS_PROJECT_ID']!;
  String iosStorageBucket = dotenv.env['IOS_STORAGE_BUCKET']!;
  String iosClientId = dotenv.env['IOS_CLIENT_ID']!;
  String iosBundleId = dotenv.env['IOS_BUNDLE_ID']!;

  await Firebase.initializeApp(
    options: isAndroid
        ? FirebaseOptions(
            apiKey: androidApiKey,
            appId: androidAppId,
            messagingSenderId: androidMessagingSenderId,
            projectId: androidProjectId,
            storageBucket: androidStorageBucket,
          )
        : FirebaseOptions(
            apiKey: iosApiKey,
            appId: iosAppId,
            messagingSenderId: iosMessagingSenderId,
            projectId: iosProjectId,
            storageBucket: iosStorageBucket,
            iosClientId: iosClientId,
            iosBundleId: iosBundleId,
          ),
  );
  final authRepository = AuthRepository();
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: MyApp(
        authRepository: authRepository,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AuthRepository _authRepository;

  MyApp({Key? key, required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
// Default locale

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("App initialized");
    StatisticRepository().checkTodayDateAndExecuteUpdate();
    AnalyticsRepository().checkMonth();
    DashboardRepository().checkWeek();
    Provider.of<LocaleProvider>(context, listen: false).loadSavedLocale();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    print("App is running: false");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Set the app as running when resumed
      print("App is running: true");

      // Call your method to check and update statistics
      StatisticRepository().checkTodayDateAndExecuteUpdate();
      AnalyticsRepository().checkMonth();
      DashboardRepository().checkWeek();
      Provider.of<LocaleProvider>(context, listen: false).loadSavedLocale();

      // Noti.showBigTextNotification(
      //     title: "New message title",
      //     body: "Your long body",
      //     fln: flutterLocalNotificationsPlugin);
    } else if (state == AppLifecycleState.paused) {
      // Set the app as not running when paused
      print("App is running: false");
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    DarkModeSwitch.initDarkMode();
    return RepositoryProvider.value(
      value: widget._authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => DarkModeBloc(),
          ),
          BlocProvider(
            create: (_) => AppBloc(authRepository: widget._authRepository),
          ),
          BlocProvider(
            create: (context) => ExpenseCubit(expensesRepository: ExpensesRepository()),
          ),
          BlocProvider(
            create: (context) => AnalitycsCubit(analitycsRepository: AnalyticsRepository()),
          ),
          ChangeNotifierProvider<LocaleProvider>(
            create: (context) => LocaleProvider(),
          )
        ],
        child: AppView(
          locale: Locale('en') // Default locale
          ,
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key, this.locale});
  final Locale? locale;
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, child, appState) {
        return MaterialApp(
          routes: {
            '/main': (context) => MainPage(),
            '/settings': (context) => SettingsScreen(),
            '/generalSettings': (context) => GeneralSettingsPage(),
            // Add other named routes for your screens
          },
          // theme: themeNotifier.getTheme(),
          debugShowCheckedModeBanner: false,
          title: 'Go router',
          supportedLocales: L10n.all,
          locale: Provider.of<LocaleProvider>(context).locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate
          ],
          home: FlowBuilder(
            onGeneratePages: onGeneratedMysavingViewPages,
            state: context.select((AppBloc bloc) => bloc.state.status),
          ),
        );
      },
    );
  }
}
