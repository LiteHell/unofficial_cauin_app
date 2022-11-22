import 'package:flutter/material.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleBody.dart';

class CauinArticlePageComment extends StatelessWidget {
  final CauinArticleAbstractComment comment;
  const CauinArticlePageComment({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    if (comment is CauinArticleDeletedComment) {
      return const ListTile(
          leading: Icon(Icons.close),
          title: Text('삭제된 댓글입니다.',
              style: TextStyle(color: Color.fromARGB(255, 73, 73, 73))));
    } else if (comment is CauinArticleComment) {
      final commentCasted = comment as CauinArticleComment;
      const smallSize = 13.0;
      const smallColor = Color.fromARGB(255, 146, 146, 146);
      const smallTextStyle = TextStyle(fontSize: smallSize, color: smallColor);
      return ListTile(
          leading: commentCasted.isReply ? Icon(Icons.reply) : null,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 24.0),
                  Text(commentCasted.author.nickname),
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(26, 7, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(commentCasted.content.trim()),
                      Padding(
                          padding: EdgeInsets.only(top: 7),
                          child: Row(
                            children: [
                              Icon(Icons.thumb_up,
                                  size: smallSize, color: smallColor),
                              Text(commentCasted.likes.toString(),
                                  style: smallTextStyle),
                              Icon(Icons.thumb_down,
                                  size: smallSize, color: smallColor),
                              Text(commentCasted.dislikes.toString(),
                                  style: smallTextStyle)
                            ],
                          )),
                      Row(children: [
                        Icon(Icons.timer, size: smallSize, color: smallColor),
                        Text(commentCasted.commentedAt.toString(),
                            style: smallTextStyle)
                      ])
                    ],
                  )),
            ],
          ));
    } else {
      throw Error();
    }
  }
}
