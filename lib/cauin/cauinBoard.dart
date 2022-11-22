class CauinBoard {
  final String? _category;
  final String _tableName;
  final String _displayName;
  final bool _unused;

  const CauinBoard._privateConstructor(
      this._unused, this._displayName, this._tableName,
      [this._category]);
  const CauinBoard.notice() : this._privateConstructor(false, '공지사항', 'cafe37');
  const CauinBoard.free()
      : this._privateConstructor(false, '청룡광장', 'cafe42', '자유');
  const CauinBoard.job()
      : this._privateConstructor(false, '취업/고시/진로', 'cafe42', '취고진');

  // 생활정보
  const CauinBoard.lostAndFound()
      : this._privateConstructor(false, '분실물센터', 'cafe20');
  const CauinBoard.market() : this._privateConstructor(false, '벼룩시장', 'cafe18');
  const CauinBoard.alba() : this._privateConstructor(false, '아르바이트', 'cafe21');
  const CauinBoard.house() : this._privateConstructor(false, '주거정보', 'house');

  // 이전게시판
  const CauinBoard.humor() : this._privateConstructor(true, '유머게시판', 'cafe30');
  const CauinBoard.best() : this._privateConstructor(true, '명예의 전당', 'cafe25');
  const CauinBoard.cauGallery()
      : this._privateConstructor(true, 'CAU갤러리', 'cafe04');
  const CauinBoard.food() : this._privateConstructor(true, '맛집/상권', 'food');
  const CauinBoard.lecture()
      : this._privateConstructor(true, '강의정보', 'cafe42', '강의');
  const CauinBoard.study()
      : this._privateConstructor(true, '스터디', 'cafe42', '강의');
  const CauinBoard.compeititions()
      : this._privateConstructor(true, '공모전', 'cafe42', '강의');
  const CauinBoard.studyAndAcademicAffairs()
      : this._privateConstructor(true, '학사학업', 'cafe42', '강의');

  static String getDisplayName(String tableName, String? categoryName) {
    const boards = [
      CauinBoard.alba(),
      CauinBoard.best(),
      CauinBoard.cauGallery(),
      CauinBoard.compeititions(),
      CauinBoard.food(),
      CauinBoard.free(),
      CauinBoard.house(),
      CauinBoard.humor(),
      CauinBoard.job(),
      CauinBoard.lecture(),
      CauinBoard.lostAndFound(),
      CauinBoard.market(),
      CauinBoard.notice(),
      CauinBoard.study(),
      CauinBoard.studyAndAcademicAffairs()
    ];

    for (final board in boards) {
      if (board.tableName == tableName && board.category == categoryName) {
        return board.displayName;
      }
    }

    throw Exception('Not found');
  }

  String? get category => _category;
  String get tableName => _tableName;
  String get displayName => _displayName;
  bool get unused => _unused;
}
