import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysavingapp/data/models/settings_model.dart';

abstract class ISettingsRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<GeneralSettings>> getGeneral();
  Future<List<NotificationsSettings>> getNotification();
  Future<void> updateLanguage(String language);
}
