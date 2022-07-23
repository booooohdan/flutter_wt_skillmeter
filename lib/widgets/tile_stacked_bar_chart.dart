import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wt_skillmeter/models/chart_data.dart';
import 'package:wt_skillmeter/utilities/constants.dart';

class TileStackedBarChart extends StatelessWidget {
  TileStackedBarChart({
    Key? key,
    required this.title,
    required this.listData,
  }) : super(key: key);

  final String title;
  final List<ChartData> listData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: 500,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              title,
              style: roboto14darkGreyMedium,
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(maximum: 400),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  BarSeries<ChartData, String>(
                    dataSource: listData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y2,
                    name: 'Spaded',
                  ),
                  BarSeries<ChartData, String>(
                    dataSource: listData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y1,
                    name: 'Researched',
                  ),
                  BarSeries<ChartData, String>(
                    dataSource: listData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    name: 'Available for research',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
