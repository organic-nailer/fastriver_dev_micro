import 'dart:convert';

import 'package:fastriver_dev_micro/model/blog.dart';
import 'package:fastriver_dev_micro/static_fetched_data.g.dart';

class BlogsQiita {
  List<Blog> get() {
    var rawData = StaticFetchedDataStore.qiitaData;
    var decoded = jsonDecode(rawData) as List<dynamic>;
    var results = <Blog>[];
    for(var item in decoded) {
      results.add(Blog(
        item["title"], 
        "", 
        item["url"], 
        DateTime.parse(item["created_at"]), 
        "",
        "qiita"
      ));
    }
    return results;
  }
}