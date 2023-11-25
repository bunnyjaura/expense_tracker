import 'package:expanse_tracker/controller/expense_provider.dart';
import 'package:expanse_tracker/view/widgets/expense_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
                  child: Slidable(
                    endActionPane:
                        ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                        borderRadius: BorderRadius.circular(15),
                        onPressed: (e) {
                          provider.deleteExpense(expense.uid);
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        borderRadius: BorderRadius.circular(15),
                        onPressed: (e) {
                          context.go('/home/allExpenses/editExpense',extra: {'edit':expense});
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ]),
                    key: ValueKey<String>(expense.uid),
                    child: ExpenseWidget(
                      amount: provider.data[index].amount,
                      category: provider.data[index].category,
                      description: provider.data[index].description,
                      title: provider.data[index].title,
                    ),
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
