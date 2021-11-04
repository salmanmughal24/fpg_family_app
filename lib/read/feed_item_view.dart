
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';
import 'feed_item_details_view.dart';
import '../model/FeedsItem.dart';

class FeedItemView extends StatelessWidget {
  FeedsItem feedsItem;
  String imageUrl = "";

  FeedItemView(this.feedsItem){
    extractImage(this.feedsItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: clr_black,
      ),
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),

      child: InkWell(
        onTap: () {
          Navigator.of(context).push(FeedItemDetailsView.route(feedsItem));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Text(
                feedsItem.title,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    inherit: true,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            Html(
              data: feedsItem.description.toString(),
style: {
                "p": Style(color: Colors.white, fontSize: FontSize.medium)
},
              onImageTap: (url, con, attributes, element) {
                Navigator.of(context).push(FeedItemDetailsView.route(feedsItem));
              },
              onLinkTap: (url, context, attributes, element) {
                if(url != null){
                  _launchInWebViewWithJavaScript(url);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void extractImage(FeedsItem feedsItem) {
    // print(feedsItem.description);
    // var desc = feedsItem.description as XmlElement;
    // print("${desc.children[0]}");
    //
    // desc.findAllElements('![CDATA[').forEach((element) {
    //   print("element - ${element.text}");
    // });
  }
}
