import 'package:expanse_tracker/controller/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ExpenseProvider>(context);
    useEffect(() {
      provider.navigateToHome();
  provider.fetchData();
      return null;
    }, []);
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 60,
          child: const Icon(
            Icons.wallet_travel_rounded,
            size: 50,
          ),
        ),
      ),
    );
  }
}
