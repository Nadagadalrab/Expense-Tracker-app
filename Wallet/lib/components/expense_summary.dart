import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/bar%20graph/bar_graph.dart';
import 'package:wallet_app/data/expense_data.dart';
import 'package:wallet_app/datetime/date_time_helper.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek
  });

  //Max
  double calculateMax(
      ExpenseData value,
      String saturday,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      ){
       double? max = 100;

       List<double> values = [
         value.calculateDailyExpenseSummary()[saturday] ?? 0,
         value.calculateDailyExpenseSummary()[sunday] ?? 0,
         value.calculateDailyExpenseSummary()[monday] ?? 0,
         value.calculateDailyExpenseSummary()[tuesday] ?? 0,
         value.calculateDailyExpenseSummary()[wednesday] ?? 0,
         value.calculateDailyExpenseSummary()[thursday] ?? 0,
         value.calculateDailyExpenseSummary()[friday] ?? 0,
       ];

       values.sort();

       max = values.last * 1.1;

       return max == 0? 100 : max;
  }

  //week total
  String calculateWeekTotal(
      ExpenseData value,
      String saturday,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      ){
    List<double> values = [
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
    ];
    double total = 0;
    for (int i = 0; i< values.length; i++){
      total += values[i];
    }
    return total.toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    String saturday = convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String sunday = convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String monday = convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String tuesday = convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String wednesday = convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String thursday = convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String friday = convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));
    return Consumer<ExpenseData>(
        builder: (context, value, child) =>
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        children: [
                          const Text('Week Total: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                          Text('£' + calculateWeekTotal(value, saturday, sunday, monday,
                              tuesday, wednesday, thursday, friday))
                        ],
                      ),
                    )
                  ],
                )
                ,SizedBox(
                  height: 250,
                  child: MyBarGraph(
                      maxY: calculateMax(value, saturday, sunday, monday,
                          tuesday, wednesday, thursday, friday),
                      satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,
                      sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
                      monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
                      tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                      wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                      thuAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
                      friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
                      ),
                ),
              ],
            ));
  }
}
