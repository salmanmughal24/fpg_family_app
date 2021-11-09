import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fpg_family_app/audio/audio_player_handler.dart';
import 'package:fpg_family_app/audio_player.dart';
import 'package:fpg_family_app/global.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:fpg_family_app/helper/utils.dart';
import 'package:fpg_family_app/model/theme_model.dart';
import 'package:fpg_family_app/page_manager.dart';
import 'package:fpg_family_app/repositories/podcast_repository.dart';
import 'package:fpg_family_app/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/domain/rss_feed.dart';

import 'channel_details.dart';

class ListenSection extends StatefulWidget {


  ListenSection();

  @override
  State<ListenSection> createState() => _ListenSectionState();
}

class _ListenSectionState extends State<ListenSection>
{
  late bool isSwitched = false ;
  @override
  void initState() {
   // oit();


    super.initState();
  }
  changeThemeMode(bool theme) {
    if (!theme) {
      // _animationController.forward(from: 0.0);
    } else {
      // _animationController.reverse(from: 1.0);
    }
  }
  _launchURL() async {
    const url = 'https://fpgchurch.com/give';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    var items = getIt<PageManager>().feedsItem;
    final themeProvider = Provider.of<ThemeProvider>(context);
    isSwitched = !(themeProvider.isLightTheme);
    return Scaffold(
      backgroundColor: themeProvider.isLightTheme
          ? Colors.white
          : clr_black,
      appBar: AppBar(
        backgroundColor:  clr_selected_icon,
        /*   backgroundColor: themeProvider.isLightTheme
            ? Colors.white
            : clr_black,*/
        title: Text(
          'FPG Family',
          style: TextStyle(
              color: Colors.white,
              /*  color: themeProvider.isLightTheme
              ? Colors.black87
              : Colors.white,*/
              fontSize: 16,
              fontWeight: FontWeight.w700
          ),
        ),
        actions: [
          GestureDetector(

            onTap: ()  {
              _launchURL();
            },
            child: Center(child: Container(margin: EdgeInsets.symmetric(horizontal: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    border: Border.all(color: Colors.green,)
                ),
                child: Text("GIVE" ,style: TextStyle(color: Colors.white),))),
          ),

          Container(
            height: 20.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
            child:


            Switch(
              value: isSwitched,


              onChanged: (value) {
                setState(() async {

                  await themeProvider.toggleThemeData();
                  isSwitched = value;
                  changeThemeMode(themeProvider.isLightTheme);

                });
              },
              activeTrackColor: Colors.white30,
              activeColor: Colors.black26,
            ),

            /*ToggleSwitch(
              minWidth: 60.0,
              minHeight: 10.0,
              cornerRadius: 10.0,
              activeBgColors: [[Colors.green!], [Colors.black45!]],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              initialLabelIndex: 1,
              totalSwitches: 2,
              labels: ['light', 'dark'],
              radiusStyle: true,
              onToggle: (index) async {
                // await themeProvider.toggleThemeData();
                  if (index == 0){
                    changeThemeMode(themeProvider.isLightTheme);
                  }
                  else if (index == 1){

                  }



                print('switched to: $index');
              },
            ),*/
          ),

        ],
      ),
      body:Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        color: themeProvider.isLightTheme
            ? Colors.white
            : Colors.black,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Container(
              height: 0.0,
              color:Colors.black ,
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
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: themeProvider.isLightTheme
                ? clr_black12
                    : clr_black,
                ),
                child:
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 16.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                               items.elementAt(index).image?.url??'https://images.subsplash.com/base64/L2ltYWdlLmpwZz9pZD1mYzYwZDhhZS1jN2UxLTRhODMtOTVhNi1kMjIzMjBmZDRhZGYmdz0zMDAwJmg9MzAwMCZhbGxvd191cHNjYWxlPXRydWU.jpg',
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
                                  "${items.elementAt(index).title}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                    //inherit: true,
                                    color: themeProvider.isLightTheme
                                        ? clr_black87
                                        : clr_white,
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
                                  "${items.elementAt(index).author??""}",
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
                        "${items.elementAt(index).description}",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          //inherit: true,
                           color: themeProvider.isLightTheme
                            ? clr_black87
                            : clr_white,
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
                        "${items.elementAt(index).items!.length} Episodes",
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
                    SizedBox(height: 5.0,),
                  ],
                ),

              ),
            );
          },
          itemCount: items.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}
