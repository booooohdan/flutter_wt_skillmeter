import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wt_skillmeter/utilities/constants.dart';

class TileRadialGauge extends StatelessWidget {
  const TileRadialGauge({
    Key? key,
    required this.title,
    required this.value,
    required this.isKD,
  }) : super(key: key);

  final String title;
  final double value;
  final bool isKD;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: 200,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              title,
              style: roboto14darkGreyMedium,
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SfRadialGauge(
                enableLoadingAnimation: true,
                axes: [
                  RadialAxis(
                    interval: 10,
                    startAngle: 270,
                    endAngle: 270,
                    maximum: isKD ? 2 : 100,
                    showTicks: false,
                    showLabels: false,
                    axisLineStyle: const AxisLineStyle(thickness: 20),
                    pointers: [
                      RangePointer(
                        value: value,
                        width: 20,
                        color: Color.fromARGB(255, 255, 117, 255),
                        enableAnimation: true,
                        cornerStyle: isKD && value >= 2 ? CornerStyle.bothFlat : CornerStyle.bothCurve,
                      ),
                    ],
                    annotations: [
                      GaugeAnnotation(
                        widget: Text(
                          '${value.toStringAsFixed(2)}${isKD ? '' : '%'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        angle: 270,
                        positionFactor: 0.1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
