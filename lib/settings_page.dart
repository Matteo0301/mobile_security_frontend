import 'package:flutter/material.dart';
import 'package:mobile_security/config.dart';
import 'package:mobile_security/sqlite.dart';

class Settings extends StatelessWidget {
  const Settings({super.key, required this.onThemeChanged});
  final VoidCallback onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ThemeChooser(onThemeChanged: onThemeChanged),
    );
  }
}

class ThemeChooser extends StatefulWidget {
  final VoidCallback onThemeChanged;

  const ThemeChooser({super.key, required this.onThemeChanged});
  @override
  State<StatefulWidget> createState() => ThemeState();
}

class ThemeState extends State<ThemeChooser> {
  bool darkTheme = false;
  @override
  void initState() {
    super.initState();
    darkTheme = Config.darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: Config.darkTheme,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              darkTheme = value;
              Config.darkTheme = value;
              updateTheme(value);
            });
            widget.onThemeChanged();
          },
        ),
        Text('Dark theme'),
      ],
    );
  }
}
