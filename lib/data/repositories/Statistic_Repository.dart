import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysavingapp/data/models/Statistic_Model.dart';
import 'package:mysavingapp/data/repositories/interfaces/IStatisticRepository.dart';
import 'package:intl/intl.dart';

import '../../config/services/user_manager.dart';

class StatisticRepository extends IStatisticRepository {
  String mainCollection = dotenv.env['MAIN_COLLECTION']!;
  String sCollection = dotenv.env['ST_COLLECTION']!;
  final String? uid;

  StatisticRepository({this.uid});

  Future<void> addStatisticData(List<StatisticMainModel> analytics) async {
    final CollectionReference expenseCollection = FirebaseFirestore.instance.collection(mainCollection);

    // Get the current month and last month

    List<Map<String, dynamic>> analitycsData = analytics.map((analityc) {
      List<Map<String, dynamic>> analitycsStatistic =
          analityc.analitycsStatistics!.map((statistic) => statistic.toMap()).toList().toList();

      return {
        'id': analityc.id,
        'analitycsStatistic': analitycsStatistic,
      };
    }).toList();

    DocumentReference userExpenseDoc = expenseCollection.doc(uid);
    CollectionReference userDashboardCol = userExpenseDoc.collection(sCollection);

    await userDashboardCol.add({
      'statistics': analitycsData,
    });
  }

  Future<List<StatisticsModel>> getStatistic() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    List<StatisticsModel> statis = [];
    final result = await firestore.collection(mainCollection).doc(userID).collection('statistics').get();

    for (var analitycsDoc in result.docs) {
      final analitycsData = analitycsDoc.data();
      final analitycsStats = analitycsData['statistics'][0]['analitycsStatistic'];
      if (analitycsStats != null) {
        StatisticsModel statisticsModel = StatisticsModel.fromJson(analitycsStats);
        statis.add(statisticsModel);
      }
    }
    return statis;
  }

// Method to add an amount to today's statistics
  Future<void> addToStatistic(int amount) async {
    final CollectionReference analyticsCollection = FirebaseFirestore.instance.collection(mainCollection);
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final collectionRef = await analyticsCollection.doc(userID).collection(sCollection).get();

    if (collectionRef.docs.isNotEmpty) {
      final dashboardDoc = collectionRef.docs.first;
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData['statistics'][0]['analitycsStatistic'];

      final updatedProfilesData = dashboardSummary.map((profile) {
        final todayValue = profile['today'];
        print('todayValue type: ${todayValue.runtimeType}');

        return {
          ...profile,
          'today': todayValue + amount,
        };
      }).toList();

      await dashboardDoc.reference.update({
        'statistics': [
          {
            ...dashboardData['statistics'][0],
            'analitycsStatistic': updatedProfilesData,
          },
        ],
      });
    }
    // Recalculate the total after adding to today's value
    await calculateTotal();
  }

  // Method to update statistics daily at midnight
  Future<void> updateStatisticsDaily() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final collectionRef =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(sCollection).get();

    if (collectionRef.docs.isNotEmpty) {
      final dashboardDoc = collectionRef.docs.first;
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData[sCollection][0]['analitycsStatistic'];

      final updatedProfilesData = dashboardSummary.map((analits) {
        final todayValue = analits['today'];
        final yesterdayValue = analits['yesterday'];
        final beforeYesterdayValue = analits['beforeYesterday'];
        final total = todayValue + yesterdayValue + beforeYesterdayValue; // Calculate the new total
        print('Updating statistics daily...');
        print('Today value before update: $todayValue');
        print('Yesterday value before update: $yesterdayValue');
        print('BeforeYesterday value before update: $beforeYesterdayValue');
        print('Total value before update: $total');
        return {
          ...analits,
          'beforeYesterday': yesterdayValue,
          'yesterday': todayValue,
          'today': 0, // Reset today's value for the new day
          'todayDate': DateFormat('yyyy-MM-dd').format(DateTime.now()), // Update todayDate
        };
      }).toList();

      await dashboardDoc.reference.update({
        'statistics': [
          {
            ...dashboardData['statistics'][0],
            'analitycsStatistic': updatedProfilesData,
          },
        ],
      });
      print(' update: $updatedProfilesData');
    }
    // Recalculate the total after updating statistics daily
    await calculateTotal();
  }

  // Method to calculate the total value based on yesterday, beforeYesterday, and today
  Future<void> calculateTotal() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final collectionRef =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(sCollection).get();

    if (collectionRef.docs.isNotEmpty) {
      final dashboardDoc = collectionRef.docs.first;
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData[sCollection][0]['analitycsStatistic'];

      final updatedProfilesData = dashboardSummary.map((analits) {
        final todayValue = analits['today'];
        final yesterdayValue = analits['yesterday'];
        final beforeYesterdayValue = analits['beforeYesterday'];
        final total = todayValue + yesterdayValue + beforeYesterdayValue; // Calculate the new total

        return {
          ...analits,
          'total': total,
        };
      }).toList();

      await dashboardDoc.reference.update({
        'statistics': [
          {
            ...dashboardData['statistics'][0],
            'analitycsStatistic': updatedProfilesData,
          },
        ],
      });
    }
  }

// Add this method to your StatisticRepository class
  Future<void> checkTodayDateAndExecuteUpdate() async {
    UserManager userManager = UserManager();
    String? userID;
    userID = await userManager.getUID();
    final collectionRef =
        await FirebaseFirestore.instance.collection(mainCollection).doc(userID).collection(sCollection).get();

    if (collectionRef.docs.isNotEmpty) {
      final dashboardDoc = collectionRef.docs.first;
      final dashboardData = dashboardDoc.data();
      final dashboardSummary = dashboardData[sCollection][0]['analitycsStatistic'];

      final today = DateTime.now();
      final formattedTodayDate = DateFormat('yyyy-MM-dd').format(today);

      bool dayChanged = false; // Flag to track if the day has changed

      final updatedProfilesData = dashboardSummary.map((analits) {
        final todayDate = analits['todayDate'];

        if (todayDate != formattedTodayDate) {
          // Dates don't match, update statistics
          print('CRON:Data się zmieniła, Updating statistics...');

          dayChanged = true;
          return {
            ...analits,
            'todayDate': formattedTodayDate, // Update todayDate
          };
        }

        return analits;
      }).toList();

      if (dayChanged) {
        // Update statistics only if the day has changed
        await dashboardDoc.reference.update({
          'statistics': [
            {
              ...dashboardData['statistics'][0],
              'analitycsStatistic': updatedProfilesData,
            },
          ],
        });

        // Execute the updateStatisticsDaily method here
        await updateStatisticsDaily();
      } else {
        print('CRON:Data się nie zmieniła. Nie trzeba robic update w Statystyce.');
      }
    }
  }
}
