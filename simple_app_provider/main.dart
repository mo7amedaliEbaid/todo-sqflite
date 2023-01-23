import 'package:flutter/material.dart';

import 'screens/home_page.dart';

 main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'TODO';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primaryColor: Colors.indigo,
          scaffoldBackgroundColor: Colors.indigo,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 2,
          ),
        ),
        home: HomePage(),
      );
}
