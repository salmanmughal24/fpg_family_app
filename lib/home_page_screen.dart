import 'package:flutter/material.dart';
import 'package:fpg_family_app/foryou.dart';
import 'package:fpg_family_app/layouts/my_scaffold.dart';
import 'package:fpg_family_app/read_section.dart';
import 'package:fpg_family_app/repositories/podcast_repository.dart';
import 'package:fpg_family_app/watch_section.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import 'helper/colors.dart';
import 'helper/dimens.dart';
import 'helper/utils.dart';
import 'listner/listen_section.dart';
import 'repositories/feed_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class HomePageScreen extends StatefulWidget {
  HomePageScreen();

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController(
    keepPage: true,
  );

  @override
  void initState() {
    askPermission();
 /*   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
            //    channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: this.context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });*/
    super.initState();
  }
  askPermission() async {
    final status =
        await Permission
        .storage
        .request();
    if (status
        .isGranted) {

    } else {
      print(
          "No Permission");
    }
  }

  FeedsRepository feedsRepository = FeedsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr_black,
      appBar: AppBar(
        backgroundColor: clr_black,
        title: Text(
          'FPG Family',
          style: label_appbar(),
        ),
        actions: [
          IconButton(onPressed: () {
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: () {
          /*  flutterLocalNotificationsPlugin.show(
                0,
                "Testing Fgp Family",
                "How you doing ?",
                NotificationDetails(
                    android: AndroidNotificationDetails(channel.id, channel.name, *//*channel.description*//*
                        importance: Importance.high,
                        color: Colors.blue,
                        playSound: true,
                        icon: '@mipmap/ic_launcher')));*/

          }, icon: Icon(Icons.settings)),
        ],
      ),
      body: MainBody(
        body: PageView.builder(
          controller: _pageController,
          itemBuilder: (context, index) {
            if (index == 0) {
              return WatchSection();
            }
            if (index == 1) {
              return ListenSection();
            }
            if (index == 2) {
              return ReadSection(feedsRepository);
            }
            if (index == 3) {
              return ForYouSection();
            }
            return Container();
          },
          onPageChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          itemCount: 4,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: clr_selected_icon,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        backgroundColor: clr_black,
        elevation: 2,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Watch',
            backgroundColor: clr_black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_down),
            label: 'Listen',
            backgroundColor: clr_black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Read',
            backgroundColor: clr_black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'For You',
            backgroundColor: clr_black,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
            _pageController.animateToPage(_currentIndex,
                duration: Duration(milliseconds: 100), curve: Curves.ease);
          });
        },
      ),
    );
  }
}
