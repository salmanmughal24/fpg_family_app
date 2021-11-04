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
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'helper/colors.dart';
import 'model/category.dart';
import 'model/product.dart';

class WatchSection extends StatefulWidget{
  @override
  State<WatchSection> createState() => _WatchSectionState();
}



class _WatchSectionState extends State<WatchSection> {



  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoryData() {
    return FirebaseFirestore.instance.collection("categories").orderBy("index").snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getChannelData() {
    return FirebaseFirestore.instance.collection("channels").snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getProductData(id) {
    return FirebaseFirestore.instance.collection("products").where('category',isEqualTo:id).snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr_black,
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
                       style: GoogleFonts.openSans(
                           textStyle: TextStyle(
                               color: Colors.white70,
                               fontWeight: FontWeight.w700,
                               fontSize: 14)),
                     ),
                     Spacer(),
                     GestureDetector(
                       onTap: () {

                         /* Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SeeAll(id: category.id,categoryName:  category.name)),
                                        );*/
                       },
                       child: Container(
                         child: Row(
                           children: [
                             Icon(
                               Icons.navigate_next,
                               color: Colors.white54,
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
                height: MediaQuery.of(context).size.height / 3.6,

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

                   /*ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, int position) {
                                    return CustomCard(
                                      title: "Song Title",
                                      thumbnail: Images.songImage,
                                      videoUrl: "",
                                      onTap: () {},
                                    );
                                  })*/

                 ),
               ),
               ),

              /* SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Row(
                   children: channelList.map((e) => CustomLiveStreamingCard(
                     title: e.title,
                     thumbnail: e.thumbnail,
                     videoUrl: e.url,
                     // onTap: myfunction,
                   )).toList(),
                 ),
               ),*/
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
                                        left: 14.0, top: 30.0, bottom: 0.0, right: 16.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          category.name,
                                          style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14)),
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
                                                  color: Colors.white54,
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

                                      /*ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, int position) {
                                    return CustomCard(
                                      title: "Song Title",
                                      thumbnail: Images.songImage,
                                      videoUrl: "",
                                      onTap: () {},
                                    );
                                  })*/

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
    return GestureDetector(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoPlayerr(videooUrl:widget.videoUrl)));

      },
      child: Container(
        height: _height / 4,
        width: _width / 2,
        margin:  EdgeInsets.only(left: 5, right: 5,),
        decoration: BoxDecoration(
          color: Colors.white12,
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

                color: Colors.black,
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
                            backgroundColor: Colors.black45,
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
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 11
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

  CustomLiveStreamingCard(
      {required this.title,
        required this.thumbnail,
        required this.videoUrl,
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
    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await Future.wait([
      videoPlayerController.initialize()
    ]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,

      autoPlay: true,
      looping: true,
      isLive: true,
      autoInitialize: true,
      showControls: false,
      cupertinoProgressColors: ChewieProgressColors(playedColor: Colors.deepOrange, bufferedColor: Colors.deepOrangeAccent.withOpacity(0.25)),
      placeholder: Container(
        color: Colors.black87,
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
       //  height:((_width/1.15)* 0.5635)+40,
          width: _width/1.15,
          margin: EdgeInsets.only(left: 10,right: 10),
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
                  height: ((_width/1.15)* 0.5635),
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
                const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
                child: Text(
                  widget.title,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 12
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