import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';
import 'package:unofficial_cauin_app/cauin/cauinBoard.dart';
import 'package:unofficial_cauin_app/pages/cauinBoard.dart';
import 'package:unofficial_cauin_app/pages/cauinPopularArticles.dart';
import 'package:unofficial_cauin_app/pages/cauinRecentArticles.dart';
import 'package:unofficial_cauin_app/pages/loginPage.dart';

import '../cauColor.dart';

class cauinDrawer extends StatefulWidget {
  const cauinDrawer({super.key});

  @override
  State<cauinDrawer> createState() => _cauinDrawerState();
}

class _cauinDrawerState extends State<cauinDrawer> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _loggedIn = CauinSession().loggedIn;
    CauinSession().listenOnAuthChange(() {
      if (mounted)
        setState(() {
          _loggedIn = CauinSession().loggedIn;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: cauBlue),
          child: Text('중앙인'),
        ),
        ListTile(
            title: _loggedIn ? const Text('로그아웃') : const Text('로그인'),
            leading:
                _loggedIn ? const Icon(Icons.logout) : const Icon(Icons.login),
            onTap: () {
              if (CauinSession().loggedIn) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                      content: Row(children: const [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator()),
                    Text('로그아웃중입니다...')
                  ])),
                );
                CauinSession().logout().then((a) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CauinLoginPage()));
              }
            }),
        const Divider(),
        ListTile(
          title: const Text('인기 글'),
          leading: const Icon(
            Icons.local_fire_department,
            semanticLabel: '인기 글',
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => CauinPopularArticle())));
          },
        ),
        ListTile(
          title: const Text('최근 글'),
          leading: const Icon(
            Icons.autorenew,
            semanticLabel: '최근 글',
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => CauinRecentArticles())));
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('공지사항'),
          leading: const Icon(
            Icons.announcement,
            semanticLabel: '공지사항',
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const CauinBoardPage(
                      board: CauinBoard.notice(),
                    ))));
          },
        ),
        ListTile(
          title: const Text('청룡광장'),
          leading: const Icon(
            Icons.park,
            semanticLabel: '청룡광장',
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const CauinBoardPage(
                      board: CauinBoard.free(),
                    ))));
          },
        ),
        ListTile(
          title: const Text('취업/고시/진로'),
          leading: const Icon(
            Icons.work,
            semanticLabel: '취업/고시/진로',
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const CauinBoardPage(
                      board: CauinBoard.job(),
                    ))));
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('분실물센터'),
          leading: const Icon(
            Icons.question_mark,
            semanticLabel: '분실물센터',
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const CauinBoardPage(
                      board: CauinBoard.lostAndFound(),
                    ))));
          },
        ),
        ListTile(
          title: const Text('벼룩시장'),
          leading: const Icon(
            Icons.shopping_cart,
            semanticLabel: '벼룩시장',
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const CauinBoardPage(
                      board: CauinBoard.market(),
                    ))));
          },
        ),
        ListTile(
          title: const Text('아르바이트'),
          leading: const Icon(
            Icons.attach_money,
            semanticLabel: '아르바이트',
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const CauinBoardPage(
                      board: CauinBoard.alba(),
                    ))));
          },
        ),
        /*ListTile(
          title: const Text('주거정보'),
          leading: const Icon(
            Icons.house,
            semanticLabel: '주거정보',
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const CauinBoardPage(
                      board: CauinBoard.house(),
                    ))));
          },
        ),*/
      ],
    ));
  }
}
