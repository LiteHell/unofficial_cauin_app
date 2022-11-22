import 'package:flutter/material.dart';
import 'package:unofficial_cauin_app/cauColor.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';
import 'package:unofficial_cauin_app/pages/cauinPopularArticles.dart';
import 'package:unofficial_cauin_app/pages/cauinRecentArticles.dart';
import 'package:unofficial_cauin_app/pages/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '중앙인',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: cauBlue, foregroundColor: Colors.white)),
        home: const FirstLoading());
  }
}
