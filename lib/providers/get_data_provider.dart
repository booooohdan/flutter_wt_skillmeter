import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wt_skillmeter/models/chart_data.dart';
import 'package:wt_skillmeter/models/killdeath.dart';
import 'package:wt_skillmeter/models/player.dart';

class GetDataProvider with ChangeNotifier {
  // Provider Example
  //
  // late int _intValue;
  //
  // int get intValue => _intValue;
  //
  // void setIntValue(int intValueParam) {
  //   _intValue = intValueParam;
  //   notifyListeners();
  // }

  Future<Player> getPlayerDataFromWebsite(String playerNickname) async {
    final url = Uri.parse('https://warthunder.com/en/community/userinfo/?nick=$playerNickname');
    final response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    final html = dom.Document.html(response.body);

    final nickname = html.querySelectorAll('ul > li.user-profile__data-nick').map((e) => e.innerHtml.trim()).toList();
    final squadron = html.querySelectorAll('li > a.user-profile__data-link').map((e) => e.innerHtml.trim()).toList();
    final avatar = html.querySelectorAll('div.user-profile__ava > img').map((e) => e.attributes['src']).toList();
    final titleAndLevel = html.querySelectorAll('ul > li.user-profile__data-item').map((e) => e.innerHtml.trim()).toList();
    final regDate = html.querySelectorAll('ul > li.user-profile__data-regdate').map((e) => e.innerHtml.trim()).toList();
    final arcadeBattles = html.querySelectorAll('ul.user-stat__list.arcadeFightTab > li.user-stat__list-item').map((e) => e.innerHtml.trim()).toList();
    final realisticBattles = html.querySelectorAll('ul.user-stat__list.historyFightTab > li.user-stat__list-item').map((e) => e.innerHtml.trim()).toList();
    final simulatorBattles = html.querySelectorAll('ul.user-stat__list.simulationFightTab > li.user-stat__list-item').map((e) => e.innerHtml.trim()).toList();
    final vehiclesAndRewards = html.querySelectorAll('ul.user-score__list-col > li.user-score__list-item').map((e) => e.innerHtml.trim()).toList();

    final completedAB = int.tryParse(arcadeBattles[2]) ?? 0;
    final completedRB = int.tryParse(realisticBattles[2]) ?? 0;
    final completedSB = int.tryParse(simulatorBattles[2]) ?? 0;
    final lionsAB = int.tryParse(arcadeBattles[5].replaceAll(',', '').replaceAll('.', '')) ?? 0;
    final lionsRB = int.tryParse(realisticBattles[5].replaceAll(',', '').replaceAll('.', '')) ?? 0;
    final lionsSB = int.tryParse(simulatorBattles[5].replaceAll(',', '').replaceAll('.', '')) ?? 0;
    final playAB = parseWtDateTime(arcadeBattles[6]);
    final playRB = parseWtDateTime(realisticBattles[6]);
    final playSB = parseWtDateTime(simulatorBattles[6]);
    final winRateAB = int.tryParse(arcadeBattles[3].replaceAll('%', '')) ?? 0;
    final winRateRB = int.tryParse(realisticBattles[3].replaceAll('%', '')) ?? 0;
    final winRateSB = int.tryParse(simulatorBattles[3].replaceAll('%', '')) ?? 0;

    final aviationAirDestroyedAB = int.tryParse(arcadeBattles[19]) ?? 0;
    final aviationAirDestroyedRB = int.tryParse(realisticBattles[19]) ?? 0;
    final aviationAirDestroyedSB = int.tryParse(simulatorBattles[19]) ?? 0;
    final aviationGroundDestroyedAB = int.tryParse(arcadeBattles[20]) ?? 0;
    final aviationGroundDestroyedRB = int.tryParse(realisticBattles[20]) ?? 0;
    final aviationGroundDestroyedSB = int.tryParse(simulatorBattles[20]) ?? 0;
    final aviationNavalDestroyedAB = int.tryParse(arcadeBattles[21]) ?? 0;
    final aviationNavalDestroyedRB = int.tryParse(realisticBattles[21]) ?? 0;
    final aviationTimePlayedAB = parseWtDateTime(arcadeBattles[14]);
    final aviationTimePlayedRB = parseWtDateTime(realisticBattles[14]);
    final aviationTimePlayedSB = parseWtDateTime(simulatorBattles[14]);
    final aviationBattlesPlayedAB = int.tryParse(arcadeBattles[10]) ?? 0;
    final aviationBattlesPlayedRB = int.tryParse(realisticBattles[10]) ?? 0;
    final aviationBattlesPlayedSB = int.tryParse(simulatorBattles[10]) ?? 0;

    final groundAirDestroyedAB = int.tryParse(arcadeBattles[33]) ?? 0;
    final groundAirDestroyedRB = int.tryParse(realisticBattles[33]) ?? 0;
    final groundAirDestroyedSB = int.tryParse(simulatorBattles[33]) ?? 0;
    final groundTankDestroyedAB = int.tryParse(arcadeBattles[34]) ?? 0;
    final groundTankDestroyedRB = int.tryParse(realisticBattles[34]) ?? 0;
    final groundTankDestroyedSB = int.tryParse(simulatorBattles[34]) ?? 0;
    final groundTimePlayedAB = parseWtDateTime(arcadeBattles[27]);
    final groundTimePlayedRB = parseWtDateTime(realisticBattles[27]);
    final groundTimePlayedSB = parseWtDateTime(simulatorBattles[27]);
    final groundBattlesPlayedAB = int.tryParse(arcadeBattles[22]) ?? 0;
    final groundBattlesPlayedRB = int.tryParse(realisticBattles[22]) ?? 0;
    final groundBattlesPlayedSB = int.tryParse(simulatorBattles[22]) ?? 0;

    final navalAirDestroyedAB = int.tryParse(arcadeBattles[53]) ?? 0;
    final navalAirDestroyedRB = int.tryParse(realisticBattles[53]) ?? 0;
    final navalShipDestroyedAB = int.tryParse(arcadeBattles[55]) ?? 0;
    final navalShipDestroyedRB = int.tryParse(realisticBattles[55]) ?? 0;
    final navalTimePlayedAB = parseWtDateTime(arcadeBattles[44]);
    final navalTimePlayedRB = parseWtDateTime(realisticBattles[44]);
    final navalBattlesPlayedAB = int.tryParse(arcadeBattles[36]) ?? 0;
    final navalBattlesPlayedRB = int.tryParse(realisticBattles[36]) ?? 0;

    final fighterBattlesPlayedAB = int.tryParse(arcadeBattles[11]) ?? 0;
    final fighterBattlesPlayedRB = int.tryParse(realisticBattles[11]) ?? 0;
    final fighterBattlesPlayedSB = int.tryParse(simulatorBattles[11]) ?? 0;
    final strikeBattlesPlayedAB = int.tryParse(arcadeBattles[13]) ?? 0;
    final strikeBattlesPlayedRB = int.tryParse(realisticBattles[13]) ?? 0;
    final strikeBattlesPlayedSB = int.tryParse(simulatorBattles[13]) ?? 0;
    final bomberBattlesPlayedAB = int.tryParse(arcadeBattles[12]) ?? 0;
    final bomberBattlesPlayedRB = int.tryParse(realisticBattles[12]) ?? 0;
    final bomberBattlesPlayedSB = int.tryParse(simulatorBattles[12]) ?? 0;
    final fighterBattlesPlayed = fighterBattlesPlayedAB + fighterBattlesPlayedRB + fighterBattlesPlayedSB;
    final strikeBattlesPlayed = strikeBattlesPlayedAB + strikeBattlesPlayedRB + strikeBattlesPlayedSB;
    final bomberBattlesPlayed = bomberBattlesPlayedAB + bomberBattlesPlayedRB + bomberBattlesPlayedSB;

    final tankBattlesPlayedAB = int.tryParse(arcadeBattles[23]) ?? 0;
    final tankBattlesPlayedRB = int.tryParse(realisticBattles[23]) ?? 0;
    final tankBattlesPlayedSB = int.tryParse(simulatorBattles[23]) ?? 0;
    final heavyTankBattlesPlayedAB = int.tryParse(arcadeBattles[25]) ?? 0;
    final heavyTankBattlesPlayedRB = int.tryParse(realisticBattles[25]) ?? 0;
    final heavyTankBattlesPlayedSB = int.tryParse(simulatorBattles[25]) ?? 0;
    final spgBattlesPlayedAB = int.tryParse(arcadeBattles[24]) ?? 0;
    final spgBattlesPlayedRB = int.tryParse(realisticBattles[24]) ?? 0;
    final spgBattlesPlayedSB = int.tryParse(simulatorBattles[24]) ?? 0;
    final spaaBattlesPlayedAB = int.tryParse(arcadeBattles[26]) ?? 0;
    final spaaBattlesPlayedRB = int.tryParse(realisticBattles[26]) ?? 0;
    final spaaBattlesPlayedSB = int.tryParse(simulatorBattles[26]) ?? 0;
    final tankBattlesPlayed = tankBattlesPlayedAB + tankBattlesPlayedRB + tankBattlesPlayedSB;
    final heavyTankBattlesPlayed = heavyTankBattlesPlayedAB + heavyTankBattlesPlayedRB + heavyTankBattlesPlayedSB;
    final spgBattlesPlayed = spgBattlesPlayedAB + spgBattlesPlayedRB + spgBattlesPlayedSB;
    final spaaBattlesPlayed = spaaBattlesPlayedAB + spaaBattlesPlayedRB + spaaBattlesPlayedSB;

    final mtboatsBattlesPlayedAB = int.tryParse(arcadeBattles[38]) ?? 0;
    final mtboatsBattlesPlayedRB = int.tryParse(realisticBattles[38]) ?? 0;
    final mgboatsBattlesPlayedAB = int.tryParse(arcadeBattles[39]) ?? 0;
    final mgboatsBattlesPlayedRB = int.tryParse(realisticBattles[39]) ?? 0;
    final mtgboatsBattlesPlayedAB = int.tryParse(arcadeBattles[40]) ?? 0;
    final mtgboatsBattlesPlayedRB = int.tryParse(realisticBattles[40]) ?? 0;
    final subshaserBattlesPlayedAB = int.tryParse(arcadeBattles[41]) ?? 0;
    final subshaserBattlesPlayedRB = int.tryParse(realisticBattles[41]) ?? 0;
    final bargeBattlesPlayedAB = int.tryParse(arcadeBattles[43]) ?? 0;
    final bargeBattlesPlayedRB = int.tryParse(realisticBattles[43]) ?? 0;
    final destroyerBattlesPlayedAB = int.tryParse(arcadeBattles[42]) ?? 0;
    final destroyerBattlesPlayedRB = int.tryParse(realisticBattles[42]) ?? 0;
    final coastalBattlesPlayed = mtboatsBattlesPlayedAB +
        mtboatsBattlesPlayedRB +
        mgboatsBattlesPlayedAB +
        mgboatsBattlesPlayedRB +
        mtgboatsBattlesPlayedAB +
        mtgboatsBattlesPlayedRB +
        subshaserBattlesPlayedAB +
        subshaserBattlesPlayedRB +
        bargeBattlesPlayedAB +
        bargeBattlesPlayedRB;
    final bluewaterBattlesPlayed = destroyerBattlesPlayedAB + destroyerBattlesPlayedRB;

    final usaResearchedVehicles = int.tryParse(vehiclesAndRewards[1]) ?? 0;
    final usaSpadedVehicles = int.tryParse(vehiclesAndRewards[11]) ?? 0;
    final germanyResearchedVehicles = int.tryParse(vehiclesAndRewards[4]) ?? 0;
    final germanySpadedVehicles = int.tryParse(vehiclesAndRewards[14]) ?? 0;
    final ussrResearchedVehicles = int.tryParse(vehiclesAndRewards[2]) ?? 0;
    final ussrSpadedVehicles = int.tryParse(vehiclesAndRewards[12]) ?? 0;
    final britainResearchedVehicles = int.tryParse(vehiclesAndRewards[3]) ?? 0;
    final britainSpadedVehicles = int.tryParse(vehiclesAndRewards[13]) ?? 0;
    final japanResearchedVehicles = int.tryParse(vehiclesAndRewards[5]) ?? 0;
    final japanSpadedVehicles = int.tryParse(vehiclesAndRewards[15]) ?? 0;
    final italyResearchedVehicles = int.tryParse(vehiclesAndRewards[6]) ?? 0;
    final italySpadedVehicles = int.tryParse(vehiclesAndRewards[16]) ?? 0;
    final franceResearchedVehicles = int.tryParse(vehiclesAndRewards[7]) ?? 0;
    final franceSpadedVehicles = int.tryParse(vehiclesAndRewards[17]) ?? 0;
    final chinaResearchedVehicles = int.tryParse(vehiclesAndRewards[8]) ?? 0;
    final chinaSpadedVehicles = int.tryParse(vehiclesAndRewards[18]) ?? 0;
    final swedenResearchedVehicles = int.tryParse(vehiclesAndRewards[9]) ?? 0;
    final swedenSpadedVehicles = int.tryParse(vehiclesAndRewards[19]) ?? 0;

    final List<KillDeath> kdList = [
      KillDeath(killNumber: int.tryParse(arcadeBattles[18]) ?? 0, battleNumber: int.tryParse(arcadeBattles[10]) ?? 1, modeName: 'AirAB'),
      KillDeath(killNumber: int.tryParse(realisticBattles[18]) ?? 0, battleNumber: int.tryParse(realisticBattles[10]) ?? 1, modeName: 'AirRB'),
      KillDeath(killNumber: int.tryParse(simulatorBattles[18]) ?? 0, battleNumber: int.tryParse(simulatorBattles[10]) ?? 1, modeName: 'AirSB'),
      KillDeath(killNumber: int.tryParse(arcadeBattles[32]) ?? 0, battleNumber: int.tryParse(arcadeBattles[22]) ?? 1, modeName: 'TankAB'),
      KillDeath(killNumber: int.tryParse(realisticBattles[32]) ?? 0, battleNumber: int.tryParse(realisticBattles[22]) ?? 1, modeName: 'TankRB'),
      KillDeath(killNumber: int.tryParse(simulatorBattles[32]) ?? 0, battleNumber: int.tryParse(simulatorBattles[22]) ?? 1, modeName: 'TankSB'),
      KillDeath(killNumber: int.tryParse(arcadeBattles[52]) ?? 0, battleNumber: int.tryParse(arcadeBattles[36]) ?? 1, modeName: 'ShipAB'),
      KillDeath(killNumber: int.tryParse(realisticBattles[52]) ?? 0, battleNumber: int.tryParse(realisticBattles[36]) ?? 1, modeName: 'ShipRB'),
    ];

    final List<ChartData> battleNumbersChart = [
      ChartData(x: 'Air AB', y: aviationBattlesPlayedAB, color: Color(0xFF4FBEFF)),
      ChartData(x: 'Air RB', y: aviationBattlesPlayedRB, color: Color(0xFF1792D9)),
      ChartData(x: 'Air SB', y: aviationBattlesPlayedSB, color: Color(0xFF004FBE)),
      ChartData(x: 'Tank AB', y: groundBattlesPlayedAB, color: Color(0xFF84FF5E)),
      ChartData(x: 'Tank RB', y: groundBattlesPlayedRB, color: Color(0xFF1BC516)),
      ChartData(x: 'Tank SB', y: groundBattlesPlayedSB, color: Color(0xFF06842A)),
      ChartData(x: 'Fleet AB', y: navalBattlesPlayedAB, color: Color(0xFF12B9BF)),
      ChartData(x: 'Fleet RB', y: navalBattlesPlayedRB, color: Color(0xFF177477)),
    ];

    final List<ChartData> typeOfVehicleChart = [
      ChartData(x: 'Fighter', y: fighterBattlesPlayed, color: Color(0xFF4FBEFF)),
      ChartData(x: 'Strike', y: strikeBattlesPlayed, color: Color(0xFF1792D9)),
      ChartData(x: 'Bomber', y: bomberBattlesPlayed, color: Color(0xFF004FBE)),
      ChartData(x: 'Tank', y: tankBattlesPlayed, color: Color(0xFF84FF5E)),
      ChartData(x: 'Heavy Tank', y: heavyTankBattlesPlayed, color: Color(0xFF1BC516)),
      ChartData(x: 'SPG', y: spgBattlesPlayed, color: Color(0xFF12B9BF)),
      ChartData(x: 'SPAA', y: spaaBattlesPlayed, color: Color(0xFF06842A)),
      ChartData(x: 'Coastal Fleet', y: coastalBattlesPlayed, color: Color(0xFF177477)),
      ChartData(x: 'Bluewater Fleet', y: bluewaterBattlesPlayed, color: Color(0xFF9D3D7F)),
    ];

    final List<ChartData> researchedVehicleChart = <ChartData>[
      ChartData(x: 'SWE', y: 95, y1: swedenResearchedVehicles, y2: swedenSpadedVehicles),
      ChartData(x: 'CHI', y: 126, y1: chinaResearchedVehicles, y2: chinaSpadedVehicles),
      ChartData(x: 'FRA', y: 145, y1: franceResearchedVehicles, y2: franceSpadedVehicles),
      ChartData(x: 'ITA', y: 174, y1: italyResearchedVehicles, y2: italySpadedVehicles),
      ChartData(x: 'JAP', y: 219, y1: japanResearchedVehicles, y2: japanSpadedVehicles),
      ChartData(x: 'GBR', y: 294, y1: britainResearchedVehicles, y2: britainSpadedVehicles),
      ChartData(x: 'USR', y: 368, y1: ussrResearchedVehicles, y2: ussrSpadedVehicles),
      ChartData(x: 'GER', y: 340, y1: germanyResearchedVehicles, y2: germanySpadedVehicles),
      ChartData(x: 'USA', y: 326, y1: usaResearchedVehicles, y2: usaSpadedVehicles),
    ];

    final player = Player(
      nickname: nickname[0],
      squadron: squadron.isEmpty ? '' : squadron[0],
      avatar: 'https:${avatar[0]}',
      title: '${titleAndLevel[0]} ',
      level: titleAndLevel[1],
      signUpDate: regDate[0].replaceAll('Registration date ', ''),
      yearsOld: countAccYears(regDate[0]),
      completedMissionAB: completedAB,
      completedMissionRB: completedRB,
      completedMissionSB: completedSB,
      completedMissions: completedAB + completedRB + completedSB,
      lionsEarnedAB: lionsAB,
      lionsEarnedRB: lionsRB,
      lionsEarnedSB: lionsSB,
      lionsEarned: lionsEarned(lionsAB, lionsRB, lionsSB),
      playTimeAB: playAB,
      playTimeRB: playRB,
      playTimeSB: playSB,
      playTime: playAB + playRB + playSB,
      winRatesAB: winRateAB,
      winRatesRB: winRateRB,
      winRatesSB: winRateSB,
      winRates: (winRateAB + winRateRB + winRateSB) / 3,
      kdAirAB: calculateKd(kdList, 'AirAB'),
      kdAirRB: calculateKd(kdList, 'AirRB'),
      kdAirSB: calculateKd(kdList, 'AirSB'),
      kdTankAB: calculateKd(kdList, 'TankAB'),
      kdTankRB: calculateKd(kdList, 'TankRB'),
      kdTankSB: calculateKd(kdList, 'TankSB'),
      kdShipAB: calculateKd(kdList, 'ShipAB'),
      kdShipRB: calculateKd(kdList, 'ShipRB'),
      totalKD: totalKd(kdList),
      aviationAirDestroyed: aviationAirDestroyedAB + aviationAirDestroyedRB + aviationAirDestroyedSB,
      aviationGroundDestroyed: aviationGroundDestroyedAB + aviationGroundDestroyedRB + aviationGroundDestroyedSB,
      aviationNavalDestroyed: aviationNavalDestroyedAB + aviationNavalDestroyedRB,
      aviationTimePlayed: aviationTimePlayedAB + aviationTimePlayedRB + aviationTimePlayedSB,
      aviationBattlesPlayed: aviationBattlesPlayedAB + aviationBattlesPlayedRB + aviationBattlesPlayedSB,
      groundAirDestroyed: groundAirDestroyedAB + groundAirDestroyedRB + groundAirDestroyedSB,
      groundTankDestroyed: groundTankDestroyedAB + groundTankDestroyedRB + groundTankDestroyedSB,
      groundTimePlayed: groundTimePlayedAB + groundTimePlayedRB + groundTimePlayedSB,
      groundBattlesPlayed: groundBattlesPlayedAB + groundBattlesPlayedRB + groundBattlesPlayedSB,
      navalAirDestroyed: navalAirDestroyedAB + navalAirDestroyedRB,
      navalShipDestroyed: navalShipDestroyedAB + navalShipDestroyedRB,
      navalTimePlayed: navalTimePlayedAB + navalTimePlayedRB,
      navalBattlesPlayed: navalBattlesPlayedAB + navalBattlesPlayedRB,
      gameModesChart: battleNumbersChart,
      typeOfVehicleChart: typeOfVehicleChart,
      researchedVehicleChart: researchedVehicleChart,
    );

    //TODO: Handle possible exception (try/catch)
    log('message');
    return player;
  }

