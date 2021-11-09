import 'dart:io';
import 'dart:isolate';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:fpg_family_app/global.dart';
import 'package:fpg_family_app/layouts/my_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:webfeed/domain/rss_feed.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'helper/colors.dart';
import 'model/theme_model.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'page_manager.dart';
import 'services/service_locator.dart';

class MyAudioPlayer extends StatefulWidget {
  int index;
  List<RssFeed> items;

  MyAudioPlayer({Key? key, required this.index, required this.items})
      : super(key: key);

  @override
  _MyAudioPlayerState createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer>
    with WidgetsBindingObserver {
//  late RssItem nowPlaying = widget.feedsItem.items!.first;
  int progress = 0;
  late DownloadTaskStatus status;
  late String id;
  ReceivePort _receivePort = ReceivePort();
  late String downloadSongUrl = "";

  @override
  void initState() {
    getIt<PageManager>().playPlaylist(widget.index);
    super.initState();
    receiverPortData();
    _createFolder();
    print("init call");
    _inFutureList();
    //   print(" iam here  ${widget.feedsItem.title}");
  }

  receiverPortData() async {
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");
    _receivePort.listen((dynamic data) {
      DownloadTaskStatus status = data[1];
      print("progress + ${data[2]}");
      setState(() {
        progress = data[2];
      });
      if (status == DownloadTaskStatus.complete) {
        filesList.add(downloadSongUrl);
        downloadSongUrl = "";
        print("new song added successfulyy + progress ${data[2]}");
        setState(() {});
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  List<String> filesList = <String>[];

  Future<void> _inFutureList() async {
    String baseDir = Platform.isAndroid
        ? "/storage/emulated/0/Download/"
        : (await getDownloadsDirectory())!.path;
    final path = Directory("${baseDir}fpg/");
    filesList = (await path.list().toList())
        .map((e) => e.path.split('/').last)
        .toList();
    setState(() {});
    // await new Future.delayed(new Duration(milliseconds: 500));
    print("filesList $filesList");
  }

  _createFolder() async {
    String baseDir = Platform.isAndroid
        ? "/storage/emulated/0/Download/"
        : (await getDownloadsDirectory())!.path;
    final path = Directory("${baseDir}fpg/");
    if ((await path.exists())) {
      // TODO:
      print("exist");
    } else {
      // TODO:
      print("not exist");
      path.create();
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName("downloading");
    //   print("progress + $progress");
    sendPort!.send([id, status, progress]);
  }

  @override
  void dispose() {
//    getIt<PageManager>().dispose();
    IsolateNameServer.removePortNameMapping('downloading');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("progressbuild + $progress");

    var items = widget.items.elementAt(widget.index).items ?? [];
    final pageManager = getIt<PageManager>();
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(

      home: Scaffold(
        backgroundColor: themeProvider.isLightTheme
            ? clr_white
            : clr_black,
        body: SafeArea(
          child: MainBody(
              body: Column(
            children: [
              Container(
                color: themeProvider.isLightTheme?clr_white:clr_black,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 16.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                widget.items.elementAt(widget.index).image?.url??'https://images.subsplash.com/base64/L2ltYWdlLmpwZz9pZD1mYzYwZDhhZS1jN2UxLTRhODMtOTVhNi1kMjIzMjBmZDRhZGYmdz0zMDAwJmg9MzAwMCZhbGxvd191cHNjYWxlPXRydWU.jpg',
                                height: 120,
                                width: 120,
                                fit: BoxFit.fill,
                              )),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                //color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "${widget.items.elementAt(widget.index).title}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        //inherit: true,
                                        color: themeProvider.isLightTheme?clr_black:clr_white,
                                        fontSize: 18,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 20, left: 10, right: 10),
                                //color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "${widget.items.elementAt(widget.index).author??""}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        //inherit: true,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      //color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "${widget.items.elementAt(widget.index).description}",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              //inherit: true,
                              color: themeProvider.isLightTheme?clr_black:clr_white,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      //color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "${widget.items.elementAt(widget.index).items!.length} Episodes",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          //inherit: true,
                          color: Colors.deepOrange.shade300,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    /*Container(
                      height: 0.25,
                      margin: EdgeInsets.symmetric(vertical: 1),
                      color: Colors.white30,
                    ),*/
                    SizedBox(height: 10.0,),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    color: themeProvider.isLightTheme?clr_white:clr_black,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        items.isEmpty
                            ? Container()
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    //  margin: EdgeInsets.only(top: 4, bottom: 4),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    color: /*nowPlaying == items.elementAt(index)
                                            ? Colors.blueGrey.withOpacity(0.3)
                                            : */
                                        themeProvider.isLightTheme?clr_white:clr_black,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Text(
                                            "${DateFormat('MMMM dd').format(items[index].pubDate!.toLocal())}",
                                            style: GoogleFonts.openSans(
                                                color: themeProvider.isLightTheme?clr_black:clr_white,
                                                fontSize: 10),
                                          ),
                                        ),
                                        Text(
                                          items[index].title!,
                                          style: GoogleFonts.openSans(

                                              color: themeProvider.isLightTheme?clr_black:clr_white,
                                                  fontSize: 16),
                                        ),
                                        items[index].description!.contains("<")     ? Html(

                                        data:"${items[index].description}",

                                         style: {
                                          'p':Style(
                                              fontFamily: 'opensans',
                                        color: themeProvider.isLightTheme?clr_black:clr_white,fontSize: FontSize.small,maxLines: 2, textOverflow: TextOverflow.ellipsis,padding: EdgeInsets.all(0.0)),


                                         },

                                        )
                                        :Text(items[index].description==''?"No description":items[index].description!, style: GoogleFonts.openSans(
                                             // inherit: true,
                                            color: themeProvider.isLightTheme?clr_black:clr_white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10) ,),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            pageManager.currentSongTitleNotifier
                                                        .value ==
                                                    items[index].title
                                                ? ValueListenableBuilder<
                                                    ButtonState>(
                                                    valueListenable: pageManager
                                                        .playButtonNotifier,
                                                    builder: (_, value, __) {
                                                      switch (value) {
                                                        case ButtonState
                                                            .loading:
                                                          return Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            width: 32.0,
                                                            height: 32.0,
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        case ButtonState.paused:
                                                          return IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .play_arrow,
                                                                color: themeProvider.isLightTheme?clr_black:clr_white,
                                                              ),
                                                              iconSize: 32.0,
                                                              onPressed: () {
                                                                Global.isPlaying =
                                                                    true;
                                                                pageManager
                                                                    .play;
                                                                setState(() {});
                                                              });
                                                        case ButtonState
                                                            .playing:
                                                          return IconButton(
                                                              icon: Icon(
                                                                Icons.pause,
                                                                color: themeProvider.isLightTheme?clr_black:clr_white,
                                                              ),
                                                              iconSize: 32.0,
                                                              onPressed: () {
                                                                Global.isPlaying =
                                                                    false;
                                                                pageManager
                                                                    .pause;
                                                                setState(() {});
                                                              });
                                                      }
                                                    },
                                                  )
                                                : IconButton(
                                                    onPressed: () async {
                                                      Global.isPlaying = true;
                                                      await pageManager
                                                          .playWithId(index);
                                                      setState(() {});
                                                    },
                                                    icon: Icon(
                                                      Icons.play_arrow,
                                                      size: 32,
                                                      color: themeProvider.isLightTheme?clr_black:clr_white,
                                                    ),
                                                  ),
                                            filesList.contains(items
                                                    .elementAt(index)
                                                    .enclosure!
                                                    .url!
                                                    .split('/')
                                                    .last)
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.check_circle,
                                                      size: 28,
                                                      color: themeProvider.isLightTheme?clr_black:clr_white,
                                                    ),
                                                    onPressed: () {},
                                                  )
                                                : (items
                                                            .elementAt(index)
                                                            .enclosure!
                                                            .url!
                                                            .split('/')
                                                            .last) ==
                                                        downloadSongUrl
                                                    ? Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    12.0),
                                                        height: 25.0,
                                                        width: 25.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                          backgroundColor:
                                                           themeProvider.isLightTheme?clr_black:clr_white,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Color(
                                                                      0xfffd7013)),
                                                          value: progress / 100,
                                                        ))
                                                    : IconButton(
                                                        onPressed: () async {
                                                          final status =
                                                              await Permission
                                                                  .storage
                                                                  .request();
                                                          if (status
                                                              .isGranted) {
                                                            print(
                                                                "Yahoooooooooooooooooooooooooooooooooo.. Permission granted");
                                                            var baseStorage = Platform
                                                                    .isAndroid
                                                                ? "/storage/emulated/0/Download/fpg/"
                                                                : (await getDownloadsDirectory())!
                                                                    .path;
                                                            print(
                                                                "Yahoooooooooooooooooooooooooooooooooo.. Jaaaan dooosss");
                                                            try {
                                                              print(
                                                                  "baseStorage + $baseStorage");
                                                              var id =
                                                                  await FlutterDownloader
                                                                      .enqueue(
                                                                url: items
                                                                    .elementAt(
                                                                        index)
                                                                    .enclosure!
                                                                    .url!,
                                                                headers: {
                                                                  'User-Agent':
                                                                      "Fgp Family App"
                                                                },
                                                                savedDir:
                                                                    baseStorage,
                                                                fileName: items
                                                                    .elementAt(
                                                                        index)
                                                                    .enclosure!
                                                                    .url!
                                                                    .split('/')
                                                                    .last /*items
                                                          .elementAt(index)
                                                          .title*/
                                                                ,
                                                                showNotification:
                                                                    true,
                                                                // show download progress in status bar (for Android)
                                                                openFileFromNotification:
                                                                    false, // click on notification to open downloaded file (for Android)
                                                              );
                                                              print(
                                                                  "this file is downloading ${items.elementAt(index).enclosure!.url!.split('/').last}");
                                                              downloadSongUrl =
                                                                  items
                                                                      .elementAt(
                                                                          index)
                                                                      .enclosure!
                                                                      .url!
                                                                      .split(
                                                                          '/')
                                                                      .last;
                                                            } catch (e) {
                                                              print(e);
                                                            }
                                                          } else {
                                                            print(
                                                                "No Permission");
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.download,
                                                          size: 32,
                                                          color: themeProvider.isLightTheme?clr_black:clr_white,
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
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    height: 0.5,
                                    margin: EdgeInsets.symmetric(vertical: 1),
                                    color: themeProvider.isLightTheme?clr_black12:clr_white12,
                                  );
                                },
                                itemCount: widget.items
                                    .elementAt(widget.index)
                                    .items!
                                    .length),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentSongTitleNotifier,
      builder: (_, title, __) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: Text(
              "Now Playing: ${title}",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    //inherit: true,
                color: themeProvider.isLightTheme?clr_black:clr_white,
                    fontSize: 16,
                  ),
            ),
          ),
        );
      },
    );
  }
}

