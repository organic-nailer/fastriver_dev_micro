// https://github.com/organic-nailer/flutter_fast_ui_white/blob/master/example/lib/components/theme_switcher.dart
import 'package:fastriver_dev_micro/theme_scope.dart';
import 'package:flutter/material.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  ThemeSwitcherState createState() => ThemeSwitcherState();
}

class ThemeSwitcherState extends State<ThemeSwitcher> {
  bool isDark = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isDark = FastTheme.of(context).isDark(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Light", style: Theme.of(context).textTheme.bodyLarge),
          Switch(
              value: isDark,
              onChanged: (value) {
                FastTheme.of(context)
                    .changeTheme(value ? Brightness.dark : Brightness.light);
                setState(() {
                  isDark = value;
                });
              }),
          Text("Dark", style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
