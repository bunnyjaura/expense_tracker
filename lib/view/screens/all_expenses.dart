import 'package:expanse_tracker/controller/expense_provider.dart';
import 'package:expanse_tracker/view/widgets/expense_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AllExpenses extends StatelessWidget {
  const AllExpenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ExpenseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: provider.data.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Builder(builder: (context) {
                final expense = provider.data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: ExpenseWidget(
                    delete: (){
                          provider.deleteExpense(expense.uid);
                    },
                    edit: (){
                   context.go('/home/allExpenses/editExpense',extra: {'edit':expense});
                    },
                    slideKey:ValueKey<String>(expense.uid) ,
                    amount: provider.data[index].amount,
                    category: provider.data[index].category,
                    description: provider.data[index].description,
                    title: provider.data[index].title,
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
