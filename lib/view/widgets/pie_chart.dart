import 'package:expanse_tracker/models/chart_model.dart';
import 'package:expanse_tracker/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadialPieChart extends StatelessWidget {
  final List<ExpenseData> expenseDataList;

  const RadialPieChart({Key? key, required this.expenseDataList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryAmounts = {};

    for (var data in expenseDataList) {
      if (categoryAmounts.containsKey(data.category)) {
        categoryAmounts[data.category] = (categoryAmounts[data.category] ?? 0) +
            double.tryParse(data.amount)!;
      } else {
        categoryAmounts[data.category] = double.tryParse(data.amount)!;
      }
    }

    List<ChartData> chartDataList = categoryAmounts.entries
        .map((entry) => ChartData(entry.key, entry.value, Colors.blue))
        .toList();

    return SfCircularChart(
      series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
          dataSource: chartDataList,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelMapper: (ChartData data, _) => data.category,
          radius: '90',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelIntersectAction: LabelIntersectAction.shift,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings: ConnectorLineSettings(
              type: ConnectorType.curve,
              length: '30%',
            ),
          ),
        ),
      ],
    );
  }
}
