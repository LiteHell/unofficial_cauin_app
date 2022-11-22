import 'package:unofficial_cauin_app/cauin/cauinArticleBody.dart';
import 'package:unofficial_cauin_app/cauin/cauinUser.dart';
import 'package:unofficial_cauin_app/widget/ArticleUrl.dart';

/// Article item of Cauin
///
/// This class contains title, author, category, and article Id.
class CauinArticleItem {
  final String _title;
  final String _authorNickname;
  final CauinUser? _author;
  final String _category;
  final int? _likes;
  final int? _dislikes;
  final int? _views;
  final int? _comments;
  final DateTime? _postedAt;
  final CauinArticleUrl _articleUrl;
  final CauinArticleBody? _body;
  final bool _isReply;
  final bool _isNotice;
  CauinArticleItem(
      {required String title,
      required String authorNickname,
      required String category,
      required CauinArticleUrl url,
      DateTime? postedAt,
      int? likes,
      CauinUser? author,
      int? dislikes,
      int? views,
      CauinArticleBody? body,
      int? comments,
      bool isReply = false,
      bool isNotice = false})
      : _title = title.trimLeft(),
        _articleUrl = url,
        _category = category,
        _authorNickname = authorNickname,
        _likes = likes,
        _dislikes = dislikes,
        _views = views,
        _author = author,
        _comments = comments,
        _body = body,
        _postedAt = postedAt,
        _isReply = isReply,
        _isNotice = isNotice;

  String get title => _title;
  String get authorNickname => _authorNickname;
  String get category => _category;
  int? get likes => _likes;
  int? get dislikes => _dislikes;
  int? get views => _views;
  int? get comments => _comments;
  CauinArticleUrl get url => _articleUrl;
  DateTime? get postedAt => _postedAt;
  CauinUser? get author => _author;
  CauinArticleBody? get body => _body;
  bool get isReply => _isReply;
  bool get isNotice => _isNotice;
}
