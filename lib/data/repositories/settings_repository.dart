import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysavingapp/data/models/settings_model.dart';
import 'package:mysavingapp/data/repositories/interfaces/ISettingsRepository.dart';

import '../../config/services/user_manager.dart';

class SettingsRepository extends ISettingsRepository {
  final String? uid;

  SettingsRepository({this.uid});
  String mainCollection = dotenv.env['MAIN_COLLECTION']!;
  String sCollection = dotenv.env['S_COLLECTION']!;
  String sSubCollection = dotenv.env['S_SUBCOLLECTION']!;
  String sNt = dotenv.env['S_NT']!;
  String sGe = dotenv.env['S_GE']!;
  Future<void> updateUserData(List<SettingsModel> settings) async {
    final CollectionReference expenseCollection = FirebaseFirestore.instance.collection(mainCollection);
    List<Map<String, dynamic>> settingsData = settings.map((setting) {
      List<Map<String, dynamic>> settingsGeneral = setting.general.map((general) {
        return {
          'language': general.language,
          'currency': general.currency,
          'country': general.country,
        };
      }).toList();

      List<Map<String, dynamic>> settingsNotifications = setting.notifications.map((notification) {
        return {sNt: notification.notifications};
      }).toList();

      return {
        'id': setting.id,
        sGe: settingsGeneral,
        sNt: settingsNotifications,
      };
    }).toList();

    // Tworzymy nowy dokument w kolekcji "expenses" z UID użytkownika jako ID dokumentu
    DocumentReference userExpenseDoc = expenseCollection.doc(uid);
    CollectionReference userDashboardCol = userExpenseDoc.collection(sCollection);

    await userDashboardCol.add({
      sSubCollection: settingsData,
    });
  }

  @override
  Future<List<GeneralSettings>> getGeneral() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    List<GeneralSettings> dashboardList = [];
    final result = await firestore.collection(mainCollection).doc(userID).collection(sCollection).get();
    for (var dashboardDoc in result.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData['dashboards'][0]['general'];

      if (dashboardSummary != null) {
        GeneralSettings dashboardSummaryModel = GeneralSettings.fromJson(dashboardSummary);

        dashboardList.add(dashboardSummaryModel);
        print(dashboardSummary);
      }
    }

    return dashboardList;
  }

  @override
  Future<List<NotificationsSettings>> getNotification() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateLanguage(String language) async {
    UserManager userManager = UserManager();
    String? userID = await userManager.getUID();
    final collectionRef = FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(sCollection);
    final querySnapshot = await collectionRef.get();
    for (var dashboardDoc in querySnapshot.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData['dashboards'][0]['general'];
      if (dashboardSummary != null) {
        final updatedProfilesData = dashboardSummary.map((profile) {
// Get current savings
          String newLanguage = language; // Add the amount to savings
          return {
            ...profile,
            'language': newLanguage,
          };
        }).toList();

        await dashboardDoc.reference.update({
          'dashboards': [
            {
              ...dashboardData['dashboards'][0],
              'general': updatedProfilesData,
            },
          ],
        });

        print('Ustawiono $language jako jezyk domyslny.');
      }
    }
  }

  Future<String> getLanguage() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final result =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(sCollection).get();

    String language = '';

    for (var dashboardDoc in result.docs) {
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData['dashboards'][0]['general'];

      if (dashboardSummary != null) {
        final dashboardLanguage = dashboardSummary['language'];
        if (dashboardLanguage != null) {
          language = dashboardLanguage;
          print(dashboardSummary);
          break; // Exit the loop once language is found
        }
      }
    }

    return language;
  }
}
