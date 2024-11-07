import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/components/expense_summary.dart';
import 'package:wallet_app/components/expense_tile.dart';
import 'package:wallet_app/data/expense_data.dart';
import 'package:wallet_app/models/expense_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add new expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(hintText: "Expense name"),
            ),
            //amount
            Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: newExpenseDollarController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Pounds")),
                ),
                Expanded(
                  child: TextField(
                      controller: newExpenseCentsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "Cents")),
                ),
              ],
            ),
          ],
        ),
        actions: [
          MaterialButton(onPressed: cancel, child: Text('Cancel')),
          MaterialButton(onPressed: save, child: Text('Save')),
        ],
      ),
    );
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    if (newExpenseCentsController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty) {

      String amount =
          newExpenseDollarController.text + '.' + newExpenseCentsController.text;

      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );

      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    }

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: ListView(
              children: [
                ExpenseSummary(startOfWeek: value.startOfWeekDate()),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: value.getAllExpenseList().length,
                    itemBuilder: (context, index) => ExpenseTile(
                        name: value.getAllExpenseList()[index].name,
                        amount: value.getAllExpenseList()[index].amount,
                        dateTime: value.getAllExpenseList()[index].dateTime,
                        deleteTapped: (p0) => deleteExpense(value.getAllExpenseList()[index]),
                    )
                    ),
              ],
            ),
          )),
    );
  }
}
