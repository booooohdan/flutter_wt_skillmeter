import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:wt_skillmeter/models/player.dart';
import 'package:wt_skillmeter/providers/get_data_provider.dart';
import 'package:wt_skillmeter/utilities/ads_collection.dart';
import 'package:wt_skillmeter/utilities/constants.dart';

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
                                  const FaIcon(FontAwesomeIcons.mouse),
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
                          onSelected: (int value) {},
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(player?.nickname ?? 'Player', style: roboto26whiteBold),
                              Text(player?.squadron ?? 'Squadron', style: roboto14whiteSemiBold),
                              Text(player?.title ?? 'Title', style: roboto14whiteSemiBold),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.edit_calendar, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(player?.signUpDate ?? 'Sign Up date', style: roboto14whiteSemiBold),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: IntrinsicHeight(
                        child: player?.completedMissions != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: roboto26whiteBold,
                                      children: [
                                        TextSpan(text: player?.completedMissions.toString() ?? ''),
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
                                        TextSpan(text: player?.lionsEarned.toString() ?? ''),
                                        const TextSpan(text: '\n'),
                                        TextSpan(text: 'SL', style: yanone20whiteRegular),
                                      ],
                                    ),
                                  ),
                                  Container(width: 1, color: Colors.white),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: roboto26whiteBold,
                                      children: [
                                        TextSpan(text: player?.playTime.toString() ?? ''),
                                        const TextSpan(text: '\n'),
                                        TextSpan(text: 'HOURS', style: yanone20whiteRegular),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.blueGrey,
                height: 200,
                width: double.infinity,
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
