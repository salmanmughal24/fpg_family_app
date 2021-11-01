import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpg_family_app/global.dart';
import 'package:fpg_family_app/notifiers/play_button_notifier.dart';
import 'package:fpg_family_app/notifiers/progress_notifier.dart';
import 'package:fpg_family_app/page_manager.dart';
import 'package:fpg_family_app/services/service_locator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MainBody extends StatefulWidget {
  final Widget body;

  MainBody({Key? key, required this.body}) : super(key: key);

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final pageManager = getIt<PageManager>();

  bool showPlayer = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.black45),
        child: Stack(
          children: [
            SizedBox.expand(
              child: widget.body,
            ),
            Global.isPlaying == true? SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              border: Border.all(color: Colors.deepOrange),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              )),
                          child: Column(
                            children: [
                              showPlayer == false
                                  ? GestureDetector(
                                      onTap: () {
                                        showPlayer = true;
                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.expand_less,
                                              color: Colors.black38,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Container(
                                              //   color:Colors.red.withOpacity(0.85),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    showPlayer = false;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: Colors.black38,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0,
                                                bottom: 20,
                                                left: 10,
                                                right: 10),
                                            child: Text(
                                              Global.albumName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      //inherit: true,
                                                      color: Colors.black87,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.2,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      Global.albumImage)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                              ValueListenableBuilder<String>(
                                valueListenable:
                                    pageManager.currentSongTitleNotifier,
                                builder: (_, title, __) {
                                  if (title != null) {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 5,
                                            left: 10,
                                            right: 10),
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              '${title}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    //inherit: true,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                              textAlign: TextAlign.center,
                                              speed: const Duration(
                                                  milliseconds: 200),
                                            ),
                                          ],

                                          totalRepeatCount: 5,
                                          //  pause: const Duration(milliseconds: 20),
                                          displayFullTextOnTap: true,
                                          stopPauseOnTap: true,
                                        ));
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ValueListenableBuilder<ProgressBarState>(
                                  valueListenable: pageManager.progressNotifier,
                                  builder: (_, value, __) {
                                    if (value != null) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: ProgressBar(
                                          progress: value.current,
                                          buffered: value.buffered,
                                          baseBarColor: Colors.black54,
                                          thumbColor: Colors.black,
                                          progressBarColor: Colors.black87,
                                          total: value.total,
                                          onSeek: pageManager.seek,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        pageManager.isFirstSongNotifier,
                                    builder: (_, isFirst, __) {
                                      return IconButton(
                                        icon: Icon(
                                          Icons.skip_previous,
                                          color: Colors.white,
                                        ),
                                        onPressed: (isFirst)
                                            ? null
                                            : pageManager.previous,
                                      );
                                    },
                                  ),
                                  ValueListenableBuilder<ButtonState>(
                                    valueListenable:
                                        pageManager.playButtonNotifier,
                                    builder: (_, value, __) {
                                      switch (value) {
                                        case ButtonState.loading:
                                          return Container(
                                            margin: EdgeInsets.all(8.0),
                                            width: 32.0,
                                            height: 32.0,
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ),
                                          );
                                        case ButtonState.paused:
                                          return IconButton(
                                            icon: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            ),
                                            iconSize: 32.0,
                                            onPressed: () {
                                              Global.isPlaying = true;
                                              pageManager.play();
                                              setState(() {});
                                            },
                                          );
                                        case ButtonState.playing:
                                          return IconButton(
                                              icon: Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                              ),
                                              iconSize: 32.0,
                                              onPressed: () {
                                                Global.isPlaying = false;
                                                pageManager.pause();
                                                setState(() {});
                                              });
                                      }
                                    },
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        pageManager.isLastSongNotifier,
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
                          ),
                        ),
                      ],
                    ),
                  ):Container(),

          ],
        ));
  }
}
