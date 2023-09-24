import 'package:fastriver_dev_micro/datastore.microcms.g.dart';
import 'package:fastriver_dev_micro/model/blog.dart';
import 'package:fastriver_dev_micro/model/providers.dart';
import 'package:fastriver_dev_micro/types.microcms.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/link.dart';

import 'package:intl/intl.dart';

const List<(String, String)> _linkChips = [
  ("X (Twitter)", "https://twitter.com/fastriver_org"),
  ("GitHub", "https://github.com/organic-nailer"),
  ("Zenn", "https://zenn.dev/fastriver"),
  ("Qiita", "https://qiita.com/fastriver_org"),
  ("Hatena", "https://nageler.hatenablog.com/"),
  ("Lab", "https://sites.google.com/keio.jp/keio-csg/"),
];

class ProfileView extends ConsumerWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SizedBox(
                        width: 96,
                        height: 96,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset("asset/fastriver_logo.jpg", fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ],
                ),
                Text("Fastriver/@fastriver_org", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("時代は20XX年。空前の四字熟語ブームにより“四字熟語戦国時代”と化した矢上。勉強や喧嘩の強さではなく四字熟語を積んだ高さで優劣を決められてしまう世界で、激しいタワーバトルを繰り広げる暇人たちの熱い戦いが繰り広げられる― / 「四字熟語タワーバトル」より"),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  children: _linkChips.map((e) => Link(
                    uri: Uri.parse(e.$2),
                    builder: (context, followLink) {
                      return ActionChip(
                        label: Text(e.$1),
                        onPressed: followLink,
                      );
                    }
                  )).toList(),
                ),
                Text("活動", style: Theme.of(context).textTheme.headlineLarge,),
                const Divider(),
                ...MicroCMSDataStore
                  .activityData
                  .map((item) => ActivityItem(data: item))
                  .toList()
                  ..sort(((a, b) => -a.data.activity_date.compareTo(b.data.activity_date))),
                Text("ブログ", style: Theme.of(context).textTheme.headlineLarge,),
                const Divider(),
                ...ref.read(blogsProvider).map((item) => BlogItem(data: item)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final dateFormat = DateFormat("yyyy/MM/dd");

class ActivityItem extends StatelessWidget {
  final ActivityMicroData data;
  const ActivityItem({Key? key, required this.data}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${dateFormat.format(data.activity_date.toLocal())} - ${data.title}"),
      subtitle: data.description != null ? Text(data.description!) : null,
      trailing: data.link != null ? Link(
        uri: Uri.parse(data.link!),
        builder: (context, followLink) {
          return IconButton(onPressed: followLink, icon: const Icon(Icons.link));
        }
      ) : null,
    );
  }
}

class BlogItem extends StatelessWidget {
  final Blog data;
  const BlogItem({Key? key, required this.data}): super(key: key);

  @override
  Widget build(BuildContext context) {
    switch(data.source) {
      case "zenn":
        return Link(
          uri: Uri.parse(data.link),
          builder: (context, followLink) {
            return ListTile(
              leading: SvgPicture.asset("asset/logo_zenn.svg", width: 40, height: 40,),
              title: Text(data.title),
              subtitle: Text("${dateFormat.format(data.publishedAt.toLocal())} - Zenn.dev"),
              onTap: followLink,
            );
          }
        );
      case "hatena":
        return Link(
          uri: Uri.parse(data.link),
          builder: (context, followLink) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white70,
                child: SvgPicture.asset("asset/logo_hatena.svg", width: 40, height: 40,)
              ),
              title: Text(data.title),
              subtitle: Text("${dateFormat.format(data.publishedAt.toLocal())} - nageler.hatenablog.com"),
              onTap: followLink,
            );
          }
        );
      case "qiita":
        return Link(
          uri: Uri.parse(data.link),
          builder: (context, followLink) {
            return ListTile(
              leading: SizedBox(
                width: 40, height: 40,
                child: Image.asset("asset/logo_qiita.png"),
              ),
              title: Text(data.title),
              subtitle: Text("${dateFormat.format(data.publishedAt.toLocal())} - Qiita.com"),
              onTap: followLink,
            );
          }
        );
      default:
        throw Exception("Unsupported source ${data.source}");
    }
  }
}
