import 'package:unofficial_cauin_app/cauin/cauinBoard.dart';

class CauinArticleUrl {
  late final String? _innerCategory;
  late final String _tableName;
  late final int _id;

  CauinArticleUrl(
      {String? innerCategory,
      required String tableName,
      required int articleId})
      : _innerCategory = innerCategory,
        _tableName = tableName,
        _id = articleId;

  CauinArticleUrl.parseUrl(String url) {
    final urlParsed = Uri.parse(url);
    if (['tn', 'ti'].any((e) => !urlParsed.queryParameters.containsKey(e))) {
      throw Exception('Invalid article url to be parsed');
    }
    _tableName = urlParsed.queryParameters['tn']!;
    _innerCategory = urlParsed.queryParameters['cate'];
    _id = int.parse(urlParsed.queryParameters['ti']!);
  }

  Uri get url => Uri.https('cauin.cau.ac.kr', '/cauin/bbs/bbs_show', {
        'tn': _tableName,
        'ti': _id.toString(),
        'cate': _innerCategory.toString()
      });

  String get displayCategory =>
      CauinBoard.getDisplayName(_tableName, _innerCategory);
}
