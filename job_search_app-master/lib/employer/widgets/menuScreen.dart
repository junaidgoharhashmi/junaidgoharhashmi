import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_search_app/employer/home/open_jobs.dart';
import 'package:job_search_app/employer/home/candidates.dart';
import 'package:job_search_app/seeker/widgets/models/menuItem.dart';
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/shared/screens.dart';

class MenuScreenItems {
  static const home = MenuItemModel('Home', Icons.home);

  // Recruiter Navigation Drawer
  static const jobOpening = MenuItemModel('Job Openings', Icons.work_rounded);
  static const candidates =
      MenuItemModel('Candidates', CupertinoIcons.person_badge_plus_fill);

  static const editJobs = MenuItemModel('Edit Jobs', Icons.edit_attributes);
  static const logout = MenuItemModel('Logout', Icons.logout);
  static const settings = MenuItemModel('Settings', Icons.settings);

  static const rec = <MenuItemModel>[
    home,
    jobOpening,
    candidates,
    editJobs,
    settings,
    logout,
  ];
}

class MenuScreenEmployer extends StatelessWidget {
  final MenuItemModel currentItem;
  final ValueChanged<MenuItemModel> onSelectedItem;
  const MenuScreenEmployer(
      {Key? key, required this.currentItem, required this.onSelectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromRGBO(50, 75, 205, 1),
      backgroundColor: Colors.white,
      body: Theme(
        data: ThemeData.light(),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots(includeMetadataChanges: true),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              var data = snapshot.data!.data();
              var name = data!['companyName'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 12.0, left: 20.0),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            //avatar1.png  user_profile.jpg
                            backgroundImage:
                                AssetImage('assets/images/default_user.png'),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          name.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: color.AppColor.welcomeImageContainer,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...MenuScreenItems.rec.map(buildMenuItem).toList(),
                  Spacer(
                    flex: 2,
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget buildMenuItem(MenuItemModel item) => ListTileTheme(
        selectedColor: color.AppColor.welcomeImageContainer,
        child: ListTile(
          selectedTileColor:
              Colors.transparent, // Set to other color to make it visible
          selected: currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(item.icon),
          title: Text(item.title),
          onTap: () => onSelectedItem(item),
        ),
      );
}
