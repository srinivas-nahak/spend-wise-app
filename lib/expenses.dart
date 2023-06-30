import 'dart:ffi';

import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/widgets/expense_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'chart/chart.dart';
import 'module/expense_details.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<ExpenseDetails> registeredExpense = [
    ExpenseDetails(
        title: "Course",
        amount: 400,
        date: DateTime.now(),
        category: Category.work),
    ExpenseDetails(
        title: "Movie",
        amount: 200,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (ctx) => NewExpense(
              onAddExpense: _addExpense,
            ));
  }

  void _addExpense(ExpenseDetails expense) {
    setState(() {
      registeredExpense.add(expense);
    });
  }

  void _removeExpense(ExpenseDetails expense) {
    int index = registeredExpense.indexOf(expense);

    setState(() {
      registeredExpense.remove(expense);
    });

    //If 2 times are deleted consecutively then the dialogs can overlap
    //That's why we're clearing snackbars beforehand
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: const Text("Expense deleted!"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              registeredExpense.insert(index, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;

    Widget mainWidget =
        Center(child: Text("No expenses found! Try adding some.."));

    if (registeredExpense.isNotEmpty) {
      mainWidget = Expanded(
        child: ExpenseList(
          expenseList: registeredExpense,
          onRemoveExpense: _removeExpense,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Expense Tracker",
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: screen_width < 600
            ? Column(
                children: [Chart(expenseList: registeredExpense), mainWidget],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenseList: registeredExpense)),
                  mainWidget
                ],
              ),
      ),
    );
  }
}
