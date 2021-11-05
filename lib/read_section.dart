import 'package:flutter/material.dart';
import 'package:fpg_family_app/helper/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'read/feed_item_view.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:fpg_family_app/model/FeedsItem.dart';
import 'package:fpg_family_app/repositories/feed_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ReadSection extends StatefulWidget {
  FeedsRepository feedsRepository;

  ReadSection(this.feedsRepository);

  @override
  State<ReadSection> createState() => _ReadSectionState(feedsRepository);
}

class _ReadSectionState extends State<ReadSection>
    with AutomaticKeepAliveClientMixin<ReadSection> {
  FeedsRepository feedsRepository;
  PagingController<int, FeedsItem> _pagingController =
      PagingController(firstPageKey: 1);

  _ReadSectionState(this.feedsRepository);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      getFeeds(pageKey);
    });
    super.initState();
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
    return Scaffold(
      backgroundColor: clr_black,
      appBar: AppBar(
        backgroundColor:  clr_selected_icon,
        title: Text(
          'FPG Family',
          style: label_appbar(),
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
                child: Text("GIVE",))),
          ),

        ],
      ),
      body:Container(
        color: Colors.black,//clr_black,
        child: PagedListView.separated(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<FeedsItem>(
            itemBuilder: (context, item, index) {
              return FeedItemView(item);
            },
          ),
          separatorBuilder: (context, index) {
            return Container(
              height: 10,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void getFeeds(int pageKey) async{
    var feeds = await feedsRepository.getFeeds(pageKey);
    if(feeds.isNotEmpty){
      _pagingController.appendPage(feeds, pageKey+1);
    } else {
      _pagingController.appendLastPage(feeds);
    }
  }
}
