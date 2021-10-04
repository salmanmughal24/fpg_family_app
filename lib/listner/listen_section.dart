import 'package:flutter/material.dart';
import 'package:fpg_family_app/helper/colors.dart';
import 'package:fpg_family_app/repositories/podcast_repository.dart';
import 'package:webfeed/domain/rss_feed.dart';

import 'channel_details.dart';

class ListenSection extends StatefulWidget {
  PodcastRepository feedsRepository;

  ListenSection(this.feedsRepository);

  @override
  State<ListenSection> createState() => _ListenSectionState(feedsRepository);
}

class _ListenSectionState extends State<ListenSection>
    with AutomaticKeepAliveClientMixin<ListenSection> {
  PodcastRepository feedsRepository;

  _ListenSectionState(this.feedsRepository);

  @override
  void initState() {
    feedsRepository.getChannelDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: clr_black,
      child: StreamBuilder<List<RssFeed>>(
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var items = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Container(
                  height: 0.5,
                  color: Colors.white,
                );
              },
              itemBuilder: (context, index) {
                var image = items[index].image?.url ??
                    'https://fpgfamily.com/wp-content/uploads/2021/09/cropped-FPG-Family-Circle-black-and-white-1-128x128.png';
                var author = items[index].author ?? "";
                var generator = items[index].generator ?? "";
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(ChannelDetails.route(items[index]));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            image,
                            height: 40,
                            width: 40,
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.white70,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index].title ?? "",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                "by $author",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white38,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: Text(
                              (items[index].items?.length.toString() ?? ""),
                              style: Theme.of(context).textTheme.bodyText1,
                            )),
                      ],
                    ),
                  ),
                );
              },
              itemCount: items.length,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        stream: feedsRepository.feedStreamController.stream,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
