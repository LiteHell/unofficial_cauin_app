import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleBody.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';
import 'package:unofficial_cauin_app/pages/cauinArticle/cauinArticleComment.dart';
import 'package:unofficial_cauin_app/pages/cauinArticle/cauinArticleTitle.dart';
import 'package:unofficial_cauin_app/pages/cauinArticle/fixedSizeWebView.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CauinArticlePage extends StatelessWidget {
  final CauinArticleItem _article;
  const CauinArticlePage({super.key, required CauinArticleItem article})
      : _article = article;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text('${_article.category} - ${_article.title}')),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            CauinArticlePageTitle(article: _article),
            const Divider(),
            if (_article.body == null)
              const Center(child: Text('???'))
            else
              // TO-DO: Use htmlview
              ...[
              DefiniteSizeWebView(
                  html: _article.body!.content,
                  baseUrl: 'http://cauin.cau.ac.kr'),
              const Divider(),
              if (_article.body!.comments.isEmpty)
                const Padding(
                    padding: EdgeInsets.all(3),
                    child: Center(
                      child: Text('댓글이 없습니다.'),
                    ))
              else
                ...ListTile.divideTiles(
                    context: context,
                    tiles: _article.body!.comments.map(
                        (comment) => CauinArticlePageComment(comment: comment)))
            ]
          ])),
    );
  }
}
