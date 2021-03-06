import 'package:flutter/material.dart';
import 'package:fpg_family_app/read_section.dart';
import 'package:fpg_family_app/repositories/podcast_repository.dart';
import 'package:fpg_family_app/watch_section.dart';
import 'package:path/path.dart';

import 'helper/colors.dart';
import 'helper/dimens.dart';
import 'helper/utils.dart';
import 'listner/listen_section.dart';
import 'repositories/feed_repository.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen();

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  FeedsRepository feedsRepository = FeedsRepository();
  PodcastRepository podcastsRepository;

  _HomePageScreenState()
      : podcastsRepository = PodcastRepository() {}

  int _currentIndex = 0;
  PageController _pageController = PageController(
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
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
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          if (index == 1) {
            return ListenSection(podcastsRepository);
          }
          if (index == 2) {
            return ReadSection(feedsRepository);
          }
          return WatchSection();
        },
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        itemCount: 4,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: clr_selected_icon,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        backgroundColor: clr_black,
        elevation: 2,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Watch',
            backgroundColor: clr_black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_down),
            label: 'Listen',
            backgroundColor: clr_black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Read',
            backgroundColor: clr_black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'For You',
            backgroundColor: clr_black,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
            _pageController.animateToPage(_currentIndex,
                duration: Duration(milliseconds: 100), curve: Curves.ease);
          });
        },
      ),
    );
  }
}
