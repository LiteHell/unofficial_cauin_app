import 'package:unofficial_cauin_app/cauin/cauinArticleItem.dart';

class CauinBoardArticleList {
  final Iterable<CauinArticleItem> _items;
  final int _lastPage;

  CauinBoardArticleList(this._items, this._lastPage);

  Iterable<CauinArticleItem> get articles => _items;
  int get lastPage => _lastPage;
}
