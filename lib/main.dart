import 'package:fastriver_dev_micro/datastore.microcms.g.dart';
import 'package:fastriver_dev_micro/fast_color.dart';
import 'package:fastriver_dev_micro/home_view.dart';
import 'package:fastriver_dev_micro/profile_view.dart';
import 'package:fastriver_dev_micro/theme_scope.dart';
import 'package:fastriver_dev_micro/theme_switcher.dart';
import 'package:fastriver_dev_micro/work_detail_page.dart';
import 'package:fastriver_dev_micro/works_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:url_launcher/link.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja_JP');
  usePathUrlStrategy();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeScope(
        seedColor: materialFastGreen,
        themeMode: ThemeMode.system,
        builder: (context, lightTheme, darkTheme, mode) {
          return MaterialApp.router(
            title: 'Fastriver.dev',
            theme: lightTheme.copyWith(textTheme: GoogleFonts.kleeOneTextTheme(lightTheme.textTheme)),
            darkTheme: darkTheme.copyWith(textTheme: GoogleFonts.kleeOneTextTheme(darkTheme.textTheme)),
            themeMode: mode,
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
          );
        });
  }

  final _router = GoRouter(
      routes: [
        GoRoute(path: "/", redirect: (_, __) => "/home"),
        GoRoute(
            path: "/home",
            pageBuilder: (context, state) {
              return MaterialPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const MyHomePage(
                  index: 0,
                )
              );
            }),
        GoRoute(
            path: "/works",
            pageBuilder: (context, state) {
              return MaterialPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const MyHomePage(
                  index: 1,
                )
              );
            }),
        GoRoute(
            path: "/profile",
            pageBuilder: (context, state) {
              return MaterialPage(
                key: state.pageKey,
                restorationId: state.pageKey.value,
                child: const MyHomePage(
                  index: 2,
                )
              );
            }),
        GoRoute(
            path: "/works/:wid",
            pageBuilder: (context, state) {
              final wid = state.pathParameters["wid"]!;
              final data = MicroCMSDataStore.worksData;
              final work = data.firstWhere((e) => e.id == wid,
                  orElse: () => throw Exception("works not found: $wid"));

              return MaterialPage(
                  key: state.pageKey,
                  restorationId: state.pageKey.value,
                  child: DetailPage(
                    key: state.pageKey,
                    product: work,
                  ));
            })
      ],
      errorPageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          restorationId: state.pageKey.value,
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
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _key.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isPhone = constraints.biggest.width <= 480;
      return Scaffold(
        key: _key,
        appBar: AppBar(
          leading: isPhone ? Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              splashRadius: 24,
              icon: const Icon(Icons.menu),
              onPressed: () {
                _key.currentState!.openDrawer();
              },
            ),
          ) : null,
          title: const Text("Fastriver.dev", style: TextStyle(fontWeight: FontWeight.bold),),
          toolbarHeight: 64,
          actions: [
            Link(
              uri: Uri.parse("https://github.com/organic-nailer"),
              builder: (context, followLink) {
                return IconButton(
                    onPressed: followLink,
                    icon: SvgPicture.asset(
                      "asset/logo_github.svg",
                      colorFilter: ColorFilter.mode(
                          FastTheme.of(context).isDark(context)
                              ? Colors.white
                              : Colors.black,
                          BlendMode.srcIn),
                      semanticsLabel: "GitHub",
                      width: 32,
                      height: 32,
                    ));
              }
            ),
            const SizedBox(
              width: 8,
            ),
            Link(
              uri: Uri.parse("https://twitter.com/Fastriver_org"),
              builder: (context, followLink) {
                return IconButton(
                    onPressed: followLink,
                    icon: SvgPicture.asset(
                      "asset/logo_twitter.svg",
                      colorFilter: ColorFilter.mode(
                          FastTheme.of(context).isDark(context)
                              ? Colors.white
                              : Colors.black,
                          BlendMode.srcIn),
                      semanticsLabel: "Twitter",
                      width: 28,
                      height: 28,
                    ));
              }
            ),
            if(!isPhone) const ThemeSwitcher(),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        drawer: isPhone
            ? Drawer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 64,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: IconButton(onPressed: () {
                          _key.currentState!.closeDrawer();
                        }, icon: const Icon(Icons.arrow_back), iconSize: 32,),
                      ),
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.house_outlined, size: 32,),
                      ),
                      title: const Text("ホーム"),
                      onTap: () {
                        _key.currentState!.openEndDrawer();
                        context.go("/home");
                      },
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.museum_outlined, size: 32,),
                      ),
                      title: const Text("作品集"),
                      onTap: () {
                        _key.currentState!.openEndDrawer();
                        context.go("/works");
                      },
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.badge_outlined, size: 32,),
                      ),
                      title: const Text("プロフィール"),
                      onTap: () {
                        _key.currentState!.openEndDrawer();
                        context.go("/profile");
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    const Center(
                      child: ThemeSwitcher())
                  ],
                ),
              )
            : null,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isPhone)
              NavigationRail(
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                      icon: const Icon(Icons.house_outlined),
                      selectedIcon: const Icon(Icons.home),
                      label: Text("ホーム", style: Theme.of(context).textTheme.labelLarge,)),
                  NavigationRailDestination(
                      icon: const Icon(Icons.museum_outlined),
                      selectedIcon: const Icon(Icons.museum),
                      label: Text("作品集", style: Theme.of(context).textTheme.labelLarge,)),
                  NavigationRailDestination(
                      icon: const Icon(Icons.badge_outlined),
                      selectedIcon: const Icon(Icons.badge),
                      label: Text("プロフィール", style: Theme.of(context).textTheme.labelLarge,)),
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
                elevation: 1,
              ),
            Expanded(
                child: widget.index == 1
                    ? const WorksPage()
                    : widget.index == 0
                        ? const HomeView()
                        : const ProfileView())
          ],
        ),
      );
    });
  }
}
