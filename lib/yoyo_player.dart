
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:fpg_family_app/model/theme_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'helper/colors.dart';


class LiveStreamingPlayer extends StatefulWidget {
  String videoUrl;
  LiveStreamingPlayer({Key? key, required this.videoUrl}) : super(key: key);
  @override
  _LiveStreamingPlayerState createState() => _LiveStreamingPlayerState();
}

class _LiveStreamingPlayerState extends State<LiveStreamingPlayer> {

 /* late VideoPlayerController videoPlayerController;
   ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await Future.wait([
      videoPlayerController.initialize()
    ]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      isLive: true,
      looping: true,
      autoInitialize: true,
      showControls: true,
      cupertinoProgressColors: ChewieProgressColors(playedColor: Colors.deepOrange, bufferedColor: Colors.deepOrangeAccent.withOpacity(0.25)),
      placeholder: Container(
        color: Colors.black87,
        child: Container(
          child: Center(
              child: CircularProgressIndicator(
                valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              )),
        ),
      ),
    );
    setState(() {

    });
  }
  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(

          body: Container(
            color: Colors.black,
            child: Center(
              child: chewieController != null ?
                  chewieController!.videoPlayerController.value.isInitialized
                  ? Chewie(
                controller: chewieController!,
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.deepOrange,),
                  SizedBox(height: 20),
                  Text("Loading"),
                ],
              ): Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.deepOrange,),
                  SizedBox(height: 20),
                  Text("Loading"),
                ],
              ),
            ),
          ));
    }*/

  late BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      autoDispose: true,
      autoDetectFullscreenDeviceOrientation: true,
      fullScreenByDefault: false,
      handleLifecycle: true,
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,

    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    print("dispose call");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isLightTheme
          ? clr_white
          : clr_black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 8,
            child: BetterPlayer(
              controller: _betterPlayerController,
              key: _betterPlayerKey,
            ),
          ),
          /*RaisedButton(
            color: clr_selected_icon,
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
            child: Text("Move Background", style: GoogleFonts.openSans(textStyle: TextStyle(color: clr_white,fontSize: 20)),),
            onPressed: () {
              print("button pressed");
              _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
            },
          ),*/
         /* ElevatedButton(
            child: Text("Disable PiP"),
            onPressed: () async {
              _betterPlayerController.disablePictureInPicture();
            },
          ),*/
        ],
      ),
    );
  }

  }

