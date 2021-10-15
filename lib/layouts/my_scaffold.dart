import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpg_family_app/notifiers/play_button_notifier.dart';
import 'package:fpg_family_app/notifiers/progress_notifier.dart';
import 'package:fpg_family_app/page_manager.dart';
import 'package:fpg_family_app/services/service_locator.dart';

class MainBody extends StatefulWidget {
  final Widget body;

  MainBody({Key? key, required this.body}) : super(key: key);

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final pageManager = getIt<PageManager>();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.blueGrey),
        child: Column(
          children: [
            Expanded(
              child: widget.body,
            ),
            ValueListenableBuilder<String>(
              valueListenable: pageManager.currentSongTitleNotifier,
              builder: (_, title, __) {
                if (title != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5,left: 10,right: 10),
                    child: Text(
                      "${title}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            //inherit: true,
                            color: Colors.white,
                            fontSize: 16,
                          ),textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            ValueListenableBuilder<ProgressBarState>(
                valueListenable: pageManager.progressNotifier,
                builder: (_, value, __) {
                  if (value != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ProgressBar(
                        progress: value.current,
                        buffered: value.buffered,baseBarColor: Colors.black54,thumbColor: Colors.black,progressBarColor: Colors.black87,
                        total: value.total,
                        onSeek: pageManager.seek,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: pageManager.isFirstSongNotifier,
                  builder: (_, isFirst, __) {
                    return IconButton(
                      icon: Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                      ),
                      onPressed: (isFirst) ? null : pageManager.previous,
                    );
                  },
                ),
                ValueListenableBuilder<ButtonState>(
                  valueListenable: pageManager.playButtonNotifier,
                  builder: (_, value, __) {
                    switch (value) {
                      case ButtonState.loading:
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          width: 32.0,
                          height: 32.0,
                          child: CircularProgressIndicator(color: Colors.black,),
                        );
                      case ButtonState.paused:
                        return IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 32.0,
                          onPressed: pageManager.play,
                        );
                      case ButtonState.playing:
                        return IconButton(
                          icon: Icon(
                            Icons.pause,
                            color: Colors.white,
                          ),
                          iconSize: 32.0,
                          onPressed: pageManager.pause,
                        );
                    }
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: pageManager.isLastSongNotifier,
                  builder: (_, isLast, __) {
                    return IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (!isLast) {
                            await pageManager.next();
                            setState(() {});
                          }
                        });
                  },
                ),
              ],
            )
          ],
        ));
  }
}
