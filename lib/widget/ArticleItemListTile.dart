import 'package:flutter/material.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';
import 'package:unofficial_cauin_app/cauin/formatDuration.dart';
import 'package:unofficial_cauin_app/pages/cauinArticle/cauinArticlePage.dart';
import 'package:unofficial_cauin_app/pages/loading.dart';

ListTile CauinArticleItemToListTile(
    CauinArticleItem item, BuildContext context) {
  TextStyle titleStyle = const TextStyle(fontSize: 16);
  TextStyle additionalInfoStyle =
      const TextStyle(fontSize: 12, color: Color.fromRGBO(200, 200, 200, 1));
  return ListTile(
    onTap: () {
      if (!CauinSession().loggedIn) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('로그인이 필요합니다.')));
        return;
      }
      CauinSession().getArticle(item.url).then((article) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => CauinArticlePage(article: article))));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류가 발생했습니다: ${error.toString()}')));
      });
    },
    title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(right: 5, left: item.isReply ? 16 : 0),
        child: [
          if (item.isNotice)
            Icon(Icons.announcement, size: 16)
          else if (item.isReply)
            Icon(Icons.reply, size: 16)
          else
            Icon(Icons.article, size: 16, color: Colors.transparent)
        ][0],
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.title,
            style: titleStyle,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1),
        Row(
          children: [
            const Icon(
              Icons.person,
              size: 13,
              semanticLabel: '작성자',
            ),
            Text(item.authorNickname, style: additionalInfoStyle),
            const Icon(
              Icons.folder,
              size: 13,
              semanticLabel: '카테고리',
            ),
            Text(item.category, style: additionalInfoStyle),
            if (item.postedAt != null) ...[
              const Icon(
                Icons.timer,
                size: 13,
                semanticLabel: '올라온 시간',
              ),
              Text(
                  '${formatDuration(DateTime.now().difference(item.postedAt!))} 전',
                  style: additionalInfoStyle)
            ]
          ]
              .map((e) => Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 3, 0), child: e))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (item.views != null)
              Row(
                  children: [
                const Icon(Icons.remove_red_eye,
                    semanticLabel: '조회수', size: 13),
                Text(item.views.toString(), style: additionalInfoStyle)
              ]
                      .map((e) => Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                          child: e))
                      .toList()),
            if (item.likes != null)
              Row(
                  children: [
                const Icon(Icons.favorite, semanticLabel: '좋아요 수', size: 13),
                Text(item.likes.toString(), style: additionalInfoStyle)
              ]
                      .map((e) => Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                          child: e))
                      .toList()),
            if (item.comments != null)
              Row(
                  children: [
                const Icon(Icons.message, semanticLabel: '댓글 수', size: 13),
                Text(item.comments.toString(), style: additionalInfoStyle)
              ]
                      .map((e) => Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                          child: e))
                      .toList())
          ],
        )
      ])
    ]),
  );
}
