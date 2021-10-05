// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:webfeed/domain/rss_item.dart';

abstract class DownloadService {
  Future<bool> downloadEpisode(RssItem item);
  void dispose();
}
