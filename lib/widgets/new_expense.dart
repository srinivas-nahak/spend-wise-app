import 'package:expense_tracker/module/expense_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(ExpenseDetails expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController(),
      _amountController = TextEditingController();

  DateTime? _selectedDate;

  Category _selectedCategory = Category.work;

  String _errorMessage = "Please make sure valid values are entered!";

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);

    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      //ShowErrorMessage

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Invalid Input"),
          content: Text(_errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Okay"),
            )
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      ExpenseDetails(
          title: _titleController.text.trim(),
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //Giving space in landscape mode and making the View Scrollable
    double keyboardSpaceLandscape = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15)
              .copyWith(top: 50, bottom: 15 + keyboardSpaceLandscape),
          child: Column(children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: InputDecoration(
                label: Text("Title"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      prefixText: "Rs.",
                      label: Text("Amount"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate == null
                            ? "No date Selected"
                            : dateFormatter.format(_selectedDate!),
                      ),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(toBeginningOfSentenceCase(category
                                .name)!), //Making the first letter capital
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _selectedCategory = value;
                      });
                    }),
                const Spacer(),
                ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: Text("Save Expense"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _amountController.dispose();
  }
}

//Changing the element positions in landscape mode

// return LayoutBuilder(builder: (context, constraints) {
// double width = constraints.maxWidth;
//
// print("Width is $width");
//
// return SizedBox(
// height: double.infinity,
// child: SingleChildScrollView(
// child: Padding(
// padding: const EdgeInsets.all(15)
//     .copyWith(top: 50, bottom: 15 + keyboardSpaceLandscape),
// child: Column(children: [
// if (width >= 600)
// Row(
// children: [
// Expanded(
// child: TextField(
// controller: _titleController,
// maxLength: 50,
// decoration: InputDecoration(
// label: Text("Title"),
// ),
// ),
// ),
// SizedBox(
// width: 15,
// ),
// Expanded(
// child: Expanded(
// child: TextField(
// controller: _amountController,
// keyboardType: TextInputType.number,
// maxLength: 10,
// decoration: const InputDecoration(
// prefixText: "Rs.",
// label: Text("Amount"),
// ),
// ),
// ))
// ],
