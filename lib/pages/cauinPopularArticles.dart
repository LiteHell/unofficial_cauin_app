import 'package:flutter/material.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';
import 'package:unofficial_cauin_app/widget/ArticleItemListTile.dart';
import 'package:unofficial_cauin_app/widget/CauinDrawer.dart';

class CauinPopularArticle extends StatefulWidget {
  const CauinPopularArticle({super.key});

  @override
  State<CauinPopularArticle> createState() => _CauinPopularArticleState();
}

class _CauinPopularArticleState extends State<CauinPopularArticle> {
  late Future<Iterable<CauinArticleItem>> _popularArticles;
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  void initState() {
    super.initState();
    var client = CauinSession();
    _popularArticles = client.getPopularArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('중앙인 인기글')),
        drawer: cauinDrawer(),
        body: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: 20,
            itemBuilder: (context, i) {
              if (i.isOdd) return const Divider();

              final index = i ~/ 2;
              return FutureBuilder(
                  future: _popularArticles,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CauinArticleItemToListTile(
                          snapshot.data!.elementAt(index), context);
                    }
                    if (snapshot.hasError) {
                      return const ListTile(
                          title: Text('오류가 발생했습니다!',
                              style: TextStyle(color: Colors.red)));
                    }
                    return const ListTile(
                        title: Center(
                            child: CircularProgressIndicator(
                                semanticsLabel: '게시글을 불러오고 있습니다...')));
                  });
            }));
  }
}
