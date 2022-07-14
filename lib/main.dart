import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wt_skillmeter/providers/apple_signin_provider.dart';
import 'package:wt_skillmeter/providers/firestore_provider.dart';
import 'package:wt_skillmeter/providers/get_data_provider.dart';
import 'package:wt_skillmeter/providers/google_signin_provider.dart';
import 'package:wt_skillmeter/screens/signup_screen.dart';
import 'package:wt_skillmeter/utilities/constants.dart';
import 'package:wt_skillmeter/utilities/introduction_screen_list.dart';
import 'package:wt_skillmeter/widgets/bottom_navigation_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  final preferences = await SharedPreferences.getInstance();
  final _skipIntroduction = preferences.getBool('skipIntroduction') ?? false;
  Future<void> initAppTrackingTransparency() async {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: kLightGreyColor,
  //     statusBarBrightness: Brightness.dark,
  //     statusBarIconBrightness: Brightness.dark,
  //   ),
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FirestoreProvider>(
          create: (_) => FirestoreProvider(),
        ),
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (_) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider<AppleSignInProvider>(
          create: (_) => AppleSignInProvider(),
        ),
        ChangeNotifierProvider<GetDataProvider>(
          create: (_) => GetDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'WT Skill Meter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blueGrey,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: kLightGreyColor,
            elevation: 0,
            toolbarHeight: 76,
            titleTextStyle: roboto26whiteBold,
            iconTheme: const IconThemeData(color: kIconGreyColor),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: kBlackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: kBlackColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          dividerColor: Colors.transparent,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', ''),
          Locale('uk', ''),
        ],
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // FirebaseCrashlytics.instance.crash();
            initAppTrackingTransparency();
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasData) {
              return _skipIntroduction
                  ? BottomNavBar()
                  : IntroductionScreen(
                      pages: getIntroductionPages(context),
                      showBackButton: true,
                      back: const Icon(Icons.navigate_before),
                      next: const Icon(Icons.navigate_next),
                      done: Text(AppLocalizations.of(context)!.done),
                      onDone: () {
                        preferences.setBool('skipIntroduction', true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => BottomNavBar()),
                        );
                      },
                    );
              // Main entry point
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something Went Wrong!'));
            } else {
              return const SignUpScreen();
            }
          },
        ),
      ),
    ),
  );
}
