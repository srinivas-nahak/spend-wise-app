import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final dateFormatter = DateFormat.yMd();

final uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};

class ExpenseDetails {
  ExpenseDetails(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return dateFormatter.format(date);
  }
}

//This class calculates total expense of a particular category
class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenseList});

  ExpenseBucket.forCategory(
      {required this.category, required List<ExpenseDetails> allExpenses})
      : expenseList = allExpenses
            .where((expense) => expense.category == category)
            .toList();
  //Here we're filtering all the expenses of one similar category (For example all expenses in Food)

  final Category category;
  final List<ExpenseDetails> expenseList;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenseList) {
      sum += expense.amount; //sum = sum + expense.amount;
    }

    return sum;
  }
}
