import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fpg_family_app/audio/audio_player_handler.dart';
import 'package:fpg_family_app/audio_player.dart';
import 'package:fpg_family_app/global.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:fpg_family_app/page_manager.dart';
import 'package:fpg_family_app/repositories/podcast_repository.dart';
import 'package:fpg_family_app/services/service_locator.dart';
import 'package:webfeed/domain/rss_feed.dart';

import 'channel_details.dart';

class ListenSection extends StatefulWidget {


  ListenSection();

  @override
  State<ListenSection> createState() => _ListenSectionState();
}

class _ListenSectionState extends State<ListenSection>
{

  @override
  void initState() {
   // oit();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var items = getIt<PageManager>().feedsItem;
    return Container(
      color: clr_black,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Container(
            height: 0.5,
            color: Colors.white,
          );
        },
        itemBuilder: (context, index) {
          var image = items[index].image?.url ??
              'https://fpgfamily.com/wp-content/uploads/2021/09/cropped-FPG-Family-Circle-black-and-white-1-128x128.png';
          var author = items[index].author ?? "";
          var generator = items[index].generator ?? "";
          return InkWell(
            onTap: () {
              Global.albumImage = items[index].image!.url!;
              Global.albumName=items[index].title!;
              print(Global.albumImage);
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyAudioPlayer(index:  index,items:items)));

              /* Navigator.of(context)
                        .push(ChannelDetails.route(items[index]));*/
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white70,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index].title ?? "",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          "by $author",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white38,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      child: Text(
                        (items[index].items?.length.toString() ?? ""),
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                ],
              ),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}
