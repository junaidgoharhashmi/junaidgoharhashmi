import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_search_app/seeker/widgets/menu_page.dart';
import 'package:job_search_app/seeker/widgets/models/menuItem.dart';
import 'package:job_search_app/services/database_seeker.dart';
import 'package:job_search_app/shared/screens.dart';

class FlutterZoomDrawerDemo extends StatefulWidget {
  @override
  _FlutterZoomDrawerDemoState createState() => _FlutterZoomDrawerDemoState();
}

class _FlutterZoomDrawerDemoState extends State<FlutterZoomDrawerDemo> {
  User? user = FirebaseAuth.instance.currentUser;
  MenuItemModel currentItem = MenuItems.home;
  String name  = "";
  final _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) => ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.Style4, // Best Style 1, 4, == OK Style 6,7
        mainScreen: name != currentItem.title?getScreen():Center(),
        menuScreen: Builder(
          builder: (context) => MenuPage(
            currentItem: currentItem,
            onSelectedItem: (item) {
              if(item.title != currentItem.title)
                {
                  name = currentItem.title;
                  setState(() => currentItem = item);
                  ZoomDrawer.of(context)!.close();
                }

            },
          ),
        ),
        borderRadius: 40.0,
        showShadow: true,
        // angle: 0.0,
        backgroundColor: Color(0xff7084A4).withOpacity(0.44),
        slideWidth: MediaQuery.of(context).size.width * 0.6,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
      );
  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.home: // Home Screen
        return HomeScreen();
      case MenuItems.profile: // Profile
        return Profile();
      case MenuItems.jobs: // View Applied Jobs
        return ViewMyJob();
      case MenuItems.favourite: // Saved Jobs
        return Favourite();
      case MenuItems.password: // Change Password
        return ChangePassword();
      case MenuItems.logout: // Logout
        DatabaseSeekerService(uid: user!.uid).logout();
        return LoginPage();
      case MenuItems.aboutUs: // About Us
        return HomeScreen();
      default:
        return HomeScreen(); // HomeScreen default page
    }
  }
}
