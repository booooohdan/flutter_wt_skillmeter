import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wt_skillmeter/models/player.dart';

class OldParser {
  List<String> nickname = [];
  List<String> squadron = [];
  List<String> avatar = [];
  List<String> titleAndLevel = [];
  List<String> regData = [];
  List<String> playerStatistics = [];
  List<String> playerVehicles = [];

  Future<void> _parseNickname() async {
    var url = Uri.parse('https://warthunder.com/en/community/userinfo/?nick=Keofox');
    var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    var htmlString = response.body;

    nickname = getTableData(htmlString, 'user-profile__data-nick');
    squadron = getTableData(htmlString, 'user-profile__data-link');
    avatar = getTableData(htmlString, 'user-profile__ava');
    titleAndLevel = getTableData(htmlString, 'user-profile__data-item');
    regData = getTableData(htmlString, 'user-profile__data-regdate');
    playerStatistics = getTableData(htmlString, 'user-stat__list-item');
    playerVehicles = getTableData(htmlString, 'user-score__list-item');

    // final player = Player(
    //   nickname: nickname[0].trim(),
    //   squadron: squadron[0].trim(),
    //   avatar: avatar[0].trim(),
    //   title: titleAndLevel[0].trim(),
    //   level: titleAndLevel[1].trim().replaceAll('Level ', ''),
    //   signUpDate: regData[0].trim().replaceAll('Registration date ', ''),
    // );

    log('Response body: ${response.body}');
  }

  List<String> getTableData(String htmlString, String tableName) {
    List<String> listString = [];
    List<String> splitedString = [];

    if (Platform.isAndroid) {
      splitedString = htmlString.split('<');
    } else if (Platform.isIOS) {
      splitedString = htmlString.split('u003');
    }

    for (var s in splitedString) {
      if (Platform.isAndroid) {
        if (s.contains(tableName)) {
          var trimStart = s.substring(s.indexOf('>') + 1);
          var trimEnd = trimStart.substring(0, trimStart.length - 0);
          listString.add(trimEnd);
        }
      } else if (Platform.isIOS) {
        if (s.contains(tableName)) {
          var trimStart = s.substring(s.indexOf('>') + 1);
          var trimEnd = trimStart.substring(0, trimStart.length - 1);
          listString.add(trimEnd);
        }
      }
    }

    return listString;
  }
}
