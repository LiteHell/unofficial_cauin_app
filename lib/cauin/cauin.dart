import 'dart:convert';
import 'package:cp949_codec/cp949_codec.dart';
import 'package:unofficial_cauin_app/cauin/authenticator.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleBody.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';
import 'package:unofficial_cauin_app/cauin/cauinBoard.dart';
import 'package:unofficial_cauin_app/cauin/cauinBoardArticleResult.dart';
import 'package:unofficial_cauin_app/cauin/cauinUser.dart';
import 'package:unofficial_cauin_app/cauin/httpClient.dart';
import 'package:unofficial_cauin_app/euckrPercentEncoding.dart';
import 'package:unofficial_cauin_app/widget/ArticleUrl.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

class CauinSession {
  final CauinHttpClient _client = CauinHttpClient();
  static final CauinSession _session = CauinSession._privateConstructor();
  var _initialized = false;
  var _anonymous = true;
  final _authChangeListeners = [() {}];

  bool get loggedIn => _initialized && !_anonymous;

  factory CauinSession() {
    return _session;
  }

  CauinSession._privateConstructor();

  Future<CauinHttpClient> getHttpClient() async {
    return _client;
  }

  Future<void> login({required String id, required String password}) async {
    await CauinAuthenticator.login(_client, id: id, password: password);
    _initialized = true;
    _anonymous = false;
    for (var e in _authChangeListeners) {
      e();
    }
  }

  Future<void> logout() async {
    await _client.clearCookies();
    await CauinAuthenticator.loginAnonymous(_client);
    _initialized = true;
    _anonymous = true;
    for (var e in _authChangeListeners) {
      e();
    }
  }

  void listenOnAuthChange(Null Function() func) {
    _authChangeListeners.add(func);
  }

  Future<Iterable<CauinArticleItem>> getPopularArticles() async {
    final httpResponse = await _client.get(
      Uri.https('cauin.cau.ac.kr', '/cauin/index.php'),
    );
    final parsedBody = parse(httpResponse);

    final ilNodes =
        parsedBody.body?.querySelectorAll('.contbox ul.popularity_list > li') ??
            [];
    return ilNodes.map(((e) {
      final link = e.querySelector('a')!.attributes['href']!;
      final title = e.querySelector('.offbox .txt')!.text;
      final category = e.querySelector('.offbox .category')!.text;
      final author = e.querySelector('.offbox .name')!.text;

      var views = -1, likes = -1, comments = -1;
      for (var li in e.querySelectorAll('.onbox li')) {
        if (li.querySelector('.view') != null)
          views = int.parse(li.nodes.last.text!);
        if (li.querySelector('.like') != null)
          likes = int.parse(li.nodes.last.text!);
        if (li.querySelector('.reply') != null)
          comments = int.parse(li.nodes.last.text!);
      }

      return CauinArticleItem(
          title: title,
          authorNickname: author,
          category: category,
          url: CauinArticleUrl.parseUrl(link),
          likes: likes,
          views: views,
          comments: comments);
    }));
  }

  Future<Iterable<CauinArticleItem>> getRecentArticles({int page = 1}) async {
    final responseText = await _client.postUrlencoded(
        Uri.https('cauin.cau.ac.kr', '/cauin/index.php/web/getTotalBbsList'),
        {'page': page.toString()});

    final response = json.decode(responseText) as List<dynamic>;
    /* response json format: 
     * [
     *    {
     *     CATEGORY1: string, // Category used for url, not for display
     *     NAME: string, // author name
     *     NUM: string(number),
     *     PRIMARYNUM: string(number) // article Id (ti)
     *     REGDATE: string(number), // Timestamp in seconds
     *     TABLENAME: string // tn parameter in article url
     *     TITLE: string
     *    }, ...
     * ]
     */
    return response.map((e) => CauinArticleItem(
        title: e['TITLE'],
        authorNickname: e['NAME'],
        category: CauinBoard.getDisplayName(e['TABLENAME'], e['CATEGORY1']),
        postedAt:
            DateTime.fromMillisecondsSinceEpoch(int.parse(e['REGDATE']) * 1000),
        url: CauinArticleUrl(
            articleId: int.parse(e['PRIMARYNUM']),
            innerCategory: e['CATEGORY1'],
            tableName: e['TABLENAME'])));
  }

