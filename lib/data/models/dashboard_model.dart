class DashboardSummary {
  int? id;
  int? saldo;
  int? saving;
  int? expenses;
  int? addedSavings;

  DashboardSummary({this.id, this.saldo, this.saving, this.expenses, this.addedSavings});

  Map<String, dynamic> toMap() {
    return {'id': id, 'saldo': saldo, 'saving': saving, 'expenses': expenses, 'addedSavings': addedSavings};
  }

  DashboardSummary.fromJson(List<dynamic> json) {
    id = json[0]['id'] as int;
    saldo = json[0]['saldo'] as int;
    expenses = json[0]['expenses'] as int;
    saving = json[0]['saving'] as int;
    addedSavings = json[0]['addedSavings'] as int;
  }
}

class DashboardAnalytics {
  List<DashboardAnalitycsDay> summary;
  int? maxExpensesPerDay;

  DashboardAnalytics({required this.summary, required this.maxExpensesPerDay}) {}

  int calculateTotalExpenses(DateTime day) {
    int total = 0;
    return total;
  }

  int calculateSaldo(DateTime day) {
    return 0;
  }

  int calculateSaving(DateTime day) {
    return 0;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Map<String, dynamic> toMap() {
    return {'summary': summary.map((day) => day.toMap()).toList(), 'maxExpensesPerDay': maxExpensesPerDay};
  }
}

class DashboardAnalitycsDay {
  String? name;
  int id;
  int saldo;
  int saving;
  int expenses;
  String date;

  DashboardAnalitycsDay({
    required this.name,
    required this.id,
    required this.saldo,
    required this.saving,
    required this.expenses,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'saldo': saldo,
      'saving': saving,
      'expenses': expenses,
      'date': date,
    };
  }
}

class DashboardModel {
  String? id;
  List<DashboardAnalytics>? dashboardAnalytics;
  List<DashboardSummary>? dashboardSummary;

  DashboardModel({
    required this.id,
    required this.dashboardAnalytics,
    required this.dashboardSummary,
  });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dashboardAnalytics = json['dashboardAnalytics'];
    dashboardSummary = json['dashboardSummary'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dashboardAnalytics': dashboardAnalytics!.map((analytics) => analytics.toMap()).toList(),
      'dashboardSummary': dashboardSummary!.map((summary) => summary.toMap()).toList(),
    };
  }
}
