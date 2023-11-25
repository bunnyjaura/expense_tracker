import 'package:expanse_tracker/controller/expense_provider.dart';
import 'package:expanse_tracker/controller/theme_provider.dart';
import 'package:expanse_tracker/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddExpense extends HookWidget {
  final ExpenseData? edit;

  const AddExpense({Key? key, this.edit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ExpenseProvider>(context);
    var theme = Provider.of<ThemeProvider>(context);
    useEffect(() {
      provider.clear();
      if (edit != null) {
        provider.amount.text = edit!.amount.toString();
        provider.title.text = edit!.title.toString();
        provider.description.text = edit!.description.toString();
        provider.date.text = DateFormat('yyyy-MM-dd').format(edit!.date);
        provider.selectedDate = edit!.date;
        provider.initial = edit!.date;
        provider.category.text = edit!.category;
      }
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: Text(edit != null ? 'Edit Expense' : 'Add Expense'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: provider.title,
                  onTapOutside: (e) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: TextStyle(color: Theme.of(context).canvasColor),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Theme.of(context).canvasColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                ),
                const Gap(30),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: provider.amount,
                        keyboardType: TextInputType.number,
                        onTapOutside: (e) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        style: TextStyle(color: Theme.of(context).canvasColor),
                        decoration: InputDecoration(
                          prefixText: '₹ ',
                          labelText: 'Amount',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Theme.of(context).canvasColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Text(
                      'INR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).canvasColor),
                    )
                  ],
                ),
                const Gap(30),
                SizedBox(
                  height: 80,
                  child: DropdownMenu(
                    controller: provider.category,
                    trailingIcon: Container(
                        height: 55,
                        width: 55,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor),
                        child: const Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 35,
                          color: Colors.white,
                        )),
                    selectedTrailingIcon: Container(
                        height: 55,
                        width: 55,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor),
                        child: const Icon(
                          Icons.arrow_drop_up_rounded,
                          size: 35,
                          color: Colors.white,
                        )),
                    width: MediaQuery.of(context).size.width,
                    label: const Text(
                      'Expenses made for',
                    ),
                    expandedInsets: EdgeInsets.zero,
                    inputDecorationTheme: InputDecorationTheme(
                        floatingLabelStyle: TextStyle(
                            color: Theme.of(context).canvasColor.withOpacity(0.6),
                            fontSize: 15),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        outlineBorder: BorderSide.none,
                        activeIndicatorBorder: BorderSide.none,
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                            color: Theme.of(context).canvasColor.withOpacity(0.6),
                            fontSize: 14)),
                    textStyle: TextStyle(color: Theme.of(context).canvasColor),
                    menuStyle: MenuStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 1, label: 'Food & Dining'),
                      DropdownMenuEntry(value: 2, label: 'Transportation'),
                      DropdownMenuEntry(value: 3, label: 'Housing'),
                      DropdownMenuEntry(value: 4, label: 'Entertainment'),
                      DropdownMenuEntry(value: 5, label: 'Healthcare'),
                    ],
                  ),
                ),
                const Gap(30),
                TextField(
                  controller: provider.description,
                  onTapOutside: (e) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: TextStyle(color: Theme.of(context).canvasColor),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Theme.of(context).canvasColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                ),
                const Gap(30),
                GestureDetector(
                  onTap: () {
                    provider.datePicker(context, theme);
                  },
                  child: TextField(
                    enabled: false,
                    controller: provider.date,
                    onTapOutside: (e) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: TextStyle(color: Theme.of(context).canvasColor),
                    decoration: InputDecoration(
                      hintText: 'Select Date',
                      hintStyle: TextStyle(
                          color: Theme.of(context).canvasColor.withOpacity(0.7)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Theme.of(context).canvasColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Theme.of(context).canvasColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
                const Gap(30),
                GestureDetector(
                  onTap: () {
                    // print(edit!.id);
                    edit != null
                        ? provider.editExpense(edit!.uid)
                        : provider.addExpense();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.check,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
