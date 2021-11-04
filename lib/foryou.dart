import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:fpg_family_app/global.dart';
import 'package:fpg_family_app/helper/utils.dart';
import 'package:fpg_family_app/layouts/my_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:webfeed/domain/rss_feed.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'helper/colors.dart';
import 'helper/colors.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'page_manager.dart';
import 'services/service_locator.dart';

class ForYouSection extends StatefulWidget {
  const ForYouSection({Key? key}) : super(key: key);

  @override
  _ForYouSectionState createState() => _ForYouSectionState();
}

class _ForYouSectionState extends State<ForYouSection>
    with WidgetsBindingObserver {
//  late RssItem nowPlaying = widget.feedsItem.items!.first;
  int progress = 0;
  late DownloadTaskStatus status;
  late String id;
  ReceivePort _receivePort = ReceivePort();
  late String downloadSongUrl = "";

  @override
  void initState() {
  //  getIt<PageManager>().playPlaylist(0);
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
_deleteFile(String link) async {
  String baseDir = Platform.isAndroid
      ? "/storage/emulated/0/Download/"
      : (await getDownloadsDirectory())!.path;
  final path = Directory("${baseDir}fpg/${link}");
  path.deleteSync(recursive: true);
  await _inFutureList();

  setState(() {
    print("setState");
  });
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
    var mainItems = getIt<PageManager>().feedsItem;
print("Main Items $mainItems");

  //  var items = mainItems.elementAt(0).items ?? [];
    int total=0;
    for(int i = 0 ; i<(mainItems.length ); i++){
    total += mainItems.elementAt(i).items!.length;
    }
    List<RssItem> downloadedItems = [];
    for(int i = 0 ; i < mainItems.length ; i++){
      for(int j = 0; j< mainItems.elementAt(i).items!.length ; j++){
        if (filesList.contains(mainItems.elementAt(i).items!.elementAt(j).enclosure!.url!.split("/").last) ){
          downloadedItems.add(mainItems.elementAt(i).items!.elementAt(j));
        }
      }
    }
    print(total);
    print("downloaded item + ${downloadedItems.length}");
    print("fileList item + ${filesList.length}");
    print(filesList);
    final pageManager = getIt<PageManager>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: clr_black,
        title: Text(
          'FPG Family',
          style: label_appbar(),
        ),
        actions: [
          IconButton(onPressed: () {
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: () {
          }, icon: Icon(Icons.settings)),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              downloadedItems.isEmpty
                  ?  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(child: Text("No item in the list",style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(
                    inherit: true,
                    color: Colors.white,
                    fontSize: 16),)),
                  )
                  : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      //  margin: EdgeInsets.only(top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color:
                        clr_black,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "${DateFormat('MMMM dd').format(downloadedItems[index].pubDate!.toLocal())}",
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 10),
                            ),
                          ),
                          Text(
                            "${downloadedItems[index].title}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                inherit: true,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              pageManager.currentSongTitleNotifier
                                  .value ==
                                  downloadedItems[index].title
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
                                            Icons.play_arrow,
                                            color:
                                            Colors.white,
                                          ),
                                          iconSize: 32.0,
                                          onPressed:(){
                                            pageManager
                                                .play();
                                            Future.delayed(Duration(milliseconds: 3000)).then((value) {

                                              Global.isPlaying=true;
                                              setState(() {});
                                            });
                                          }

                                      );
                                    case ButtonState
                                        .playing:
                                      return IconButton(
                                          icon: Icon(
                                            Icons.pause,
                                            color:
                                            Colors.white,
                                          ),
                                          iconSize: 32.0,
                                          onPressed:(){
                                            Global.isPlaying=false;
                                            pageManager
                                                .pause();
                                            setState(() {

                                            });
                                          }

                                      );
                                  }
                                },
                              )
                                  : IconButton(
                                onPressed: () async {
                                  /*await pageManager
                                              .playWithId(index);*/
                                  print("sekectedd uri ${downloadedItems.elementAt(index).enclosure!.url}");
                                  await pageManager
                                      .playWithUri(downloadedItems.elementAt(index).enclosure!.url);
                                  Global.isPlaying=true;
                                  Future.delayed(Duration(milliseconds: 3000)).then((value) {

                                    setState(() {});
                                  });
                                },
                                icon: Icon(
                                  Icons.play_arrow,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),

                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  print("delete ${downloadedItems.elementAt(index).enclosure!.url!.split("/").last}");
                                  await _deleteFile(downloadedItems.elementAt(index).enclosure!.url!.split("/").last);

                                  print("done");
                                  setState(() {

                                  });
                                },
                              )

                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 2.0,
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      color: Colors.black,
                    );
                  },
                  itemCount: downloadedItems.length /*mainItems
                              .elementAt(3)
                              .items!
                              .length*/),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                color: Colors.white,
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
                    Text('${playlistTitles[index]}'),
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

