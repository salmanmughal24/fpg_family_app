import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fpg_family_app/helper/utils.dart';
import 'package:fpg_family_app/model/channel.dart';
import 'package:fpg_family_app/see_all.dart';
import 'package:fpg_family_app/video_player.dart' as vd;
import 'package:fpg_family_app/video_player.dart';
import 'package:fpg_family_app/yoyo_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'helper/colors.dart';
import 'model/category.dart';
import 'model/product.dart';
import 'model/theme_model.dart';

class WatchSection extends StatefulWidget{
  @override
  State<WatchSection> createState() => _WatchSectionState();
}



class _WatchSectionState extends State<WatchSection> {

  late bool isSwitched = false ;
  void initState() {
    super.initState();

  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoryData() {
    return FirebaseFirestore.instance.collection("categories").orderBy("index").snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getChannelData() {
    return FirebaseFirestore.instance.collection("channels").orderBy("index").snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getProductData(id) {
    return FirebaseFirestore.instance.collection("products").where('category',isEqualTo:id).orderBy("index").snapshots();
  }
  _launchURL() async {
    const url = 'https://tithe.ly/give_new/www/#/tithely/give-one-time/3317107?widget=1&action=Give%20Online%20Now';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  // function to toggle circle animation
  changeThemeMode(bool theme) {
    if (!theme) {
     // _animationController.forward(from: 0.0);
    } else {
     // _animationController.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    isSwitched = !(themeProvider.isLightTheme);
    return Scaffold(
      backgroundColor: themeProvider.isLightTheme
          ? clr_white
          : clr_black,
      appBar: AppBar(
       backgroundColor:  clr_selected_icon,
     /*   backgroundColor: themeProvider.isLightTheme
            ? Colors.white
            : clr_black,*/
        title: Text(
          'FPG Family',
          style: TextStyle(
            color: clr_white,
            /*  color: themeProvider.isLightTheme
              ? Colors.black87
              : Colors.white,*/
              fontSize: 17,
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



        ],
      ),
      body: Container(
        color: themeProvider.isLightTheme
          ? clr_white
          : clr_black,
         child: SingleChildScrollView(
           physics: ScrollPhysics(),
           child: Column(
             children: [
               Padding(
                 padding: const EdgeInsets.only(
                     left: 14.0, top: 30.0, bottom: 20.0, right: 16.0),
                 child: Row(
                   children: [
                     Text(
                       "Live Streaming",
                       style: GoogleFonts.poppins(
                           textStyle: TextStyle(
                               color: themeProvider.isLightTheme
                                   ? clr_black87
                                   : clr_white,
                              // color: ,
                               fontWeight: FontWeight.w700,
                               fontSize: 20)),
                     ),

                   ],
                 ),
               ),
               SizedBox(
                height: MediaQuery.of(context).size.height / 4.0,

                 child: Padding(
                   padding:
                   const EdgeInsets.symmetric(horizontal: 8.0),
                   child: StreamBuilder<
                       QuerySnapshot<Map<String, dynamic>>>(
                     builder: (context, snapshot) {
                       if (snapshot.hasData) {
                         List<
                             QueryDocumentSnapshot<
                                 Map<String, dynamic>>> list =
                             snapshot.data!.docs;
                         List<Channel> channelList = list
                             .map((e) => Channel.fromJson(e.data()))
                             .toList();
                         return ListView.builder(
                             shrinkWrap: true,
                             scrollDirection: Axis.horizontal,
                             itemCount: channelList.length,
                             itemBuilder:
                                 (BuildContext context, int position) {
                               Channel channel =
                               channelList.elementAt(position);


                               return CustomLiveStreamingCard(
                                 title: channel.title,
                                 thumbnail: channel.thumbnail,
                                 videoUrl: channel.url,
                                 themeProvider:themeProvider
                                 // onTap: myfunction,
                               );
                             });
                       } else {
                         return const Center(
                             child: CircularProgressIndicator(
                                 color: clr_selected_icon));
                       }
                     },
                     stream: getChannelData(),

                 ),
               ),
               ),

               Padding(
                    padding: const EdgeInsets.all(0),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
                              snapshot.data!.docs;
                          List<Category> categoryList =
                          list.map((e) => Category.fromJson(e.data())).toList();

                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              Category category = categoryList.elementAt(index);
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14.0, top: 30.0, bottom: 10.0, right: 16.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          category.name,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: themeProvider.isLightTheme?clr_black87:clr_white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20)),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => SeeAll(id: category.id,categoryName:  category.name)),
                                            );
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.navigate_next,
                                                  color: themeProvider.isLightTheme?clr_black45:clr_white54,
                                                  size: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height / 4,

                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<
                                                QueryDocumentSnapshot<
                                                    Map<String, dynamic>>> list =
                                                snapshot.data!.docs;
                                            List<Product> productList = list
                                                .map((e) => Product.fromJson(e.data()))
                                                .toList();
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: productList.length,
                                                itemBuilder:
                                                    (BuildContext context, int position) {
                                                  Product product =
                                                  productList.elementAt(position);


                                                  return CustomCard(
                                                    title: product.title,
                                                    thumbnail: product.thumbnail,
                                                    videoUrl: product.url,
                                                    // onTap: myfunction,
                                                  );
                                                });
                                          } else {
                                            return const Center(
                                                child: CircularProgressIndicator(
                                                    color: clr_selected_icon));
                                          }
                                        },
                                        stream: getProductData(category.id),),

                                    ),
                                  ),
                                ],
                              );
                            },
                            shrinkWrap: true,
                            itemCount: categoryList.length,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(color: Colors.deepOrange));
                        }
                      },
                      stream: getCategoryData(),
                    )
               ),
             ],
           ),
         )
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  String title;
  String? thumbnail;
  String videoUrl;
  Function? onTap;

  CustomCard(
      {required this.title,
        this.thumbnail,
        required this.videoUrl,
        this.onTap});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoPlayerr(videooUrl:widget.videoUrl)));

      },
      child: Container(
        height: _height / 4,
        width: _width / 2,
        margin:  EdgeInsets.only(left: 5, right: 5,),
        decoration: BoxDecoration(
          color: themeProvider.isLightTheme?clr_black12:clr_white12,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
           /* BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 1), // changes position of shadow
            ),*/
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(

                color: themeProvider.isLightTheme?clr_white:clr_black,
                height: _height / 3,
                width: _width / 1.4,
                child: SizedBox.expand(
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ),
                          child: Image.network(
                            widget.thumbnail??"https://img.youtube.com/vi/${widget.videoUrl.split("v=").last}/0.jpg",
                            fit: BoxFit.fill,errorBuilder: ( context,  exception,  stackTrace) {
                            return Image.asset(
                              "assets/images/error.png",
                              fit: BoxFit.fill,
                            );
                          },
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: clr_black45,
                            radius: 20.0,
                            child: Icon(Icons.play_arrow, color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: themeProvider.isLightTheme?clr_black:clr_white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12
                      ),
                    ),

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomLiveStreamingCard extends StatefulWidget {
  String title;
  String thumbnail;
  String videoUrl;
  Function? onTap;
  ThemeProvider themeProvider;

  CustomLiveStreamingCard(
      {required this.title,
        required this.thumbnail,
        required this.videoUrl,
        required this.themeProvider,
        this.onTap});

  @override
  _CustomLiveStreamingCardState createState() => _CustomLiveStreamingCardState();
}

class _CustomLiveStreamingCardState extends State<CustomLiveStreamingCard> {



  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    //initializeVideoPlayer();
  }


  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await Future.wait([
      videoPlayerController.initialize()
    ]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,


      autoPlay: false,
      looping: true,
      isLive: true,
      autoInitialize: false,
      showControls: false,
      cupertinoProgressColors: ChewieProgressColors(playedColor: Colors.deepOrange, bufferedColor: Colors.deepOrangeAccent.withOpacity(0.25)),
      placeholder: Container(
        color: widget.themeProvider.isLightTheme?clr_white70:clr_black87,
        child: Container(
          child: Center(
              child: CircularProgressIndicator(
                valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              )),
        ),
      ),
    );
    setState(() {

    });
  }
  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {

        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if(visiblePercentage < 100){
          videoPlayerController.pause();
        }
        else{
          videoPlayerController.play();
        }
        debugPrint(
            'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
      },
      child: GestureDetector(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> LiveStreamingPlayer(videoUrl:widget.videoUrl)));

        },
        child: Container(
         height:((_width/1.30)* 0.2)+40,
          width: _width/1.30,
          margin: EdgeInsets.only(left: 10,right: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              /* BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),*/
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(

                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Container(

                //  color: Colors.green,
                  height: ((_width/1.30)* 0.5635),
                  width: (_width/1.15),
                  child: chewieController != null ?
                  chewieController!.videoPlayerController.value.isInitialized
                      ? Chewie(
                    controller: chewieController!,
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(color: Colors.deepOrange,),
                      SizedBox(height: 20),
                      Text("Loading",),
                    ],
                  ): Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        child: Image.asset(
                          widget.thumbnail,
                          fit: BoxFit.fill,errorBuilder: ( context,  exception,  stackTrace) {
                          return Image.asset(
                            "assets/images/error.png",
                            fit: BoxFit.fill,
                          );
                        },
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: Colors.black45,
                            radius: 20.0,
                            child: Icon(Icons.play_arrow, color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.only(left: 10, right: 10,top: 10.0,bottom: 0),
                child: Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: themeProvider.isLightTheme?clr_black:clr_white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13
                    ),
                  ),

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}