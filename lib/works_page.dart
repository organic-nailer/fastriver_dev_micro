import 'dart:math';

import 'package:fastriver_dev_micro/animated_grid.dart';
import 'package:fastriver_dev_micro/datastore.microcms.g.dart';
import 'package:fastriver_dev_micro/types.microcms.g.dart';
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
  List<WorksMicroData> items = [];
  Map<String, Key> itemKey = {};
  @override
  void initState() {
    super.initState();
    final source = MicroCMSDataStore.worksData;
    //新しい順に並べる
    items = source
      ..sort((a, b) =>
          b.create.millisecondsSinceEpoch - a.create.millisecondsSinceEpoch);
    for (var item in items) {
      itemKey[item.id] = UniqueKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var width = constraints.biggest.width;
      var columnSize = max(width ~/ 300, 1);
      return SingleChildScrollView(
        child: AnimatedGrid<WorksMicroData>(
            itemHeight: 400,
            itemWidth: 300,
            items: items,
            columns: columnSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            curve: Curves.easeInOutBack,
            keyBuilder: (item) => itemKey[item.id]!,
            builder: (context, item, details) {
              return itemWidget(item);
            }),
      );
    });
  }

  Widget itemWidget(WorksMicroData data) => Card(
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
                            dateFormat.format(data.create.toLocal()),
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
                                  data.icon!.url,
                                  height: 180,
                                  width: 180,
                                )
                              : const Icon(Icons.dashboard_customize,
                                  size: 180),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            data.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.merge(const TextStyle(height: 1)),
                            //style: FastTheme.of(context).theme.textTheme.bodyText1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          child: Text(data.short_text ?? "",
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
