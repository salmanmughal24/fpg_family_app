import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpg_family_app/audio_player.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:fpg_family_app/helper/utils.dart';
import 'package:webfeed/domain/rss_feed.dart';

class ChannelDetails extends StatefulWidget {
  RssFeed feedsItem;

  ChannelDetails(this.feedsItem);

  static Route route(RssFeed feedsItem) {
    return MaterialPageRoute(builder: (context) => ChannelDetails(feedsItem));
  }

  @override
  State<ChannelDetails> createState() => _ChannelDetailsState();
}

class _ChannelDetailsState extends State<ChannelDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var image = widget.feedsItem.image?.url ??
        "https://fpgfamily.com/wp-content/uploads/2021/09/cropped-FPG-Family-Circle-black-and-white-1-256x256.png";
    var author = widget.feedsItem.author ?? "";
    var items = widget.feedsItem.items ?? [];
   // widget.feedsItem.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clr_black,
        title: Text(
          "",
          style: label_appbar(),
        ),
      ),
      body: Container(
        color: clr_black,
        child: Column(
          children: [
            Row(
              children: [
                VerticalDivider(
                  width: 16,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    image,
                    height: 100,
                    width: 100,
                  ),
                ),
                VerticalDivider(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.feedsItem.title ?? "",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        "by $author",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Divider(
                        height: 20,
                      ),
                      Text(
                        "Episods - ${widget.feedsItem.items?.length.toString()}",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  width: 16,
                ),
              ],
            ),
            Divider(
              height: 16,
            ),
            items.isEmpty
                ? Container()
                : Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          print(items.first.enclosure!.url);
                          return Container(
                            margin: EdgeInsets.only(top: 4, bottom: 4),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${items[index].title}",
                                  style: Theme.of(context).textTheme.subtitle1,
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
                                    IconButton(
                                      onPressed: () {

                                      //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyAudioPlayer(feed:items.elementAt(index),feedsItem:  widget.feedsItem)));
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
                                      onPressed: () {},
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
                  ),
          ],
        ),
      ),
    );
  }

  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
        icon: Icon(iconData),
        iconSize: 64.0,
        onPressed: onPressed,
      );
}
