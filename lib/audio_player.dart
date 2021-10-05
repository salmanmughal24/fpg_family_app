import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fpg_family_app/model/FeedsItem.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'package:fpg_family_app/main.dart';

import 'audio/audio_player_handler.dart';
import 'helper/colors.dart';

class MyAudioPlayer extends StatefulWidget {
  RssFeed feedsItem;
  AudioHandler handler;

  MyAudioPlayer({Key? key, required this.feedsItem, required this.handler})
      : super(key: key);

  @override
  _MyAudioPlayerState createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer>
    with WidgetsBindingObserver {
  AudioPlayer _player = AudioPlayer();

  late RssItem nowPlaying = widget.feedsItem.items!.first;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init(widget.feedsItem.items!.first);
  }

  Future<void> _init(RssItem item) async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.

    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      await _player
          .setAudioSource(AudioSource.uri(Uri.parse(item.enclosure!.url!)));
      nowPlaying = item;
      _player.play();
      setState(() {});
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    var image = widget.feedsItem.image?.url ??
        "https://fpgfamily.com/wp-content/uploads/2021/09/cropped-FPG-Family-Circle-black-and-white-1-256x256.png";
    var author = widget.feedsItem.author ?? "Anonymous";
    var items = widget.feedsItem.items ?? [];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: /* Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display play/pause button and volume/speed sliders.
             // Image.network(src),
              ControlButtons(_player),
              // Display seek bar. Using StreamBuilder, this widget rebuilds
              // each time the position, buffered position or duration changes.
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: _player.seek,
                  );
                },
              ),

            ],
          ),*/
              SizedBox.expand(
            child: Container(
              color: clr_black,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    VerticalDivider(
                      width: 16,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        image,
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                    ),
                    VerticalDivider(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.feedsItem.title ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "by $author",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Episods - ${widget.feedsItem.items?.length.toString()}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(child: ControlButtons(_player)),
                    // Display seek bar. Using StreamBuilder, this widget rebuilds
                    // each time the position, buffered position or duration changes.
                    StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return SeekBar(
                          duration: positionData?.duration ?? Duration.zero,
                          position: positionData?.position ?? Duration.zero,
                          bufferedPosition:
                              positionData?.bufferedPosition ?? Duration.zero,
                          onChangeEnd: _player.seek,
                        );
                      },
                    ),

                    Text(
                      "Now Playing: ${nowPlaying.title}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            //inherit: true,
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                    ),
                    Divider(
                      height: 20,
                    ),
                    items.isEmpty
                        ? Container()
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              print(items.first.enclosure!.url);
                              return Container(
                                //  margin: EdgeInsets.only(top: 4, bottom: 4),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                color: nowPlaying == items.elementAt(index)
                                    ? Colors.blueGrey.withOpacity(0.3)
                                    : Colors.black54,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${items[index].title}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              inherit: true,
                                              color: Colors.white,
                                              fontSize: 16),
                                    ),
                                    Text(
                                      "${items[index].pubDate?.toLocal()}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              inherit: true,
                                              color: Colors.white,
                                              fontSize: 10),
                                    ),
                                    Divider(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        items.elementAt(index) == nowPlaying
                                            ? StreamBuilder<PlayerState>(
                                                stream:
                                                    _player.playerStateStream,
                                                builder: (context, snapshot) {
                                                  final playerState =
                                                      snapshot.data;
                                                  final processingState =
                                                      playerState
                                                          ?.processingState;
                                                  final playing =
                                                      playerState?.playing;
                                                  if (processingState ==
                                                          ProcessingState
                                                              .loading ||
                                                      processingState ==
                                                          ProcessingState
                                                              .buffering) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.all(8.0),
                                                      width: 32.0,
                                                      height: 32.0,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (playing != true) {
                                                    return IconButton(
                                                      icon: Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.white),
                                                      iconSize: 32.0,
                                                      onPressed: _player.play,
                                                    );
                                                  } else if (processingState !=
                                                      ProcessingState
                                                          .completed) {
                                                    return IconButton(
                                                      icon: Icon(Icons.pause,
                                                          color: Colors.white),
                                                      iconSize: 32.0,
                                                      onPressed: _player.pause,
                                                    );
                                                  } else {
                                                    return IconButton(
                                                      icon: Icon(Icons.replay,
                                                          color: Colors.white),
                                                      iconSize: 32.0,
                                                      onPressed: () => _player
                                                          .seek(Duration.zero),
                                                    );
                                                  }
                                                },
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  //   playNow(items.elementAt(index));

                                                 /* widget.handler
                                                      .removeQueueItemAt(0);
                                                  widget.handler
                                                      .addQueueItem(MediaItem(
                                                    id: items
                                                        .elementAt(index)
                                                        .enclosure!
                                                        .url!,
                                                    album: "Science Friday",
                                                    title:
                                                        "A Salute To Hes.fsdfsng Science",
                                                    artist:
                                                        "Science Friday and WNYC Studios",
                                                    duration: const Duration(
                                                        milliseconds: 5739820),
                                                    artUri: Uri.parse(
                                                        'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
                                                  ));*/
                                                  widget.handler.play();

                                                  //        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyAudioPlayer(feed:items.elementAt(index),feedsItem:  widget.feedsItem),));
                                                },
                                                icon: Icon(
                                                  Icons.play_arrow,
                                                  size: 32,
                                                  color: Colors.white,
                                                ),
                                              ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.add_road_sharp,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await FlutterDownloader
                                                .initialize();
                                            final taskId =
                                                await FlutterDownloader.enqueue(
                                              url: items
                                                  .elementAt(index)
                                                  .enclosure!
                                                  .url!,
                                              headers: {
                                                'User-Agent': "Fgp Family App"
                                              },
                                              savedDir: Platform.isAndroid
                                                  ? "/storage/emulated/0/Download/"
                                                  : (await getDownloadsDirectory())!
                                                      .path,
                                              showNotification: true,
                                              // show download progress in status bar (for Android)
                                              openFileFromNotification:
                                                  true, // click on notification to open downloaded file (for Android)
                                            );
                                          },
                                          icon: Icon(
                                            Icons.download,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Container(
                                height: 0.5,
                                margin: EdgeInsets.symmetric(vertical: 2),
                                color: Colors.white30,
                              );
                            },
                            itemCount: widget.feedsItem.items!.length),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> playNow(RssItem item) async {
    nowPlaying = item;
    setState(() {});
    try {
      await _player
          .setAudioSource(AudioSource.uri(Uri.parse(item.enclosure!.url!)));
      _player.play();
      setState(() {});
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: Icon(
            Icons.volume_up,
            color: Colors.white,
          ),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.white),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause, color: Colors.white),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay, color: Colors.white),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Colors.blue.shade100,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 50.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
