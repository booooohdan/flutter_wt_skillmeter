import 'package:wt_skillmeter/models/chart_data.dart';

class Player {
  Player({
    required this.nickname,
    required this.squadron,
    required this.avatar,
    required this.title,
    required this.level,
    required this.signUpDate,
    required this.yearsOld,
    required this.completedMissionAB,
    required this.completedMissionRB,
    required this.completedMissionSB,
    required this.completedMissions,
    required this.lionsEarnedAB,
    required this.lionsEarnedRB,
    required this.lionsEarnedSB,
    required this.lionsEarned,
    required this.playTimeAB,
    required this.playTimeRB,
    required this.playTimeSB,
    required this.playTime,
    required this.winRatesAB,
    required this.winRatesRB,
    required this.winRatesSB,
    required this.winRates,
    required this.kdAirAB,
    required this.kdAirRB,
    required this.kdAirSB,
    required this.kdTankAB,
    required this.kdTankRB,
    required this.kdTankSB,
    required this.kdShipAB,
    required this.kdShipRB,
    required this.totalKD,
    required this.aviationAirDestroyed,
    required this.aviationGroundDestroyed,
    required this.aviationNavalDestroyed,
    required this.aviationTimePlayed,
    required this.aviationBattlesPlayed,
    required this.groundAirDestroyed,
    required this.groundTankDestroyed,
    required this.groundTimePlayed,
    required this.groundBattlesPlayed,
    required this.navalAirDestroyed,
    required this.navalShipDestroyed,
    required this.navalTimePlayed,
    required this.navalBattlesPlayed,
    required this.gameModesChart,
    required this.typeOfVehicleChart,
    required this.researchedVehicleChart,
    required this.favoriteGameMode,
    required this.favoriteVehicleType,
    required this.favoriteNation,
    required this.spadedPercent,
  });

  String nickname;
  String squadron;
  String avatar;
  String title;
  String level;
  String signUpDate;
  int yearsOld;

  int completedMissionAB;
  int completedMissionRB;
  int completedMissionSB;
  int completedMissions;
  int lionsEarnedAB;
  int lionsEarnedRB;
  int lionsEarnedSB;
  String lionsEarned;
  int playTimeAB;
  int playTimeRB;
  int playTimeSB;
  int playTime;

  double kdAirAB;
  double kdAirRB;
  double kdAirSB;
  double kdTankAB;
  double kdTankRB;
  double kdTankSB;
  double kdShipAB;
  double kdShipRB;
  double totalKD;

  int winRatesAB;
  int winRatesRB;
  int winRatesSB;
  double winRates;

  int aviationAirDestroyed;
  int aviationGroundDestroyed;
  int aviationNavalDestroyed;
  int aviationTimePlayed;
  int aviationBattlesPlayed;

  int groundAirDestroyed;
  int groundTankDestroyed;
  int groundTimePlayed;
  int groundBattlesPlayed;

  int navalAirDestroyed;
  int navalShipDestroyed;
  int navalTimePlayed;
  int navalBattlesPlayed;

  List<ChartData> gameModesChart;
  List<ChartData> typeOfVehicleChart;
  List<ChartData> researchedVehicleChart;

  String favoriteGameMode;
  String favoriteVehicleType;
  String favoriteNation;
  int spadedPercent;

  //TODO: Refactor to list where available
}
