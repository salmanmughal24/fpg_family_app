/*import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'AudioPlayerTask.dart';

class BGAudioPlayerScreen extends StatefulWidget {
  @override
  _BGAudioPlayerScreenState createState() => _BGAudioPlayerScreenState();
}

class _BGAudioPlayerScreenState extends State<BGAudioPlayerScreen> {
  final BehaviorSubject<double> _dragPositionSubject =
  BehaviorSubject.seeded(null);

  final _queue = <MediaItem>[
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      album: "Science Friday",
      title: "A Salute To Head-Scratching Science",
      artist: "Science Friday and WNYC Studios",
      duration: Duration(milliseconds: 5739820),
      artUri:
      "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
      album: "Science Friday",
      title: "From Cat Rheology To Operatic Incompetence",
      artist: "Science Friday and WNYC Studios",
      duration: Duration(milliseconds: 2856950),
      artUri:
      "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
  ];

  bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.white,
        child: StreamBuilder<AudioState>(
          stream: _audioStateStream,
          builder: (context, snapshot) {
            final audioState = snapshot.data;
            final queue = audioState?.queue;
            final mediaItem = audioState?.mediaItem;
            final playbackState = audioState?.playbackState;
            final processingState =
                playbackState?.processingState ?? AudioProcessingState.none;
            final playing = playbackState?.playing ?? false;
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (processingState == AudioProcessingState.none) ...[
                    _startAudioPlayerBtn(),
                  ] else ...[
                    //positionIndicator(mediaItem, playbackState),
                    SizedBox(height: 20),
                    if (mediaItem?.title != null) Text(mediaItem.title),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !playing
                            ? IconButton(
                          icon: Icon(Icons.play_arrow),
                          iconSize: 64.0,
                          onPressed: AudioService.play,
                        )
                            : IconButton(
                          icon: Icon(Icons.pause),
                          iconSize: 64.0,
                          onPressed: AudioService.pause,
                        ),
                        // IconButton(
                        //   icon: Icon(Icons.stop),
                        //   iconSize: 64.0,
                        //   onPressed: AudioService.stop,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.skip_previous),
                              iconSize: 64,
                              onPressed: () {
                                if (mediaItem == queue.first) {
                                  return;
                                }
                                AudioService.skipToPrevious();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next),
                              iconSize: 64,
                              onPressed: () {
                                if (mediaItem == queue.last) {
                                  return;
                                }
                                AudioService.skipToNext();
                              },
                            )
                          ],
                        ),
                      ],
                    )
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _startAudioPlayerBtn() {
    List<dynamic> list = List();
    for (int i = 0; i < 2; i++) {
      var m = _queue[i].toJson();
      list.add(m);
    }
    var params = {"data": list};
    return MaterialButton(
      child: Text(_loading ? "Loading..." : 'Start Audio Player'),
      onPressed: () async {
        setState(() {
          _loading = true;
        });
        await AudioService.start(
          backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
          androidNotificationChannelName: 'Audio Player',
          androidNotificationColor: 0xFF2196f3,
          androidNotificationIcon: 'mipmap/ic_launcher',
          params: params,
        );
        setState(() {
          _loading = false;
        });
      },
    );
  }

  Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
    double seekPos;
    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          _dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
              (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position =
            snapshot.data ?? state.currentPosition.inMilliseconds.toDouble();
        double duration = mediaItem?.duration?.inMilliseconds?.toDouble();
        return Column(
          children: [
            if (duration != null)
              Slider(
                min: 0.0,
                max: duration,
                value: seekPos ?? max(0.0, min(position, duration)),
                onChanged: (value) {
                  _dragPositionSubject.add(value);
                },
                onChangeEnd: (value) {
                  AudioService.seekTo(Duration(milliseconds: value.toInt()));
                  // Due to a delay in platform channel communication, there is
                  // a brief moment after releasing the Slider thumb before the
                  // new position is broadcast from the platform side. This
                  // hack is to hold onto seekPos until the next state update
                  // comes through.
                  // TODO: Improve this code.
                  seekPos = value;
                  _dragPositionSubject.add(null);
                },
              ),
            Text("${state.currentPosition}"),
          ],
        );
      },
    );
  }
}

Stream<AudioState> get _audioStateStream {
  return Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState,
      AudioState>(
    AudioService.queueStream,
    AudioService.currentMediaItemStream,
    AudioService.playbackStateStream,
        (queue, mediaItem, playbackState) => AudioState(
      queue,
      mediaItem,
      playbackState,
    ),
  );
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}*/
