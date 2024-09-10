import 'dart:math';

import 'package:fastriver_dev_micro/adjusted_html_view_wrapper/adjusted_html_view_wrapper.dart';
import 'package:fastriver_dev_micro/theme_switcher.dart';
import 'package:fastriver_dev_micro/types.microcms.g.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:url_launcher/link.dart';

var formatter = DateFormat('yyyy年 MM月', "ja_JP");

class DetailPage extends StatelessWidget {
  final WorksMicroData product;
  const DetailPage({super.key, required this.product});

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
        actions: const [ThemeSwitcher(), SizedBox(width: 8)],
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800, minWidth: 100),
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(builder: (context, constraints) {
                  var width = constraints.biggest.width;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: AspectRatio(
                          aspectRatio: 25 / 10,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                ),
                              ),
                              if (product.header != null)
                                Positioned.fill(
                                  child: ShaderMask(
                                    child: Image.network(
                                      product.header!.url,
                                      fit: BoxFit.cover,
                                    ),
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.white.withAlpha(10),
                                          Colors.white.withAlpha(150),
                                        ],
                                      ).createShader(Rect.fromLTRB(
                                          0, 0, bounds.width, bounds.height));
                                    },
                                  ),
                                ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(54.0),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        child: product.icon != null
                                            ? Image.network(
                                                product.icon!.url,
                                                height: 180,
                                                width: 180,
                                              )
                                            : const Icon(
                                                Icons.dashboard_customize,
                                                size: 180),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "${formatter.format(date.toLocal())} 作成",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              product.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.merge(const TextStyle(
                                      height: 1.5,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(
                              product.short_text ?? "[short]",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            if (product.links != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: product.links!
                                      .map((e) => Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Link(
                                                uri: Uri.parse(
                                                    (e as WorksLinkMicroData)
                                                        .url),
                                                builder: (context, followLink) {
                                                  return OutlinedButton(
                                                    onPressed: followLink,
                                                    child: Text(e.name),
                                                  );
                                                }),
                                          ))
                                      .toList(),
                                ),
                              ),
                            const SizedBox(height: 16),
                            AdjustedHtmlViewWrapper().build(
                                product.description ??
                                    "<h1>No description</h1>"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          color: Theme.of(context).colorScheme.surfaceContainer,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Link(
                                uri: Uri.parse("/works"),
                                builder: (context, followLink) {
                                  return TextButton.icon(
                                    onPressed: followLink,
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded),
                                    label: const Text("Back"),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
