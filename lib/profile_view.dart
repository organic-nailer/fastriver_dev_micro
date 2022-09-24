import 'package:fastriver_dev_micro/datastore.microcms.g.dart';
import 'package:fastriver_dev_micro/model/blog.dart';
import 'package:fastriver_dev_micro/model/providers.dart';
import 'package:fastriver_dev_micro/safe_launch.dart';
import 'package:fastriver_dev_micro/types.microcms.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl/intl.dart';

class ProfileView extends ConsumerWidget {

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
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: 96, height: 96,
                    child: Image.asset("asset/fastriver_logo.jpg")
                  ),
                ),
                Text("Fastriver/@fastriver_org", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("時代は20XX年。空前の四字熟語ブームにより“四字熟語戦国時代”と化した矢上。勉強や喧嘩の強さではなく四字熟語を積んだ高さで優劣を決められてしまう世界で、激しいタワーバトルを繰り広げる暇人たちの熱い戦いが繰り広げられる― / 「四字熟語タワーバトル」より"),
                ),
                Text("活動", style: Theme.of(context).textTheme.headlineLarge,),
                const Divider(),
                ...MicroCMSDataStore.activityData.map((item) => ActivityItem(data: item)),
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
      trailing: data.link != null ? IconButton(onPressed: () {
        safeLaunchUrl(data.link!);
      }, icon: const Icon(Icons.link)) : null,
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
        return ListTile(
          leading: SvgPicture.asset("asset/logo_zenn.svg", width: 40, height: 40,),
          title: Text(data.title),
          subtitle: Text("${dateFormat.format(data.publishedAt.toLocal())} - Zenn.dev"),
          onTap: () {
            safeLaunchUrl(data.link);
          },
        );
      case "hatena":
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white70,
            child: SvgPicture.asset("asset/logo_hatena.svg", width: 40, height: 40,)
          ),
          title: Text(data.title),
          subtitle: Text("${dateFormat.format(data.publishedAt.toLocal())} - nageler.hatenablog.com"),
          onTap: () {
            safeLaunchUrl(data.link);
          },
        );
      case "qiita":
        return ListTile(
          leading: SizedBox(
            width: 40, height: 40,
            child: Image.asset("asset/logo_qiita.png"),
          ),
          title: Text(data.title),
          subtitle: Text("${dateFormat.format(data.publishedAt.toLocal())} - Qiita.com"),
          onTap: () {
            safeLaunchUrl(data.link);
          },
        );
      default:
        throw Exception("Unsupported source ${data.source}");
    }
  }
}
