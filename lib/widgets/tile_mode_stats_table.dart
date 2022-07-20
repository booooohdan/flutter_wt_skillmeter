import 'package:flutter/material.dart';
import 'package:wt_skillmeter/utilities/constants.dart';

class TileModeStatsTable extends StatelessWidget {
  const TileModeStatsTable({
    Key? key,
    required this.title,
    required this.plane,
    required this.tank,
    required this.ship,
    required this.time,
    required this.battles,
    required this.mode,
  }) : super(key: key);

  final String title;
  final String plane;
  final String tank;
  final String ship;
  final String time;
  final String battles;
  final String mode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(title, style: roboto14darkGreyMedium),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/plane.png', height: 30),
                Text(plane, style: roboto14darkGreyMedium),
              ],
            ),
            mode != 'ship'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/tank.png', height: 30),
                      Text(tank, style: roboto14darkGreyMedium),
                    ],
                  )
                : Container(),
            mode != 'tank'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/ship.png', height: 30),
                      Text(ship, style: roboto14darkGreyMedium),
                    ],
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/clock.png', height: 30),
                Text(time, style: roboto14darkGreyMedium),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/sword.png', height: 30),
                Text(battles, style: roboto14darkGreyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
