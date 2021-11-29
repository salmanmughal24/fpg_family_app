import 'package:flutter/material.dart';
import 'package:fpg_family_app/foryou.dart';
import 'package:fpg_family_app/layouts/my_scaffold.dart';
import 'package:fpg_family_app/read_section.dart';
import 'package:fpg_family_app/repositories/podcast_repository.dart';
import 'package:fpg_family_app/services/local_notification_service.dart';
import 'package:fpg_family_app/setttings.dart';
import 'package:fpg_family_app/video_player.dart';
import 'package:fpg_family_app/watch_section.dart';
import 'package:fpg_family_app/yoyo_player.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'helper/colors.dart';
import 'helper/dimens.dart';
import 'helper/utils.dart';
import 'listner/listen_section.dart';
import 'model/theme_model.dart';
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
    super.initState();
    LocalNotificationService.initialize(this.context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        if(message.data["route"] != null){
          if(message.data["route"].contains(".m3u8")){
            Navigator.push(this.context, MaterialPageRoute(builder: (context)=> LiveStreamingPlayer(videoUrl: message.data["route"], title: '', author: '', thumbnail: '',)));
          }
          else if(message.data["route"].contains("https://www.youtube.com/watch?v=")){
            Navigator.push(this.context, MaterialPageRoute(builder: (context)=> VideoPlayerr(videooUrl:message.data["route"])));
          }
          else {
            Navigator.push(this.context, MaterialPageRoute(builder: (context)=> WatchSection()));
          }

        }
        //Navigator.of(this.context).pushNamed(routeFromMessage);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        print(message.notification!.body);
        print(message.notification!.title);

      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      if(message != null){
        if(message.data["route"] != null){
          if(message.data["route"].contains(".m3u8")){
            Navigator.push(this.context, MaterialPageRoute(builder: (context)=> LiveStreamingPlayer(videoUrl: message.data["route"], title: '', author: '', thumbnail: '',)));
          }
          else if(message.data["route"].contains("https://www.youtube.com/watch?v=")){
            Navigator.push(this.context, MaterialPageRoute(builder: (context)=> VideoPlayerr(videooUrl:message.data["route"])));
          }
          else {
            Navigator.push(this.context, MaterialPageRoute(builder: (context)=> WatchSection()));
          }

        }
        //Navigator.of(this.context).pushNamed(routeFromMessage);
      }
    });

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    print(themeProvider.isLightTheme);
    return Scaffold(
        backgroundColor: themeProvider.isLightTheme
            ? Colors.white
            : Color(0xFF26242e),
      /*backgroundColor: clr_black,
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
          }, icon: Icon(Icons.settings)),
        ],
      ),*/
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
            if (index == 4) {
              return SettingsScreen();
            }
            return Container();
          },
          onPageChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: clr_selected_icon,
        unselectedItemColor: themeProvider.isLightTheme
            ? Colors.black
            : Colors.white,
        type: BottomNavigationBarType.fixed,
        backgroundColor: themeProvider.isLightTheme
            ? Colors.white
            : clr_black,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
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
