import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wt_skillmeter/providers/apple_signin_provider.dart';
import 'package:wt_skillmeter/providers/google_signin_provider.dart';
import 'package:wt_skillmeter/utilities/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.of(context).size;
    double tabletScreenWidth = screenSize.width - 40;
    if (screenSize.width > 600) {
      tabletScreenWidth = 600;
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/icons/icon.png', width: 144),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(text: localizations.hello_there, style: roboto22blackBold),
                    TextSpan(text: localizations.welcome_back, style: roboto14greyMedium),
                  ]),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: tabletScreenWidth,
                      child: Platform.isAndroid
                          ? ElevatedButton.icon(
                              onPressed: () {
                                context.read<GoogleSignInProvider>().googleLogin();
                              },
                              icon: const FaIcon(FontAwesomeIcons.google, size: 20),
                              label: Text(
                                localizations.sign_up,
                                style: roboto14whiteSemiBold,
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () {
                                context.read<AppleSignInProvider>().signInWithApple();
                              },
                              icon: const FaIcon(FontAwesomeIcons.apple, size: 20),
                              label: Text(
                                localizations.sign_up_apple,
                                style: roboto14whiteSemiBold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      width: tabletScreenWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(localizations.why_login),
                                    content: const Text(
                                        'The security policies of the database we use require user authorization. We use a simple login system via Google or Apple account, familiar to you from other programs'),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Center(child: Text('OK')),
                                      ),
                                    ],
                                  ));
                        },
                        child: Text(localizations.why_login, style: roboto14blackBold),
                        style: ElevatedButton.styleFrom(
                          primary: kButtonGreyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
