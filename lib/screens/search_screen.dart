import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wt_skillmeter/models/chart_data.dart';
import 'package:wt_skillmeter/models/player.dart';
import 'package:wt_skillmeter/providers/get_data_provider.dart';
import 'package:wt_skillmeter/utilities/ads_collection.dart';
import 'package:wt_skillmeter/utilities/constants.dart';
import 'package:wt_skillmeter/widgets/tile_doughnut_chart.dart';
import 'package:wt_skillmeter/widgets/tile_mode_stats_table.dart';
import 'package:wt_skillmeter/widgets/tile_radial_gauge.dart';
import 'package:wt_skillmeter/widgets/tile_stacked_bar_chart.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final defaultAvatar = 'https://static.warthunder.com/i/avatar/cardicon_default.jpg';
  bool isFirstInit = false;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  final _searchController = TextEditingController();
  Player? player;

  void _onSearchChanged() {
    if (_searchController.text != '') {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isFirstInit) {
      isFirstInit = true;
      bannerAdLoad();
      _searchController.addListener(_onSearchChanged);
    }
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final localizations = AppLocalizations.of(context)!;
    Color mainColor = Colors.green;
//TODO: Separate to widgets
//TODO: Add translation
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: mainColor,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoTextField(
                            controller: _searchController,
                            decoration: const BoxDecoration(color: Colors.transparent),
                            onSubmitted: (value) async {
                              player = await context.read<GetDataProvider>().getPlayerDataFromWebsite(value);
                              setState(() {});
                            },
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            placeholder: localizations.search,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            style: roboto14whiteSemiBold,
                          ),
                        ),
                        PopupMenuButton<int>(
                          itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.computerMouse),
                                  SizedBox(width: screenSize.width / 25),
                                  const Text('PC'),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.playstation),
                                  SizedBox(width: screenSize.width / 50),
                                  const Text('PSX'),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.xbox),
                                  SizedBox(width: screenSize.width / 40),
                                  const Text('XBOX'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (int value) {
                            //TODO: Add @live or @psn to nickname
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.gamepad,
                            color: Colors.white,
                          ),
                          //color: Colors.transparent,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // TODO: Made animation progress
                    LinearProgressIndicator(),
                    const SizedBox(height: 15),
                    Container(
                      height: screenSize.width / 4.2,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  player?.avatar ?? defaultAvatar,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: mainColor,
                                    width: 2,
                                  ),
                                ),
                                width: screenSize.width / 11.8,
                                height: screenSize.width / 11.8,
                                child: Text(
                                  player?.yearsOld.toString() ?? '',
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: mainColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 28),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(player?.nickname ?? 'Player', style: roboto26whiteBold),
                                Text(player?.squadron ?? 'Squadron', style: roboto14whiteSemiBold),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    player?.title ?? 'Title',
                                    //maxLines: 1,
                                    style: roboto14whiteSemiBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          const Icon(Icons.edit_calendar, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(player?.signUpDate ?? 'Sign Up Date', style: roboto14whiteSemiBold),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              player?.level ?? 'Level',
                              style: GoogleFonts.roboto(fontSize: 14, color: mainColor, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: roboto26whiteBold,
                                children: [
                                  TextSpan(text: player?.completedMissions.toString() ?? '0'),
                                  const TextSpan(text: '\n'),
                                  TextSpan(text: 'BATTLES', style: yanone20whiteRegular),
                                ],
                              ),
                            ),
                            Container(width: 1, color: Colors.white),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: roboto26whiteBold,
                                children: [
                                  TextSpan(text: player?.lionsEarned.toString() ?? '0'),
                                  const TextSpan(text: '\n'),
                                  TextSpan(text: 'SILVER LIONS', style: yanone20whiteRegular),
                                ],
                              ),
                            ),
                            Container(width: 1, color: Colors.white),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: roboto26whiteBold,
                                children: [
                                  TextSpan(text: player?.playTime.toString() ?? '0'),
                                  const TextSpan(text: '\n'),
                                  TextSpan(text: 'HOURS', style: yanone20whiteRegular),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/hexagon.svg',
                                height: screenSize.width / 7,
                                color: Colors.white,
                              ),
                              Text(player?.favoriteGameMode ?? 'AAA', style: roboto22blackBold),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/hexagon.svg',
                                height: screenSize.width / 7,
                                color: Colors.white,
                              ),
                              Image.asset(
                                'assets/vehicleTypes/${player?.favoriteVehicleType ?? 'Fighter'}.png',
                                height: screenSize.width / 10,
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/hexagon.svg',
                                height: screenSize.width / 7,
                                color: Colors.white,
                              ),
                              SvgPicture.asset(
                                'assets/flags/${player?.favoriteNation ?? 'usa'}.svg',
                                height: screenSize.width / 14,
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/hexagon.svg',
                                height: screenSize.width / 7,
                                color: Colors.white,
                              ),
                              Text('${player?.spadedPercent ?? '0'}%', style: roboto22blackBold),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    TileRadialGauge(title: 'K/D Ratio', value: player?.totalKD ?? 0, isKD: true),
                    const SizedBox(width: 10),
                    TileRadialGauge(title: 'Win Rate', value: player?.winRates ?? 0, isKD: false),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TileModeStatsTable(
                      title: 'Aviation',
                      plane: player?.aviationAirDestroyed.toString() ?? '0',
                      tank: player?.aviationGroundDestroyed.toString() ?? '0',
                      ship: player?.aviationNavalDestroyed.toString() ?? '0',
                      time: '${player?.aviationTimePlayed ?? '0'}h',
                      battles: player?.aviationBattlesPlayed.toString() ?? '0',
                      mode: 'avia',
                    ),
                    const SizedBox(width: 10),
                    TileModeStatsTable(
                      title: 'Ground Forces',
                      plane: player?.groundAirDestroyed.toString() ?? '0',
                      tank: player?.groundTankDestroyed.toString() ?? '0',
                      ship: '0',
                      time: '${player?.groundTimePlayed ?? '0'}h',
                      battles: player?.groundBattlesPlayed.toString() ?? '0',
                      mode: 'tank',
                    ),
                    const SizedBox(width: 10),
                    TileModeStatsTable(
                      title: 'Fleet',
                      plane: player?.navalAirDestroyed.toString() ?? '0',
                      tank: '0',
                      ship: player?.navalShipDestroyed.toString() ?? '0',
                      time: '${player?.navalTimePlayed ?? '0'}h',
                      battles: player?.navalBattlesPlayed.toString() ?? '0',
                      mode: 'ship',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    TileDoughnutChart(
                      title: 'Game modes',
                      listData: player?.gameModesChart ??
                          [
                            ChartData(x: 'Label', y: 1, color: Color(0xFF898A8B)),
                            ChartData(x: 'Label', y: 1, color: Color(0xFF494949)),
                            ChartData(x: 'Label', y: 1, color: Color(0xFFC1C1C1)),
                          ],
                    ),
                    const SizedBox(width: 10),
                    TileDoughnutChart(
                      title: 'Favorite Vehicle Type',
                      listData: player?.typeOfVehicleChart ??
                          [
                            ChartData(x: 'Label', y: 1, color: Color(0xFF898A8B)),
                            ChartData(x: 'Label', y: 1, color: Color(0xFF494949)),
                            ChartData(x: 'Label', y: 1, color: Color(0xFFC1C1C1)),
                          ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  TileStackedBarChart(
                    title: 'Researched Vehicle',
                    listData: player?.researchedVehicleChart ??
                        [
                          ChartData(x: 'NAT', y: 3, y1: 2, y2: 1),
                        ],
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  void bannerAdLoad() {
    final adsCollection = AdsCollection();
    //FIXME: Comment code above, and uncomment below if dart file isn't found
    // final adsCollection = DebugAdsCollection();
    _bannerAd = BannerAd(
      adUnitId: adsCollection.bannerProfileAdUnitId(),
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }
}
