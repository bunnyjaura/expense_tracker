import 'package:expanse_tracker/controller/expense_provider.dart';
import 'package:expanse_tracker/controller/theme_provider.dart';
import 'package:expanse_tracker/models/expense_model.dart';
import 'package:expanse_tracker/view/widgets/expense_widget.dart';
import 'package:expanse_tracker/view/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ExpenseProvider>(context);
    var theme = Provider.of<ThemeProvider>(context);
    useEffect(() {
      // provider.fetchData();
      // provider.fetchTotal();
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Transform.scale(
              scale: 1,
              child: FlutterSwitch(
                width: 50.0,
                height: 32.0,
                toggleSize: 20.0,
                value: theme.isDark,
                borderRadius: 30.0,
                padding: 2.0,
                activeToggleColor:
                    Theme.of(context).primaryColor.withOpacity(0.7),
                inactiveToggleColor: const Color(0xFF2F363D),
                activeSwitchBorder: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  width: 6.0,
                ),
                inactiveSwitchBorder: Border.all(
                  color: const Color(0xFFD1D5DA),
                  width: 6.0,
                ),
                activeColor: Theme.of(context).primaryColor.withOpacity(0.1),
                inactiveColor: Colors.white,
                activeIcon: const Icon(
                  Icons.nightlight_round,
                  color: Color(0xFFF8E3A1),
                ),
                inactiveIcon: const Icon(
                  Icons.wb_sunny,
                  color: Color(0xFFFFDF5D),
                ),
                onToggle: (val) {
                  theme.toggleTheme(val);
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Text(
                  'Total Expense',
                  style: TextStyle(color: Theme.of(context).canvasColor),
                ),
                const Gap(5),
                Text(
                  "₹ ${provider.total.toString()}",
                  style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                provider.data.isEmpty
                    ? SizedBox(
                      height: 400,
                      // color: Colors.amber,
                      child: Column(
                          children: [
                            const Gap(60),
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: SvgPicture.asset(
                                'assets/svg/sad.svg',
                                height: 70,
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                            ),
                            const Gap(20),
                            Text(
                              "Looks like there are no expenses yet.",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).canvasColor),
                            )
                          ],
                        ),
                    )
                    : RadialPieChart(
                        expenseDataList: provider.data,
                      ),
                provider.data.isEmpty
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'All Expenses',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).canvasColor),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go('/home/allExpenses');
                            },
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .canvasColor
                                        .withOpacity(0.2)),
                                child: Text(
                                  'VIEW ALL',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .canvasColor
                                        .withOpacity(0.7),
                                  ),
                                )),
                          )
                        ],
                      ),
                const Gap(15),
                provider.data.isEmpty
                    ? Container()
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: 2, 
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          List<ExpenseData> expenses = [];
                          String title = '';

                          switch (index) {
                            case 0:
                              title = 'Today';
                              expenses =
                                  provider.getTodayExpenses(provider.data);
                              break;
                            case 1:
                              title = 'Older';
                              expenses =
                                  provider.getOlderExpenses(provider.data);
                              break;
                            default:
                              break;
                          }

                          return expenses.isEmpty
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    expenses.isEmpty
                                        ? Container()
                                        : Column(
                                            children: [
                                              const Gap(10),
                                              Text(
                                                title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                    const Gap(15),
                                    if (expenses.isNotEmpty)
                                      ListView.separated(
                                        itemCount: expenses.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int idx) {
                                          final expense = expenses[idx];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7),
                                            child: Slidable(
                                              endActionPane: ActionPane(
                                                  motion: const ScrollMotion(),
                                                  children: [
                                                    SlidableAction(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      onPressed: (e) {
                                                        provider.deleteExpense(
                                                            expense.uid);
                                                      },
                                                      backgroundColor:
                                                          const Color(
                                                              0xFFFE4A49),
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.delete,
                                                      label: 'Delete',
                                                    ),
                                                    SlidableAction(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      onPressed: (e) {
                                                        context.go(
                                                            '/home/editExpense',
                                                            extra: {
                                                              'edit': expense
                                                            });
                                                      },
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.edit,
                                                      label: 'Edit',
                                                    ),
                                                  ]),
                                              key: ValueKey<String>(expense.uid),
                                              child: ExpenseWidget(
                                                amount: expenses[idx].amount,
                                                category:
                                                    expenses[idx].category,
                                                description:
                                                    expenses[idx].description,
                                                title: expenses[idx].title,
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                Container(),
                                      ),
                                    const Gap(15),
                                  ],
                                );
                        },
                      )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        shape: const OvalBorder(),
        onPressed: () {
          context.go('/home/addExpense');
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}