  Future<CauinArticleItem> getArticle(CauinArticleUrl url) async {
    // RegExp patterns used for comment parsing
    final authorIdPattern = RegExp('msgfriendLayer\\(\'(.+?)\',');
    final replyDepthAndSortPattern = RegExp('\'([0-9]+)\',\'([0-9]+)\'\\);');

    // Get response, content, comments
    final response = parse(await _client.get(url.url));
    final content = response.querySelector('.contentbox')!.innerHtml;
    final List<CauinArticleAbstractComment> comments =
        response.querySelectorAll('.replybox .replylist > li').map((li) {
      if (li.querySelector('.infor') == null &&
          li.querySelector('.txt')?.text.trim() == '삭제된 댓글입니다.') {
        return CauinArticleDeletedComment();
      } else {
        final commentedAt =
            DateTime.parse(li.querySelector('.infor .date')!.text.trim());
        final nicknameNode = li.querySelector('.infor .nickname')!;
        final author = CauinUser(
            authorIdPattern
                .firstMatch(nicknameNode.attributes['onclick']!.trim())![1]!,
            nicknameNode.text.trim());
        final isReply = li.classes.contains('re');
        final replyDepthAndSortMatch = replyDepthAndSortPattern.firstMatch(li
            .querySelector('.infor .leftbox .etcbtn.reply')!
            .attributes['onclick']!)!;

        return CauinArticleComment(
            content: li.nodes
                .where((e) => (e.attributes['class'] ?? '').contains('txt'))
                .first
                .text!,
            author: author,
            isReply: isReply,
            likes: int.parse(
                li.querySelector('button.etcbtn.recomend > em')!.text.trim()),
            dislikes: int.parse(li
                .querySelector('button.etcbtn.nonerecomend > em')!
                .text
                .trim()),
            commentedAt: commentedAt,
            replyDepth: int.parse(replyDepthAndSortMatch[1]!),
            replySort: int.parse(replyDepthAndSortMatch[2]!));
      }
    }).toList();

    // Create body
    CauinArticleBody body = CauinArticleBody(content, comments);

    // Get article info
    final title = response.querySelector('.topbox h2.h2')!.text;
    final authorNode =
        response.querySelector('ul.detailinfor > li.id > .nickname')!;
    final author = CauinUser(
        authorIdPattern.firstMatch(authorNode.attributes['onclick']!)![1]!,
        authorNode.text);
    return CauinArticleItem(
      title: title,
      authorNickname: author.nickname,
      author: author,
      category: response.querySelector('.titlezone > h1.h1')!.text.trim(),
      url: url,
      body: body,
      comments: comments.where((e) => e is! CauinArticleDeletedComment).length,
      dislikes: int.parse(response
          .querySelector('ul.detailinfor > li.nonerecomend > em')!
          .text),
      likes: int.parse(
          response.querySelector('ul.detailinfor > li.recomend > em')!.text),
      postedAt: DateTime.parse(
          response.querySelector('ul.detailinfor > li.date > em')!.text),
      views: int.parse(
          response.querySelector('ul.detailinfor > li.view > em')!.text),
    );
  }

  CauinArticleItem _boardRowToItem(
      Element nonNoticeArticle, String displayCategory,
      [markAsNotice = false]) {
    final titleAnchor = nonNoticeArticle.querySelector('.link > a')!;
    final titleText = titleAnchor.querySelector('.alink')!.text;
    final authorDiv = nonNoticeArticle.querySelector('.detail > .id')!;
    final authorId = authorDiv.attributes['data-value']!;
    final authorName = authorDiv.text;

    // Parse views, likes
    int views =
        int.parse(nonNoticeArticle.querySelector('.view > em')!.text.trim());
    int likes =
        int.parse(nonNoticeArticle.querySelector('.like > em')!.text.trim());

    // Get article uri
    CauinArticleUrl uri =
        CauinArticleUrl.parseUrl(titleAnchor.attributes['href']!);

    // Parse comment count if exists
    final commentsNode = nonNoticeArticle.querySelector('strong.comment');
    int? comments;
    if (commentsNode != null) {
      commentsNode.querySelector('.hidden')?.remove();
      comments = int.parse(commentsNode.text.trim());
    }

    // Parse article date
    // article date is in YY.MM.DD format
    final datePattern = RegExp(r'([0-9]{2})\.([0-9]{2})\.([0-9]{2})');
    final dateMatch = datePattern
        .firstMatch(nonNoticeArticle.querySelector('.date')!.text.trim())!;
    final date = DateTime(2000 + int.parse(dateMatch[1]!),
        int.parse(dateMatch[2]!), int.parse(dateMatch[3]!));

    // Add result
    return (CauinArticleItem(
        title: titleText.trim(),
        authorNickname: authorName.trim(),
        author: CauinUser(authorId, authorName),
        category: displayCategory,
        views: views,
        likes: likes,
        comments: comments,
        postedAt: date,
        isReply: nonNoticeArticle.classes.contains('reply'),
        url: uri,
        isNotice: markAsNotice));
  }

  Future<CauinBoardArticleList> getArticlesFromBoard(
    CauinBoard board, {
    DateTime? startsFrom,
    DateTime? endsAt,
    BoardQueryType queryType = BoardQueryType.all,
    String? query,
    int page = 1,
  }) async {
    // Utils to create uri
    final formatDateQuery = (DateTime dateTime) =>
        '${dateTime.year.toString()}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
    final stValues = {
      BoardQueryType.all: '',
      BoardQueryType.content: 'body',
      BoardQueryType.author: 'name',
      BoardQueryType.title: 'title'
    };

    // Create uri
    final now = DateTime.now();
    final cateEncoded =
        board.category != null ? eucKrEncodeUri(board.category!) : '';
    final boardUri =
        Uri.parse(Uri.https('cauin.cau.ac.kr', '/cauin/bbs/bbs_list', {
              'page': page.toString(),
              'tn': board.tableName,
              'end_at': formatDateQuery(endsAt ?? now),
              'start_at': formatDateQuery(
                  startsFrom ?? DateTime(now.year - 1, now.month, now.day)),
              'st': stValues[queryType],
              'sw': query ?? ''
            }).toString() +
            '&cate=$cateEncoded');

    // Get
    final document = parse(await _client.get(boardUri));

    // Parse lastPage
    final lastPagePattern = RegExp('page=([0-9]+)');
    final lastPage = int.parse(lastPagePattern.firstMatch(
        document.querySelector('p.allnext > a')!.attributes['href']!)![1]!);

    // Parse results
    List<CauinArticleItem> result = [];
    result.addAll(document
        .querySelectorAll('tbody#bbs_notice_list > tr')
        .map((e) => _boardRowToItem(e, board.displayName, true)));
    result.addAll(document
        .querySelectorAll('tbody#bbs_list > tr')
        .map((e) => _boardRowToItem(e, board.displayName)));

    return CauinBoardArticleList(result, lastPage);
  }
}

enum BoardQueryType { title, content, author, all }
