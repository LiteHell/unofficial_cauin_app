import 'dart:convert';

import 'package:unofficial_cauin_app/cauin/CauinCommentException.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';

Future addCommentToCauinArticle(
    CauinArticleItem article, String comment) async {
  final client = await CauinSession().getHttpClient();
  dynamic result = JsonCodec().decode(await client.postUrlencoded(
      Uri.https('cauin.cau.ac.kr', '/cauin/index.php/bbs/addComment'), {
    'content': comment,
    'tn': article.url.tableName,
    'ti': article.url.articleId.toString(),
    'depth': '0'
  }));

  if (result['result'] == false) {
    throw CauinCommentException('${result.msg}');
  }
}
