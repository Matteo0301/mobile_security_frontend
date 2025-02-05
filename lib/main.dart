import 'package:flutter/material.dart';
import 'package:mobile_security/config.dart';
import 'package:mobile_security/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return App();
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: Config.darkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Login(title: "Login", onThemeChanged: () => setState(() {})),
      debugShowCheckedModeBanner: false,
    );
  }
}
