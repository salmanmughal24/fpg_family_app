import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:webfeed/domain/rss_feed.dart';

class PodcastRepository{
  List<RssFeed> feeds = [];
  StreamController<List<RssFeed>> feedStreamController = StreamController<List<RssFeed>>.broadcast();


  PodcastRepository(){

  }

  void getChannelDetails() async{
    var url = Uri.https('anchor.fm', '/s/38451784/podcast/rss/');
    var url1 = Uri.https('anchor.fm', '/s/32e5009c/podcast/rss');
    var url2 = Uri.https('feed.podbean.com', '/riverchurchpodcast/feed.xml');
    var url3 = Uri.https('anchor.fm', '/s/35ba5498/podcast/rss');
    var url4 = Uri.https('feed.podbean.com', '/wdbministries/feed.xml');
    var url5 = Uri.https('podcasts.subsplash.com', '/611724e/podcast.rss');

    _getAndStoreChannelInfor(url);
    _getAndStoreChannelInfor(url1);
    _getAndStoreChannelInfor(url2);
    _getAndStoreChannelInfor(url3);
    _getAndStoreChannelInfor(url4);
    _getAndStoreChannelInfor(url5);

  }

  void _getAndStoreChannelInfor(Uri url) async{
    var response = await http.get(url);
    if(response.statusCode == 200){
      // await db.savePodcast(response.body.toString());
      feeds.add(RssFeed.parse(response.body.toString().trim()));
      feedStreamController.sink.add(feeds);
    } else {
      print("channel information retrival failed $url");
    }
  }

}