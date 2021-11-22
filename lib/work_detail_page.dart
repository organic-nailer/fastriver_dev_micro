import 'dart:math';

import 'package:fastriver_dev_micro/types.microcms.g.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';

var formatter = DateFormat('yyyy年 MM月', "ja_JP");

class DetailPage extends StatelessWidget {
  final WorksMicroData product;
  const DetailPage({Key? key, required this.product}) : super(key: key);

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    var date = product.create;
    return LayoutBuilder(builder: (context, constraints) {
      var width = constraints.biggest.width;
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                background: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                      Colors.black26, BlendMode.multiply),
                  child: product.header != null
                      ? Image.network(
                          product.header!.url,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
              ),
              pinned: true,
              floating: true,
              expandedHeight: 300,
              backgroundColor: Theme.of(context).primaryColor,
              title: Text("Fastriver.dev - ${product.title}"),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          constraints: const BoxConstraints(
                              maxWidth: 800, minWidth: 100),
                          child: Card(
                            elevation: 6,
                            shape: const BeveledRectangleBorder(),
                            margin: const EdgeInsets.only(bottom: 24),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, bottom: 16, left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      if (product.icon != null)
                                        Image.network(
                                          product.icon!.url,
                                          width: min(width * 0.2, 200),
                                        ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                                    .caption,
                                              ),
                                              Text(
                                                product.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2,
                                              ),
                                              Text(
                                                product.short_text ?? "[short]",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  if (product.links != null)
                                    Wrap(
                                      children: product.links!
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: ElevatedButton(
                                                    child: Text(
                                                        (e as WorksLinkMicroData)
                                                            .name),
                                                    onPressed: () async {
                                                      _launchUrl(e.url);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ))),
                                              ))
                                          .toList(),
                                      alignment: WrapAlignment.start,
                                    ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: (Theme.of(context).cardTheme.shape
                                                as RoundedRectangleBorder)
                                            .side),
                                    color: Colors.white70,
                                    child: WebViewX(
                                      height: 800,
                                      width: 800 - 32 - 16,
                                      initialContent: product.description ??
                                          "<h1>No Description</h1>",
                                      ignoreAllGestures: true,
                                      initialSourceType: SourceType.html,
                                      onWebViewCreated: (c) async {
                                        print("WebView Created");
                                      },
                                    ),
                                  )
                                  // SizedBox(
                                  //   height: 500,
                                  //   width: 500,
                                  //   child: EasyWebView(
                                  //     src: product.description ??
                                  //         "<h1>No Description</h1>",
                                  //     isHtml: true,
                                  //     convertToWidgets: true,
                                  //     onLoaded: () {
                                  //       print("loaded");
                                  //     },
                                  //   ),
                                  // )
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       top: 24, bottom: 24, left: 8, right: 8),
                                  //   child:
                                  //       Text(product.description ?? "[desc]"),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            )
          ],
        ),
      );
    });
  }
}
