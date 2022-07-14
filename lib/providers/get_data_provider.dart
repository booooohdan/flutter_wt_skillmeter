import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
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

    final lionsEarn = lionsAB + lionsRB + lionsSB;
    lionsEarn > 1000000 ? lionsEarn.toStringAsFixed(1) : lionsEarn.toString();
    // final playAB = int.tryParse(arcadeBattles[6]) ?? 0;
    // final playRB = int.tryParse(realisticBattles[6]) ?? 0;
    // final playSB = int.tryParse(simulatorBattles[6]) ?? 0;

    final player = Player(
      nickname: nickname[0],
      squadron: squadron.isEmpty ? '' : squadron[0],
      avatar: 'https:${avatar[0]}',
      title: titleAndLevel[0],
      level: titleAndLevel[1],
      signUpDate: regDate[0].replaceAll('Registration date ', ''),
      completedMissions: completedAB + completedRB + completedSB,
      lionsEarned: lionsEarned(lionsAB, lionsRB, lionsSB),
      playTime: '1000',
    );

    //TODO: Handle possible exception (try/catch)
    log('message');
    return player;
  }
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
