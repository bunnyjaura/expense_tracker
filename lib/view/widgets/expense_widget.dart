import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class ExpenseWidget extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final String category;
  const ExpenseWidget({
    super.key,
    required this.amount,
    required this.category,
    required this.description,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor),
      child: Row(
        children: <Widget>[
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColor),
            child: SvgPicture.asset(
              category == 'Transportation'
                  ? 'assets/svg/transportation.svg'
                  : category == 'Entertainment'
                      ? 'assets/svg/entertainment.svg'
                      : category == 'Food & Dining'
                          ? 'assets/svg/food.svg'
                          : category == 'Housing'
                              ? 'assets/svg/housing.svg'
                              : category == 'Healthcare'
                                  ? 'assets/svg/medicine.svg'
                                  : 'assets/svg/entertainment.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          const Gap(15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).canvasColor),
              ),
              Text(
                description,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Theme.of(context).canvasColor.withOpacity(0.5)),
              ),
            ],
          ),
          const Spacer(),
          Text(
            "₹ $amount",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).canvasColor),
          )
        ],
      ),
    );
  }
}