class Playlist extends StatelessWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: pageManager.playlistNotifier,
        builder: (context, playlistTitles, _) {
          return ListView.builder(
            itemCount: playlistTitles.length,
            itemBuilder: (context, index) {
              return InkWell(
                borderRadius: BorderRadius.circular(25),
                child: Column(
                  children: [
                    //   Container(child: Image.network(),),
                    Text('${playlistTitles[index]}' ,style: GoogleFonts.openSans()),
                  ],
                ),
                // ...
              );
            },
          );
        },
      ),
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
        );
      },
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ValueListenableBuilder<RepeatState>(
            valueListenable: pageManager.repeatButtonNotifier,
            builder: (context, value, child) {
              Icon icon;
              switch (value) {
                case RepeatState.off:
                  icon = Icon(Icons.repeat, color: Colors.grey);
                  break;
                case RepeatState.repeatSong:
                  icon = Icon(Icons.repeat_one);
                  break;
                case RepeatState.repeatPlaylist:
                  icon = Icon(Icons.repeat);
                  break;
              }
              return IconButton(
                icon: icon,
                onPressed: pageManager.repeat,
              );
            },
          ),
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
                    child: CircularProgressIndicator(),
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
                    }
                  });
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: pageManager.isShuffleModeEnabledNotifier,
            builder: (context, isEnabled, child) {
              return IconButton(
                icon: (isEnabled)
                    ? Icon(Icons.shuffle)
                    : Icon(Icons.shuffle, color: Colors.grey),
                onPressed: pageManager.shuffle,
              );
            },
          ),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
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
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: CircularProgressIndicator(),
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
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
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
              }
            });
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? Icon(Icons.shuffle)
              : Icon(Icons.shuffle, color: Colors.grey),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}
