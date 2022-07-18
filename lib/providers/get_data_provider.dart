import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

    final player = Player(
      nickname: nickname[0],
      squadron: squadron.isEmpty ? '' : squadron[0],
      avatar: 'https:${avatar[0]}',
      title: titleAndLevel[0],
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
}
