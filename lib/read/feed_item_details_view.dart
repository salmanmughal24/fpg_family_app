import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fpg_family_app/model/FeedsItem.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helper/colors.dart';
import '../helper/utils.dart';

class FeedItemDetailsView extends StatefulWidget {
  FeedsItem feedsItem;

  FeedItemDetailsView(this.feedsItem);

  static Route route(FeedsItem feedsItem) {
    return MaterialPageRoute(
        builder: (context) => FeedItemDetailsView(feedsItem));
  }

  @override
  State<FeedItemDetailsView> createState() => _FeedItemDetailsViewState();
}

class _FeedItemDetailsViewState extends State<FeedItemDetailsView> {
  late WebViewController _controller;

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clr_black,
        title: Text(
          "",
          style: label_appbar(),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'about:blank',
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            onProgress: (progress) {

            },
            navigationDelegate: (NavigationRequest request) {
              // if (request.url.startsWith('https://www.youtube.com/')) {
              //   print('blocking navigation to $request}');
              //   return NavigationDecision.prevent;
              // }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            gestureNavigationEnabled: true,
            onWebViewCreated: (WebViewController webViewController) {
              debugPrint("Webview Created");
              _controller = webViewController;
              _loadHtmlFromAssets();
            },
            onPageFinished: (url) {
              setState(() {
                loading = false;
              });
            },
            onPageStarted: (url) {
              setState(() {
                loading = true;
              });
            },
          ),
          loading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }

  void _loadHtmlFromAssets() {
    _controller.loadUrl(widget.feedsItem.link);
  }
}
