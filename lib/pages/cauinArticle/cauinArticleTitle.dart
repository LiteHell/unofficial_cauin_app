import 'package:flutter/material.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';

class CauinArticlePageTitle extends StatelessWidget {
  final CauinArticleItem article;
  const CauinArticlePageTitle({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    const titleTextStyle = TextStyle(fontSize: 18);
    const subinfoTextSize = 12.0;
    const subinfoTextStyle = TextStyle(fontSize: subinfoTextSize);
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Column(children: [
          Text(article.title, style: titleTextStyle),
          Row(
            children: [
              const Icon(Icons.person, size: subinfoTextSize),
              Text(article.authorNickname),
              if (article.likes != null) ...[
                const Icon(Icons.thumb_up, size: subinfoTextSize),
                Text(article.likes!.toString(), style: subinfoTextStyle)
              ],
              if (article.dislikes != null) ...[
                const Icon(Icons.thumb_down, size: subinfoTextSize),
                Text(article.dislikes!.toString(), style: subinfoTextStyle)
              ]
            ]
                .map((e) =>
                    Padding(padding: EdgeInsets.fromLTRB(2, 0, 2, 0), child: e))
                .toList(),
          ),
          if (article.postedAt != null)
            Row(
                children: [
              const Icon(Icons.timer, size: subinfoTextSize),
              Text(article.postedAt!.toString(), style: subinfoTextStyle)
            ]
                    .map((e) => Padding(
                        padding: EdgeInsets.fromLTRB(2, 0, 2, 0), child: e))
                    .toList()),
        ]));
  }
}
