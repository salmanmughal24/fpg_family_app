import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpg_family_app/global.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:fpg_family_app/model/theme_model.dart';
import 'package:fpg_family_app/notifiers/play_button_notifier.dart';
import 'package:fpg_family_app/notifiers/progress_notifier.dart';
import 'package:fpg_family_app/page_manager.dart';
import 'package:fpg_family_app/services/service_locator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
        decoration: BoxDecoration(color: Colors.black45),
        child: Stack(
          children: [
            SizedBox.expand(
              child: Column(
                children: [
                  Expanded(child: widget.body),
                  Global.isPlaying == true?Container(height: 160.0, color: themeProvider.isLightTheme?clr_white:clr_black):Container(),
                ],
              ),
            ),
            Global.isPlaying == true? SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: clr_selected_icon,
                              border: Border.all(color: clr_selected_icon,),
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
                                              style: GoogleFonts.openSans(
                                                      //inherit: true,
                                                  color: themeProvider.isLightTheme?clr_white:clr_black,
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
                                              color: Colors.transparent,
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
                                              textStyle: GoogleFonts.openSans(
                                                    //inherit: true,
                                                    color: themeProvider.isLightTheme?clr_white:clr_black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
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
                                          baseBarColor: themeProvider.isLightTheme?clr_white12:clr_black45,
                                          thumbColor:  themeProvider.isLightTheme?clr_white:clr_black,
                                          progressBarColor: themeProvider.isLightTheme?clr_white:clr_black,
                                          total: value.total,
                                          timeLabelTextStyle: TextStyle(color:themeProvider.isLightTheme?clr_white:clr_black,),
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
                                          color: themeProvider.isLightTheme?clr_white:clr_black,
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
                                              color: themeProvider.isLightTheme?clr_white:clr_black,
                                            ),
                                          );
                                        case ButtonState.paused:
                                          return IconButton(
                                            icon: Icon(
                                              Icons.play_arrow,
                                              color: themeProvider.isLightTheme?clr_white:clr_black,
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
                                                color: themeProvider.isLightTheme?clr_white:clr_black,
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
                                            color: themeProvider.isLightTheme?clr_white:clr_black,
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
