
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';



class LiveStreamingPlayer extends StatefulWidget {
  String videoUrl;
  LiveStreamingPlayer({Key? key, required this.videoUrl}) : super(key: key);
  @override
  _LiveStreamingPlayerState createState() => _LiveStreamingPlayerState();
}

class _LiveStreamingPlayerState extends State<LiveStreamingPlayer> {

  late VideoPlayerController videoPlayerController;
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
    }
  }

