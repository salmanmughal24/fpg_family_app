import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fpg_family_app/video_player.dart';
import 'package:fpg_family_app/watch_section.dart';
import 'package:fpg_family_app/yoyo_player.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route) async{
      if(route != null){
        if(route.contains(".m3u8")){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> LiveStreamingPlayer(videoUrl: route)));
        }
        else if(route.contains("https://www.youtube.com/watch?v=")){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoPlayerr(videooUrl:route)));
        }
        else {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> WatchSection()));
        }

      }
    });
  }

  static void display(RemoteMessage message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
            "fpg_family",
            "fpg_family channel",
              channelDescription: "this is our channel",
              importance: Importance.max,
              priority: Priority.high,

          )
      );


      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}