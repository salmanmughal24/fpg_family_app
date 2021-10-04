import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../model/FeedsItem.dart';

class FeedsRepository {
  List<FeedsItem> feedsList = [];
  StreamController<List<FeedsItem>> feedStreamController =
      StreamController<List<FeedsItem>>.broadcast();

  Future<List<FeedsItem>> getFeeds(int pageKey) async {
    final queryParameters = {
      'q': '{https}',
      'paged': '$pageKey',
    };

    print("page - $pageKey");

    var url = Uri.https('fpgfamily.com', '/feed/', queryParameters);
    var response = await http.get(url);
    feedStreamController.add([]);
    feedsList.clear();
    print("feed list - ${feedsList.length}");
    if (response.statusCode == 200) {
      var feeds = XmlDocument.parse(response.body);
      var channel = feeds.findAllElements('channel');
      channel.forEach((element) {
        element.findAllElements('item').forEach((item) {
          feedsList.add(FeedsItem.fromElement(item));
          // print("item - ${item.getElement('title')?.text}");
        });
        // print("element - ${element.getElement('title')?.text}");
      });
      // print("${channel?.children}");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    print("feed list - ${feedsList.length}");
    feedStreamController.add(feedsList);
    return feedsList;
  }
}
