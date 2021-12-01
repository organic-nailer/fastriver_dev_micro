import 'package:fastriver_dev_micro/datastore.microcms.g.dart';
import 'package:fastriver_dev_micro/fast_color.dart';
import 'package:fastriver_dev_micro/home_view.dart';
import 'package:fastriver_dev_micro/safe_launch.dart';
import 'package:fastriver_dev_micro/theme_switcher.dart';
import 'package:fastriver_dev_micro/under_construction_view.dart';
import 'package:fastriver_dev_micro/work_detail_page.dart';
import 'package:fastriver_dev_micro/works_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_ui_white/flutter_fast_ui_white.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ja_JP');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FastThemeScope(
        accentColor: materialFastGreen,
        themeMode: ThemeMode.system,
        builder: (context, lightTheme, darkTheme, mode) {
          return MaterialApp.router(
            title: 'Fastriver.dev',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: mode,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
          );
        });
  }

  final _router = GoRouter(
      routes: [
        GoRoute(path: "/", redirect: (_) => "/home"),
        GoRoute(
            path: "/home",
            pageBuilder: (context, state) {
              return const MaterialPage(
                  child: MyHomePage(
                index: 0,
              ));
            }),
        GoRoute(
            path: "/works",
            pageBuilder: (context, state) {
              return const MaterialPage(
                  child: MyHomePage(
                index: 1,
              ));
            }),
        GoRoute(
            path: "/profile",
            pageBuilder: (context, state) {
              return const MaterialPage(
                  child: MyHomePage(
                index: 2,
              ));
            }),
        GoRoute(
            path: "/works/:wid",
            pageBuilder: (context, state) {
              final wid = state.params["wid"]!;
              final data = MicroCMSDataStore.worksData;
              final work = data.firstWhere((e) => e.id == wid,
                  orElse: () => throw Exception("works not found: $wid"));

              return MaterialPage(
                  key: state.pageKey,
                  child: DetailPage(
                    key: state.pageKey,
                    product: work,
                  ));
            })
      ],
      errorPageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: Center(
            child: Text(state.error?.toString() ?? "Not found"),
          )));
}

// Future<String> getProfile() async {
//   return profileData().toString();
// }

class MyHomePage extends StatefulWidget {
  final int index;
  const MyHomePage({Key? key, this.index = 0}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? railExtended;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isPhone = constraints.biggest.width <= 480;
      final isPC = constraints.biggest.width > 768;
      railExtended ??= isPC;
      return Scaffold(
        key: _key,
        appBar: FastAppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              splashRadius: 24,
              icon: const Icon(Icons.menu),
              onPressed: () {
                if (isPhone) {
                  _key.currentState!.openDrawer();
                } else {
                  setState(() {
                    railExtended = !railExtended!;
                  });
                }
              },
            ),
          ),
          title: const Text("Fastriver.dev"),
          toolbarHeight: 64,
          actions: [
            IconButton(
                onPressed: () async {
                  safeLaunchUrl("https://github.com/organic-nailer");
                },
                icon: Image.asset(
                  "asset/logo_github.png",
                  color: FastTheme.of(context).nonColoredAccent,
                  isAntiAlias: true,
                  semanticLabel: "GitHub",
                )),
            const SizedBox(
              width: 8,
            ),
            IconButton(
                onPressed: () async {
                  safeLaunchUrl("https://twitter.com/Fastriver_org");
                },
                icon: Image.asset(
                  "asset/logo_twitter.png",
                  color: FastTheme.of(context).nonColoredAccent,
                  isAntiAlias: true,
                  semanticLabel: "Twitter",
                )),
            const ThemeSwitcher()
          ],
        ),
        drawer: isPhone
            ? Drawer(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.house_outlined),
                      title: const Text("ホーム"),
                      onTap: () {
                        _key.currentState!.openEndDrawer();
                        context.go("/home");
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.museum_outlined),
                      title: const Text("作品集"),
                      onTap: () {
                        _key.currentState!.openEndDrawer();
                        context.go("/works");
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: const Text("プロフィール"),
                      onTap: () {
                        _key.currentState!.openEndDrawer();
                        context.go("/profile");
                      },
                    ),
                  ],
                ),
              )
            : null,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isPhone)
              NavigationRail(
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(Icons.house_outlined),
                      selectedIcon: Icon(Icons.house),
                      label: Text("ホーム")),
                  NavigationRailDestination(
                      icon: Icon(Icons.museum_outlined),
                      selectedIcon: Icon(Icons.museum),
                      label: Text("作品集")),
                  NavigationRailDestination(
                      icon: Icon(Icons.badge_outlined),
                      selectedIcon: Icon(Icons.badge),
                      label: Text("プロフィール")),
                ],
                onDestinationSelected: (index) {
                  final path = index == 0
                      ? "/home"
                      : index == 1
                          ? "/works"
                          : "/profile";
                  context.go(path);
                },
                selectedIndex: widget.index,
                extended: railExtended!,
              ),
            const VerticalDivider(
              thickness: 1,
              width: 1,
            ),
            Expanded(
                child: widget.index == 1
                    ? const WorksPage()
                    : widget.index == 0
                        ? const HomeView()
                        : const UnderConstructionView())
          ],
        ),
      );
    });
  }
}
