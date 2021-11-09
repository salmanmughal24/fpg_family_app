import 'package:flutter/material.dart';
import 'package:fpg_family_app/helper/utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/theme_model.dart';
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
  late bool isSwitched = false ;
  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.symmetric(vertical: 10.0),
        color: themeProvider.isLightTheme
            ? clr_white
            : clr_black,//clr_black,
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
