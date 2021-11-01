import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
              'https://images.subsplash.com/base64/L2ltYWdlLmpwZz9pZD1mYzYwZDhhZS1jN2UxLTRhODMtOTVhNi1kMjIzMjBmZDRhZGYmdz0zMDAwJmg9MzAwMCZhbGxvd191cHNjYWxlPXRydWU.jpg';
          var author = items[index].author ?? "";
          var generator = items[index].generator ?? "";
          return InkWell(
            onTap: () {
             // print("image = > $image");
              Global.albumImage = image;
              Global.albumName=items[index].title!;
              print(Global.albumImage);
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyAudioPlayer(index:  index,items:items)));

              /* Navigator.of(context)
                        .push(ChannelDetails.route(items[index]));*/
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                                fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                color: Colors.white
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "$author",
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontWeight: FontWeight.w400,
                                  color: Colors.blue,
                                  fontSize: 10.0
                              ),
                            ),


                          ],
                        ),
                      ),
                      SizedBox(height: 010.0,),
                    ],
                  ),
          SizedBox(height: 10.0),
                  items[index].description!.contains("<")     ? Html(

                    data:"${items[index].description}",

                    style: {
                      'p':Style(color: Colors.white70,fontSize: FontSize.small,maxLines: 2, textOverflow: TextOverflow.ellipsis,padding: EdgeInsets.all(0.0)),


                    },

                  )
                      :Text("${items[index].description}", style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(
                      inherit: true,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      fontSize: 10) ,),

          SizedBox(height: 5.0,),
          Text(
          "${items[index].items?.length.toString()} Episodes",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontWeight: FontWeight.w300,
          fontSize: 12.0,
          color: Colors.deepOrange.shade300
          ),
          ),
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
