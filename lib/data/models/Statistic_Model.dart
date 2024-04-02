import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the package for date formatting

class StatisticMainModel {
  String? id;
  List<StatisticsModel>? analitycsStatistics;

  StatisticMainModel({
    required this.id,
    required this.analitycsStatistics,
  });
  StatisticMainModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    analitycsStatistics = json['analitycsStatistics'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'analitycsStatistics': analitycsStatistics!.map((statistic) => statistic.toMap()).toList(),
    };
  }
}

class StatisticsModel {
  int? id;
  int? today;
  int? yesterday;
  int? beforeYesterday;
  int? total;
  Timestamp? date;
  StatisticsModel({this.today, this.yesterday, this.beforeYesterday, this.id, this.total, this.date});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todayDate': getFormattedDate(),
      'today': today,
      'yesterday': yesterday,
      'beforeYesterday': beforeYesterday,
      'total': total,
    };
  }

  String getFormattedDate() {
    if (date != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date!.toDate());
      return formattedDate;
    }
    return '';
  }

  StatisticsModel.fromJson(List<dynamic> json) {
    id = json[0]['id'] as int;
    date = json[0]['todayDate'] != null ? Timestamp.fromDate(DateTime.parse(json[0]['todayDate'])) : null;
    today = json[0]['today'] as int;
    yesterday = json[0]['yesterday'] as int;
    beforeYesterday = json[0]['beforeYesterday'] as int;
    total = json[0]['total'] as int;
  }
}