  int countAccYears(String regDate) {
    final parsedDate = DateFormat('dd.MM.yyyy').parse(regDate.replaceAll('Registration date ', ''));
    final days = DateTime.now().difference(parsedDate).inDays;
    return days ~/ 365;
  }

  String lionsEarned(int lionsAB, int lionsRB, int lionsSB) {
    final sum = lionsAB + lionsRB + lionsSB;

    if (sum > 1000000) {
      final tempSum = sum / 1000000;
      return '${tempSum.toStringAsFixed(1)} M';
    } else {
      final tempSum = sum / 1000;
      return '${tempSum.toStringAsFixed(1)} K';
    }
  }

  int parseWtDateTime(String wtDateTime) {
    if (wtDateTime.contains('N/A')) {
      return 0;
    }

    if (wtDateTime.contains('M')) {
      final monthsString = wtDateTime.replaceAll(' M', '');
      final months = double.tryParse(monthsString) ?? 0;
      return (months * 730.5).toInt();
    } else if (wtDateTime.contains('d')) {
      final daysStrings = wtDateTime.split('d ');
      final days = double.tryParse(daysStrings[0]) ?? 0;
      final hours = double.tryParse(daysStrings[1].replaceAll('h', '')) ?? 0;
      return ((days * 24) + hours).toInt();
    } else if (wtDateTime.contains('h')) {
      final hoursString = wtDateTime.split('h ');
      final hours = double.tryParse(hoursString[0]) ?? 0;
      return hours.toInt();
    } else {
      return 0;
    }
  }

  double totalKd(List<KillDeath> kdList) {
    int totalBattles = 0;
    double result = 0;
    final List<KillDeath> importantMode = [];

    for (final e in kdList) {
      totalBattles = totalBattles + e.battleNumber;
      e.modeKd = e.killNumber / e.battleNumber;
    }

    for (final x in kdList) {
      if (x.battleNumber / totalBattles >= 0.125) {
        importantMode.add(x);
      }
    }

    for (final y in importantMode) {
      result = result + y.modeKd;
    }

    return result / importantMode.length;
  }

  double calculateKd(List<KillDeath> kdList, String modeName) {
    final mode = kdList.where((e) => e.modeName == modeName).single;
    return mode.killNumber / mode.battleNumber;
  }
}
