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
      color: Colors.black,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Container(
            height: 0.8,
            color:clr_black ,
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
                      height: 75,
                      width: 75,
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
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 17.0
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "by $author",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w300,
                              fontSize: 11.0
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Text(
                          "${items[index].items?.length.toString()} Episodes",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 11.0,
                            color: Colors.deepOrange.shade300
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 010.0,),
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
