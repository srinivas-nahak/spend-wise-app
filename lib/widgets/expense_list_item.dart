import 'package:expense_tracker/module/expense_details.dart';
import 'package:flutter/material.dart';

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({required this.expenseDetails, super.key});

  final ExpenseDetails expenseDetails;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expenseDetails.title),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  "Rs.${expenseDetails.amount.toStringAsFixed(2)}",
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expenseDetails.category]),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      expenseDetails.formattedDate,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
