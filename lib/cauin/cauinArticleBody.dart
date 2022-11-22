import 'package:unofficial_cauin_app/cauin/cauinUser.dart';
import 'package:unofficial_cauin_app/pages/cauinArticle/cauinArticlePage.dart';

abstract class CauinArticleAbstractComment {}

class CauinArticleComment extends CauinArticleAbstractComment {
  final CauinUser _author;
  final String _content;
  final bool _isReply;
  final DateTime _commentedAt;
  final int _replyDepth;
  final int _replySort;
  final int _likes;
  final int _dislikes;
  CauinArticleComment(
      {required String content,
      required CauinUser author,
      required bool isReply,
      required int likes,
      required int dislikes,
      required DateTime commentedAt,
      required int replyDepth,
      required int replySort})
      : _content = content,
        _author = author,
        _isReply = isReply,
        _likes = likes,
        _dislikes = dislikes,
        _commentedAt = commentedAt,
        _replyDepth = replyDepth,
        _replySort = replySort;

  String get content => _content;
  CauinUser get author => _author;
  bool get isReply => _isReply;
  int get likes => _likes;
  int get dislikes => _dislikes;
  DateTime get commentedAt => _commentedAt;
  int get replyDepth => _replyDepth;
  int get replySort => _replySort;
}

class CauinArticleDeletedComment extends CauinArticleAbstractComment {}

class CauinArticleBody {
  final String content;
  final List<CauinArticleAbstractComment> comments;

  CauinArticleBody(this.content, this.comments);
}
