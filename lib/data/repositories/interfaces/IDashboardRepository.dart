import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysavingapp/data/models/dashboard_model.dart';

abstract class IDashboardRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<DashboardAnalytics>> getDashboardAnalitycs();
  Future<List<DashboardSummary>> getDashboardSummary();
  Future<void> addSaldo(int saldo);
  Future<void> calculateSavings();
  Future<void> calculateExpenses();
  Future<void> setBalanceWithTimer(int newBalance);
  Future<void> setMaxExpensesPerDay(int maxExpensesPerDay);
  Future<void> addToSavings(int amount);
}
