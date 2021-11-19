import 'dart:math';

import 'package:fastriver_dev_micro/animated_grid.dart';
import 'package:fastriver_dev_micro/micro_cms_data.gen.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

var dateFormat = DateFormat('yyyy/MM');

class WorksPage extends StatefulWidget {
  const WorksPage({Key? key}) : super(key: key);

  @override
  _WorksPageState createState() => _WorksPageState();
}

class _WorksPageState extends State<WorksPage> {
  final keys = List.generate(10, (index) => UniqueKey());
  List<WorksData> items = [];
  @override
  void initState() {
    super.initState();
    final source = worksData();
    final contents = source["contents"] as List;
    for (var content in contents) {
      items.add(WorksData.fromMap(content));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var width = constraints.biggest.width;
      var columnSize = max(width ~/ 300, 1);
      return SingleChildScrollView(
        child: AnimatedGrid<WorksData>(
            itemHeight: 400,
            itemWidth: 300,
            items: items,
            columns: columnSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            curve: Curves.easeInOutBack,
            keyBuilder: (item) => item.key!,
            builder: (context, item, details) {
              return itemWidget(item);
            }),
      );
    });
  }

  Widget itemWidget(WorksData data) => Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                .side),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.go("/works/${data.id}");
          },
          child: Container(
              height: 500,
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
              child: Stack(
                children: [
                  Positioned(
                      top: 8,
                      right: 0,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Opacity(
                          opacity: 0.3,
                          child: Text(
                            dateFormat.format(data.date),
                            style: Theme.of(context).textTheme.headline2?.merge(
                                const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    height: 1,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      )),
                  Positioned.fill(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: data.icon != null
                              ? Image.network(
                                  data.icon!,
                                  height: 180,
                                  width: 180,
                                )
                              : const Icon(Icons.dashboard_customize,
                                  size: 180),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            data.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                            //style: FastTheme.of(context).theme.textTheme.bodyText1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(data.shortText ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );
}

class WorksData {
  final String id;
  final String title;
  final String? icon;
  final DateTime date;
  final String? shortText;
  final String? description;
  final String? headerImg;
  final List<LinkData> links;
  UniqueKey? key;
  WorksData(this.id, this.title, this.icon, this.date, this.shortText,
      this.description, this.headerImg, this.links) {
    key = UniqueKey();
  }

  static WorksData fromMap(Map<String, dynamic> data) {
    return WorksData(
        data["id"],
        data["title"],
        getImageLink(data["icon"]),
        DateTime.parse(data["create"]),
        data["short_text"],
        data["description"],
        getImageLink(data["header"]),
        LinkData.fromMapList(data["links"]));
  }

  static String? getImageLink(Map<String, dynamic>? data) {
    if (data == null) return null;
    return data["url"];
  }
}

class LinkData {
  final String url;
  final String name;
  const LinkData(this.url, this.name);

  static List<LinkData> fromMapList(List<dynamic>? data) {
    return data?.map((e) => LinkData(e["url"], e["name"])).toList() ?? [];
  }
}
