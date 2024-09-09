import 'dart:math';

import 'package:fastriver_dev_micro/animated_grid.dart';
import 'package:fastriver_dev_micro/datastore.microcms.g.dart';
import 'package:fastriver_dev_micro/types.microcms.g.dart';
import 'package:fastriver_dev_micro/util/budoux.dart';
import 'package:flutter/material.dart' hide AnimatedGrid;
import 'package:intl/intl.dart';
import 'package:url_launcher/link.dart';

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
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20.0),
        //     side: (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
        //         .side),
        clipBehavior: Clip.antiAlias,
        child: Link(
          uri: Uri.parse("/works/${data.id}"),
          builder: (context, followLink) {
            return InkWell(
              onTap: followLink,
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
                                style: Theme.of(context).textTheme.displayMedium?.merge(
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
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36.0),
                                color: Theme.of(context).colorScheme.secondaryContainer,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: data.icon != null
                                    ? Image.network(
                                        data.icon!.url,
                                        height: 148,
                                        width: 148,
                                      )
                                    : const Icon(Icons.dashboard_customize,
                                        size: 148),
                              ),
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
                                    .headlineMedium
                                    ?.merge(const TextStyle(height: 1)),
                                //style: FastTheme.of(context).theme.textTheme.bodyText1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 16),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: BudouxUtil().parse(data.short_text ?? "")
                                    .map((e) => Text(e,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyLarge))
                                    .toList(),
                              ),
                              // child: Text(BudouxUtil().parse(data.short_text ?? "").join("\n"),
                              //     maxLines: 2,
                              //     overflow: TextOverflow.ellipsis,
                              //     style: Theme.of(context).textTheme.bodyLarge),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            );
          }
        ),
      );
}
