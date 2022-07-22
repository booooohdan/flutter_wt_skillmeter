import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wt_skillmeter/models/chart_data.dart';
import 'package:wt_skillmeter/utilities/constants.dart';

class TileDoughnutChart extends StatelessWidget {
  const TileDoughnutChart({
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
        height: 300,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              title,
              style: roboto14darkGreyMedium,
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                      dataSource: listData,
                      explode: true,
                      dataLabelSettings: DataLabelSettings(
                        showZeroValue: false,
                        isVisible: true,
                        useSeriesColor: true,
                        textStyle: GoogleFonts.roboto(fontSize: 8),
                        labelPosition: ChartDataLabelPosition.inside,
                        connectorLineSettings: const ConnectorLineSettings(
                          type: ConnectorType.curve,
                        ),
                      ),
                      animationDuration: 1000,
                      radius: '80%',
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
