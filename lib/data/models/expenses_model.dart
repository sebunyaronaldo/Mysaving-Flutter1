import 'package:cloud_firestore/cloud_firestore.dart';

class Expenses {
  int? id;
  int? costs;
  List<Category> categories = [];

  Expenses({required this.id, required this.costs, List<Category>? categories}) : categories = categories ?? [];

  Map<String, dynamic> toMap() {
    return {'id': id, 'costs': costs, 'categories': categories};
  }

  Expenses.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    costs = json['costs'] as int?;
    categories = (json['categories'] as List<dynamic>).map((cate) => Category.fromJson(cate)).toList();
  }
}

class Expense {
  String? name;
  int? cost;
  Timestamp? expensesTime;

  Expense({required this.name, required this.cost, required this.expensesTime});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cost': cost,
      'time': expensesTime,
    };
  }

  Expense.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString() ?? "Nazwa";
    cost = json['cost'];
    expensesTime = json['time'];
  }
}

class Category {
  int? id;
  String? name;
  String? url;
  int? costs;
  List<Expense>? expenses;

  Category({
    required this.id,
    required this.name,
    required this.url,
    required this.costs,
    required this.expenses,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'costs': costs,
      'expenses': expenses!.map((expense) => expense.toMap()).toList(),
    };
  }

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'];
    url = json['url'];
    costs = json['costs'];
    expenses = (json['expenses'] as List<dynamic>).map((expense) => Expense.fromJson(expense)).toList();
  }
}
