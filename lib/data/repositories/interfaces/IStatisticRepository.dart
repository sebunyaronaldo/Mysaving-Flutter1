import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IStatisticRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
}
