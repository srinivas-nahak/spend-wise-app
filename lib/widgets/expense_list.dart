import 'package:expense_tracker/module/expense_details.dart';
import 'package:expense_tracker/widgets/expense_list_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {required this.expenseList, required this.onRemoveExpense, super.key});

  final List<ExpenseDetails> expenseList;
  final ValueChanged<ExpenseDetails> onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenseList.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(expenseList[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          margin: const EdgeInsets.symmetric(horizontal: 10),
        ),
        onDismissed: (direction) {
          onRemoveExpense(expenseList[index]);
        },
        child: ExpenseListItem(
          expenseDetails: expenseList[index],
        ),
      ),
    );
  }
}
