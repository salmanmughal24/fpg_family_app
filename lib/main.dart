import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fpg_family_app/foryou.dart';
import 'package:fpg_family_app/home_page_screen.dart';
import 'package:fpg_family_app/listner/bloc/listen_bloc.dart';
import 'package:fpg_family_app/page_manager.dart';
import 'package:fpg_family_app/read_section.dart';
import 'package:fpg_family_app/repositories/feed_repository.dart';
import 'package:fpg_family_app/repositories/podcast_repository.dart';
import 'package:fpg_family_app/services/service_locator.dart';
import 'package:fpg_family_app/watch_section.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import 'audio/audio_player_handler.dart';
import 'listner/listen_section.dart';
import 'model/theme_model.dart';

Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);
}
Future<void> main() async {

  await WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await FlutterDownloader
      .initialize(
      debug: true
  );
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  FeedsRepository feedsRepository = FeedsRepository();
  PodcastRepository podcastsRepository = PodcastRepository();
  await podcastsRepository.getChannelDetails();

  final appDocumentDirectory =
  await pathProvider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);

  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;

  print(isLightTheme);
  getIt<PageManager>().init(podcastsRepository.feeds);
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(isLightTheme: isLightTheme),
    child: AppStart(),
  ));

}
class AppStart extends StatelessWidget {
  const AppStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MyApp(
      themeProvider: themeProvider,
    );
  }
}
class MyApp extends StatefulWidget with WidgetsBindingObserver  {
  final ThemeProvider themeProvider;
   MyApp({Key? key, required this.themeProvider}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FeedsRepository feedsRepository = FeedsRepository();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'FPG Family',
      theme: widget.themeProvider.themeData(),
     /* theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
        ),

        primarySwatch: Colors.blue,
      ),*/
      routes: {
        "watch": (_) => WatchSection(),
        "listen": (_) => ListenSection(),
        "read": (_) => ReadSection(feedsRepository),
        "foryou": (_) => ForYouSection(),
      },
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



