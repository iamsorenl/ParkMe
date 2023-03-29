import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkme/components/create_listing/index.dart';
import 'package:parkme/pages/homepage/homepage.dart';
import 'package:parkme/pages/spot/activity_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../pages/settings/index.dart';

class App extends StatefulWidget {
  final VoidCallback onSpotCreationSuccess;
  const App({Key? key, this.onSpotCreationSuccess = _defaultCallback})
      : super(key: key);

  static void _defaultCallback() {}

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 1);

  void onSpotCreationSuccess() {
    setState(() {
      _controller.index = 1; // Set the index to the "homepage"
    });
  }

  List<Widget> _buildScreens() {
    return [
      const ActivityPage(),
      const TheHomePage(),
      CreateSpotPage(onSpotCreationSuccess: onSpotCreationSuccess),
      EditProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.clock),
        title: ("Activity"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.directions_car),
        title: ("Park"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.add),
        title: ("Create Spot"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          false, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
