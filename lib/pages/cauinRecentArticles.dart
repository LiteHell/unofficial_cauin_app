import 'package:flutter/material.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';
import 'package:unofficial_cauin_app/widget/ArticleItemListTile.dart';
import 'package:unofficial_cauin_app/widget/CauinDrawer.dart';

class CauinRecentArticles extends StatefulWidget {
  const CauinRecentArticles({super.key});

  @override
  State<CauinRecentArticles> createState() => _CauinRecentArticlesState();
}

class _CauinRecentArticlesState extends State<CauinRecentArticles> {
  final List<CauinArticleItem> _recentArticles = [];
  var loadedPages = 0;
  var loading = false;
  var noMoreLoading = false;

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  void loadPage() {
    if (loading || noMoreLoading) {
      return;
    }
    loading = true;
    final pageToLoad = loadedPages + 1;
    CauinSession().getRecentArticles(page: pageToLoad).then((articles) {
      if (articles.isEmpty) {
        setState(() {
          loading = false;
          noMoreLoading = true;
        });
      } else {
        setState(() {
          _recentArticles.addAll(articles);
          loading = false;
          loadedPages = pageToLoad;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        loadPage();
      }
    });
    return Scaffold(
        appBar: AppBar(title: const Text('중앙인 최근글')),
        drawer: cauinDrawer(),
        body: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount: _recentArticles.length * 2 + 2,
            itemBuilder: (context, i) {
              if (i.isOdd) return const Divider();

              final index = i ~/ 2;
              if (index >= _recentArticles.length) {
                if (noMoreLoading) {
                  return const ListTile(
                      title: Center(child: Text('더 이상 불러올 게시글이 없습니다.')));
                } else if (loading) {
                  return const ListTile(
                      title: Center(
                          child: CircularProgressIndicator(
                              semanticsLabel: '게시글을 불러오고 있습니다...')));
                } else {
                  return const ListTile(
                      title: Center(
                          child: CircularProgressIndicator(
                              semanticsLabel: '밑으로 끝까지 내리면 새로운 게시물을 볼러옵니다.')));
                }
              } else {
                return CauinArticleItemToListTile(
                    _recentArticles[index], context);
              }
            }));
  }
}
