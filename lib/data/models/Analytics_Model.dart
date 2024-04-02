import 'package:mysavingapp/data/models/expenses_model.dart';

class AnalitycsModel {
  String? id;
  List<MainAnalitycs>? mainAnalytics;

  AnalitycsModel({
    required this.id,
    required this.mainAnalytics,
  });
  AnalitycsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainAnalytics = json['mainAnalytics'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mainAnalytics': mainAnalytics!.map((lastMonth) => lastMonth.toMap()).toList(),
    };
  }

  AnalitycsModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    mainAnalytics = (json['mainAnalytics'] as List).map((e) => MainAnalitycs.fromJson(e)).toList();
  }
}

class MainAnalitycs {
  List<LastMonth>? lastmonth;
  List<CurrentMonth>? currentmonth;
  String? customCategoryName;
  MainAnalitycs({required this.lastmonth, required this.currentmonth, required this.customCategoryName}) {}

  Map<String, dynamic> toMap() {
    return {
      'lastMonth': lastmonth!.map((day) => day.toMap()).toList(),
      'currentMonth': currentmonth!.map((day) => day.toMap()).toList(),
      'customCategoryName': customCategoryName
    };
  }

  MainAnalitycs.fromJson(Map<String, dynamic> json) {
    lastmonth = (json['lastMonth'] as List).map((e) => LastMonth.fromJson(e)).toList();
    currentmonth = (json['currentMonth'] as List).map((e) => CurrentMonth.fromJson(e)).toList();
    customCategoryName = json['customCategoryName'];
  }
}

class LastMonth {
  int? id;
  int? expenses;
  String? name;
  int? numberOfMonth;
  List<Category>? categories;
  int? totalCosts;
  String? date;

  LastMonth(
      {required this.id,
      required this.name,
      required this.expenses,
      required this.categories,
      required this.numberOfMonth,
      required this.date,
      required this.totalCosts});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastMonthDate': date,
      'totalCosts': totalCosts,
      'numberOfMonth': numberOfMonth,
      'categories': categories!.map((day) => day.toMap()).toList(),
    };
  }

  LastMonth.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['lastMonthDate'];
    totalCosts = json['totalCosts'];
    numberOfMonth = json['numberOfMonth'];
    categories = (json['categories'] as List).map((e) => Category.fromJson(e)).toList();
    expenses = json['expenses'];
  }
}

class CurrentMonth {
  String? date;
  int? id;
  int? expenses;
  int? numberOfMonth; // New field to store the number of the current month
  String? name; // New field to store the name of the current month
  List<Category>? categories;
  int? totalCosts;
  CurrentMonth(
      {required this.id,
      required this.name,
      required this.expenses,
      required this.date,
      required this.categories,
      required this.numberOfMonth,
      required this.totalCosts});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currentMonthDate': date,
      'totalCosts': totalCosts,
      'numberOfMonth': numberOfMonth, // Include numberOfMonth in the toMap method
      'categories': categories!.map((day) => day.toMap()).toList(),
    };
  }

  CurrentMonth.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['currentMonthDate'];
    totalCosts = json['totalCosts'];
    numberOfMonth = json['numberOfMonth'];
    categories = (json['categories'] as List).map((e) => Category.fromJson(e)).toList();
    expenses = json['expenses'];
  }
}
