import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fpg_family_app/home_page_screen.dart';
import 'package:fpg_family_app/listner/bloc/listen_bloc.dart';
import 'package:fpg_family_app/page_manager.dart';
import 'package:fpg_family_app/repositories/feed_repository.dart';
import 'package:fpg_family_app/repositories/podcast_repository.dart';
import 'package:fpg_family_app/services/service_locator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'audio/audio_player_handler.dart';

Future<void> main() async {

  await WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await FlutterDownloader
      .initialize(
      debug: true
  );
  await Firebase.initializeApp();

  FeedsRepository feedsRepository = FeedsRepository();
  PodcastRepository podcastsRepository = PodcastRepository();
  await podcastsRepository.getChannelDetails();

  getIt<PageManager>().init(podcastsRepository.feeds);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'FPG Family',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
            /*TextTheme(
                bodyText1: TextStyle(color: Colors.white, fontSize: 13, ),
                bodyText2: TextStyle(color: Colors.white, fontSize: 13),
                subtitle2: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                subtitle1: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)
            ),*/
        ),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListenBloc>(
            create: (context) {
              return ListenBloc();
            },
          )
        ],
        child: HomePageScreen(),
      ),
    );
  }
}



