import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:webfeed/domain/rss_feed.dart';

class PodcastRepository{
  List<RssFeed> feeds = [];
 // StreamController<List<RssFeed>> feedStreamController = StreamController<List<RssFeed>>.broadcast();



  Future<void> getChannelDetails() async{
    List<RssFeed> feeds = [];
    var url = Uri.https('anchor.fm', '/s/38451784/podcast/rss/');
    var url1 = Uri.https('anchor.fm', '/s/32e5009c/podcast/rss');
    var url2 = Uri.https('feed.podbean.com', '/riverchurchpodcast/feed.xml');
    var url3 = Uri.https('anchor.fm', '/s/35ba5498/podcast/rss');
    var url4 = Uri.https('feed.podbean.com', '/wdbministries/feed.xml');
    var url5 = Uri.https('podcasts.subsplash.com', '/611724e/podcast.rss');

    await _getAndStoreChannelInfor(url);
    await _getAndStoreChannelInfor(url1);
    await _getAndStoreChannelInfor(url2);
    await _getAndStoreChannelInfor(url3);
    await _getAndStoreChannelInfor(url4);
    await _getAndStoreChannelInfor(url5);
  //  feeds.sort((a, b) => a.items!.length.compareTo(b.items!.length));

  }

  Future<void> _getAndStoreChannelInfor(Uri url) async{
    var response = await http.get(url);
    if(response.statusCode == 200){
      // await db.savePodcast(response.body.toString());
      feeds.add(RssFeed.parse(response.body.toString().trim()));
   //   feedStreamController.sink.add(feeds);
    } else {
      print("channel information retrival failed $url");
    }
  }

}