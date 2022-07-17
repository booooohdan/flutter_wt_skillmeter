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
    log('s');
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

    final player = Player(
      nickname: nickname[0],
      squadron: squadron.isEmpty ? '' : squadron[0],
      avatar: 'https:${avatar[0]}',
      title: titleAndLevel[0],
      level: titleAndLevel[1],
      signUpDate: regDate[0].replaceAll('Registration date ', ''),
      completedMissions: completedAB + completedRB + completedSB,
      lionsEarned: lionsEarned(lionsAB, lionsRB, lionsSB),
      playTime: playAB + playRB + playSB,
      yearsOld: countAccYears(regDate[0]),
    );

    //TODO: Handle possible exception (try/catch)
    log('message');
    return player;
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

  int countAccYears(String regDate) {
    var parsedDate = DateFormat('dd.MM.yyyy').parse(regDate.replaceAll('Registration date ', ''));
    var days = DateTime.now().difference(parsedDate).inDays;
    return (days / 365).toInt();
  }
}
