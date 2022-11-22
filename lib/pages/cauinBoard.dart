import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';
import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';
import 'package:unofficial_cauin_app/cauin/cauinBoard.dart';
import 'package:unofficial_cauin_app/cauin/cauinBoardArticleResult.dart';
import 'package:unofficial_cauin_app/widget/ArticleItemListTile.dart';
import 'package:unofficial_cauin_app/widget/CauinDrawer.dart';

class CauinBoardPage extends StatefulWidget {
  final CauinBoard board;
  final DateTime? startsFrom;
  final DateTime? endsAt;
  final BoardQueryType? queryType;
  final String? query;
  final int? startPage;
  const CauinBoardPage({
    super.key,
    required this.board,
    this.startsFrom,
    this.endsAt,
    this.query,
    this.queryType,
    this.startPage = 1,
  });

  @override
  State<CauinBoardPage> createState() => _CauinBoardPageState();
}

class _CauinBoardPageState extends State<CauinBoardPage> {
  List<CauinArticleItem> articles = [];
  int _pagesLoaded = 0;
  int? _lastPage;
  bool _loading = false;
  bool _reachedEnd = false;
  bool _automaticSearchOlderDate = false;

  @override
  void initState() {
    super.initState();
    final widget = context.widget as CauinBoardPage;
    _automaticSearchOlderDate =
        widget.startsFrom == null && widget.endsAt == null;
    _pagesLoaded = (widget.startPage ?? 1) - 1;
    _loadPage();
  }

  void _loadPage() {
    if (_loading) {
      // Do not load when loading
      return;
    } else if (_reachedEnd ||
        (_lastPage != null && _lastPage! <= _pagesLoaded)) {
      // Do not load when reached end
      if (!_reachedEnd) {
        setState(_markEndPage);
      }
      return;
    }
    _loading = true;
    final widget = (context.widget as CauinBoardPage);
    CauinSession()
        .getArticlesFromBoard(widget.board,
            endsAt: widget.endsAt,
            page: _pagesLoaded + 1,
            query: widget.query,
            queryType: widget.queryType ?? BoardQueryType.all,
            startsFrom: widget.startsFrom)
        .then(_whenPagesLoaded);
  }

  void _markEndPage() {
    _reachedEnd = true;
    _loading = false;
  }

  void _whenPagesLoaded(CauinBoardArticleList result) {
    setState(() {
      _lastPage = result.lastPage;
      articles.addAll(result.articles);
      _pagesLoaded++;
      if (_lastPage! <= _pagesLoaded) {
        _reachedEnd = true;
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final board = (context.widget as CauinBoardPage).board;
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent) {
        _loadPage();
      }
    });

    return Scaffold(
        appBar: AppBar(title: Text(board.displayName)),
        body: ListView(
          controller: controller,
          children: [
            if (articles.isNotEmpty)
              ...ListTile.divideTiles(
                  tiles: articles
                      .map((item) => CauinArticleItemToListTile(item, context)),
                  context: context),
            if (_reachedEnd)
              const ListTile(
                title: Center(child: Text('마지막 페이지입니다.')),
              )
            else
              const ListTile(
                title: Center(child: CircularProgressIndicator()),
              )
          ],
        ),
        drawer: cauinDrawer());
  }
}
