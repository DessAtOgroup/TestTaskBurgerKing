import 'package:flutter/material.dart';

import 'package:untitled/presentation/firstpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Каталог бургер кинг',
        theme: ThemeData(
          colorScheme: ColorScheme.dark(),

        ),
      home: firstpage()
    );
  }
}
