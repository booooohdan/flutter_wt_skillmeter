import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:wt_skillmeter/screens/comparison_screen.dart';
import 'package:wt_skillmeter/screens/feedback_screen.dart';
import 'package:wt_skillmeter/screens/profile_screen.dart';
import 'package:wt_skillmeter/screens/search_screen.dart';
import 'package:wt_skillmeter/utilities/constants.dart';

class BottomNavBar extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      // const ProfileScreen(),
      const SearchScreen(),
      // const ComparisonScreen(),
      const FeedbackScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        // PersistentBottomNavBarItem(
        //   icon: const Icon(Icons.person),
        //   title: localizations.profile,
        //   activeColorPrimary: Colors.redAccent,
        //   inactiveColorPrimary: Colors.grey,
        // ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_search),
          title: localizations.search,
          activeColorPrimary: Colors.redAccent,
          inactiveColorPrimary: Colors.grey,
        ),
        // PersistentBottomNavBarItem(
        //   icon: const Icon(Icons.compare_arrows),
        //   title: localizations.comparison,
        //   activeColorPrimary: Colors.redAccent,
        //   inactiveColorPrimary: Colors.grey,
        // ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.chat_bubble_outline),
          title: localizations.feedback,
          activeColorPrimary: Colors.redAccent,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: _controller,
      backgroundColor: kLightGreyColor,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style1,
      resizeToAvoidBottomInset: true,
    );
  }
}
