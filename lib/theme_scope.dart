import 'package:flutter/material.dart';

typedef MaterialBuilder = Widget Function(
    BuildContext context, ThemeData theme, ThemeData darkTheme, ThemeMode mode);

class ThemeScope extends StatefulWidget {
  final MaterialColor seedColor;
  final ThemeMode themeMode;
  final MaterialBuilder builder;
  const ThemeScope(
      {super.key,
      required this.seedColor,
      required this.themeMode,
      required this.builder});

  @override
  ThemeScopeState createState() => ThemeScopeState();
}

class ThemeScopeState extends State<ThemeScope> {
  late ThemeData lightTheme;
  late ThemeData darkTheme;
  late ThemeMode mode;
  @override
  void initState() {
    super.initState();
    lightTheme = ThemeData(
        useMaterial3: true,
        colorSchemeSeed: widget.seedColor,
        brightness: Brightness.light,
      );
    darkTheme = ThemeData(
        useMaterial3: true,
        colorSchemeSeed: widget.seedColor,
        brightness: Brightness.dark,
      );
    mode = widget.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return FastTheme(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: mode,
      changeTheme: changeTheme,
      child: widget.builder(context, lightTheme, darkTheme, mode),
    );
  }

  void changeTheme(Brightness brightness) {
    setState(() {
      mode = brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
    });
  }
}

class FastTheme<T extends Enum> extends InheritedWidget {
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  final Function(Brightness brightness) changeTheme;
  const FastTheme(
      {super.key,
      required super.child,
      required this.theme,
      required this.darkTheme,
      required this.themeMode,
      required this.changeTheme})
      : super();

  static FastTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FastTheme>() as FastTheme;
  }

  @override
  bool updateShouldNotify(FastTheme oldWidget) => oldWidget.themeMode != themeMode;

  // bool isDark(BuildContext context) {
  //   return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  // }
  bool isDark(BuildContext context) {
    switch(themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }
}
