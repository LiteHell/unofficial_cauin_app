import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:unofficial_cauin_app/cauColor.dart';
import 'package:unofficial_cauin_app/cauin/CauinCommentException.dart';
import 'package:unofficial_cauin_app/cauin/addCommentToArticle.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';
import 'package:unofficial_cauin_app/pages/cauinArticle/cauinArticlePage.dart';

class CauinArticleAddComment extends StatefulWidget {
  final CauinArticleItem article;
  const CauinArticleAddComment({super.key, required this.article});

  @override
  State<CauinArticleAddComment> createState() => _CauinArticleAddCommentState();
}

class _CauinArticleAddCommentState extends State<CauinArticleAddComment> {
  late CauinArticleItem article;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    article = widget.article;
  }

  void addComment() async {
    try {
      await addCommentToCauinArticle(article, _controller.text);
      final newArticle = await CauinSession().getArticle(article.url);
      Navigator.of(context).pop();
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return CauinArticlePage(article: newArticle);
      }));
    } on CauinCommentException catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('댓글 오류: ${err.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          minLines: 1,
          maxLines: 30,
          controller: _controller,
          decoration: const InputDecoration(
            hintText: '댓글 입력',
            labelText: '댓글',
            border: OutlineInputBorder(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
                onPressed: addComment,
                icon: Icon(Icons.add),
                label: Text('댓글 추가')),
          ],
        )
      ]),
    );
  }
}
