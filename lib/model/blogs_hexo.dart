import 'package:fastriver_dev_micro/model/blog.dart';
import 'package:fastriver_dev_micro/static_fetched_data.g.dart';
import 'package:fastriver_dev_micro/util/parse_rfc822.dart';

import 'package:xml/xml.dart';

class BlogsHexo {
  List<Blog> get() {
    var rawData = StaticFetchedDataStore.hexoData;
    var document = XmlDocument.parse(rawData);
    var results = <Blog>[];
    for (var item in document
        .getElement("rss")!
        .getElement("channel")!
        .findAllElements("item")) {
      results.add(Blog(
          item.getElement("title")!.text,
          item.getElement("description")!.text,
          item.getElement("link")!.text,
          parseRfc822(item.getElement("pubDate")!.text)!,
          "",
          "hexo"));
    }
    return results;
  }
}
