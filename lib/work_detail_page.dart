import 'dart:math';

import 'package:adjusted_html_view_web/adjusted_html_view_web.dart';
import 'package:fastriver_dev_micro/theme_switcher.dart';
import 'package:fastriver_dev_micro/types.microcms.g.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:url_launcher/link.dart';

var formatter = DateFormat('yyyy年 MM月', "ja_JP");

class DetailPage extends StatelessWidget {
  final WorksMicroData product;
  const DetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = product.create;
    return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
          leading: Link(
              uri: Uri.parse("/works"),
              builder: (context, followLink) {
                return IconButton(
                    onPressed: followLink, icon: const Icon(Icons.arrow_back));
              }),
          actions: const [
            ThemeSwitcher(),
            SizedBox(width: 8)
          ],
        ),
        body: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 800, minWidth: 100),
                  child: Card(
                    elevation: 6,
                    shape: const BeveledRectangleBorder(),
                    margin: const EdgeInsets.only(bottom: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        var width = constraints.biggest.width;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                if (product.header != null)
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    bottom: 0,
                                    child: ShaderMask(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints.tight(
                                            Size(width, width * 296 / 800.0)),
                                        child: Image.network(
                                          product.header!.url,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.white.withAlpha(150),
                                            Colors.white.withAlpha(0),
                                          ],
                                        ).createShader(Rect.fromLTRB(
                                            0, 0, bounds.width, bounds.height));
                                      },
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.all(width * 32 / 800.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(width * 16 / 800.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(width * 36 / 800.0),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer
                                              .withAlpha(100),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(width * 0.025),
                                          child: product.icon != null
                                              ? Image.network(
                                                  product.icon!.url,
                                                  height: max(width * 0.25, 50),
                                                  width: max(width * 0.25, 50),
                                                )
                                              : Icon(Icons.dashboard_customize,
                                                  size: min(width * 0.25, 50)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                "${formatter.format(date.toLocal())} 作成",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              Text(
                                                product.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              ),
                                              Text(
                                                product.short_text ?? "[short]",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (product.links != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: product.links!
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Link(
                                                uri: Uri.parse(
                                                    (e as WorksLinkMicroData).url),
                                                builder: (context, followLink) {
                                                  return OutlinedButton(
                                                    onPressed: followLink,
                                                    child: Text(e.name),
                                                  );
                                                  // return ElevatedButton(
                                                  //     child: Text(e.name),
                                                  //     onPressed: followLink,
                                                  //     style: ElevatedButton.styleFrom(
                                                  //         shape:
                                                  //             RoundedRectangleBorder(
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(
                                                  //               30.0),
                                                  //     )));
                                                }),
                                          ))
                                      .toList(),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AdjustedHtmlView(
                                htmlText: product.description ??
                                    "<h1>No description</h1>"),
                            ),
                            
                          ],
                        );
                      }
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
