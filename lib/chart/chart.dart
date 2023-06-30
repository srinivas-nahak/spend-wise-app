import 'package:flutter/material.dart';

import '../module/expense_details.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenseList});

  final List<ExpenseDetails> expenseList;

  //Here the list is being evaluated in 4 categories to see which is heighest
  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(
          category: Category.food,
          allExpenses:
              expenseList), //Each of these objects are purely of one type
      ExpenseBucket.forCategory(
          category: Category.travel, allExpenses: expenseList),
      ExpenseBucket.forCategory(
          category: Category.leisure, allExpenses: expenseList),
      ExpenseBucket.forCategory(
          category: Category.work, allExpenses: expenseList),
    ];
  }

  //Below getter will also work

  // List<ExpenseBucket> get buckets {
  //   return Category.values
  //       .map(
  //         (category) => ExpenseBucket.forCategory(
  //             category: category, allExpenses: expenseList),
  //       )
  //       .toList();
  // }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          //Showing the Chartbar
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets) // alternative to map()
                  ChartBar(
                    fill: bucket.totalExpenses == 0
                        ? 0
                        : bucket.totalExpenses / maxTotalExpense,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),

          //Showing bottom icons
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcons[bucket.category],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
