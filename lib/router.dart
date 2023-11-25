import 'package:expanse_tracker/models/expense_model.dart';
import 'package:expanse_tracker/view/screens/add_expense.dart';
import 'package:expanse_tracker/view/screens/all_expenses.dart';
import 'package:expanse_tracker/view/screens/home_screen.dart';
import 'package:expanse_tracker/view/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
  GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
            path: 'addExpense',
            builder: (context, state) => const AddExpense()
            ),
             GoRoute(
                  path: 'editExpense',
                  builder: (context, state) {
                    Map<String, dynamic> extraData =
                        state.extra as Map<String, dynamic>;
                    ExpenseData data = extraData['edit'];
                    return AddExpense(
                      edit: data,
                    );
                  }),
        GoRoute(
            path: 'allExpenses',
            builder: (context, state) => const AllExpenses(),
            routes: [
              GoRoute(
                  path: 'editExpense',
                  builder: (context, state) {
                    Map<String, dynamic> extraData =
                        state.extra as Map<String, dynamic>;
                    ExpenseData data = extraData['edit'];
                    return AddExpense(
                      edit: data,
                    );
                  }),
            ])
      ]),
]);
