import 'dart:math';

import 'package:fastriver_dev_micro/datastore.microcms.g.dart';
import 'package:fastriver_dev_micro/types.microcms.g.dart';
import 'package:flutter/material.dart' hide AnimatedGrid;
import 'package:intl/intl.dart';
import 'package:url_launcher/link.dart';

var dateFormat = DateFormat('yyyy/MM');

class WorksPage extends StatefulWidget {
  const WorksPage({super.key});

  @override
  State<WorksPage> createState() => _WorksPageState();
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final size = constraints.biggest;
        final columnSize = max(size.width ~/ 720, 1);
        const itemWidth = 720.0;
        const itemHeight = 320.0;
        return Center(
          child: SizedBox(
            width: itemWidth * columnSize,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnSize,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: itemWidth / itemHeight,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return itemWidget2(items[index], items.length - index - 1);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget itemWidget2(WorksMicroData data, int index) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 720,
        height: 320,
        child: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Stack(
            children: [
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36.0),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: data.icon != null
                                  ? Image.network(
                                      data.icon!.url,
                                      height: 120,
                                      width: 120,
                                    )
                                  : const Icon(Icons.dashboard_customize,
                                      size: 120),
                            ),
                          ),
                          const Spacer(),
                          Text("#${index + 1}",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.2),
                                  textBaseline: TextBaseline.ideographic,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  height: 0.82)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          color: Theme.of(context).colorScheme.surfaceContainer,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.merge(const TextStyle(
                                        height: 1.2,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const Divider(),
                              Text(
                                data.short_text ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Spacer(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                      dateFormat.format(data.create.toLocal()),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                  const Spacer(),
                                  CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      child:
                                          const Icon(Icons.play_arrow_rounded)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Link(
                  uri: Uri.parse("/works/${data.id}"),
                  builder: (context, followLink) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: followLink,
                        hoverColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        splashColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.05),
                        highlightColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        child: Container(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
