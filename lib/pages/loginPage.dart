import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:unofficial_cauin_app/cauColor.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';

class CauinLoginPage extends StatelessWidget {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  CauinLoginPage({super.key});

  void Function() onLoginButtonPressed(context) {
    return () async {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                content: Row(children: const [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('로그인중입니다...'),
                  )
                ]),
              )));
      try {
        await CauinSession()
            .login(id: _idController.text, password: _passwordController.text);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('로그인됐습니다.')));
      } catch (err) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('로그인 실패습니다.', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 165, 28, 18),
        ));
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                  controller: _idController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '아이디',
                      hintText: '아이디')),
              TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '비밀번호',
                      hintText: '비밀번호')),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                      onPressed: onLoginButtonPressed(context),
                      icon: const Icon(Icons.login),
                      label: const Text('로그인'))
                ],
              )
            ]
                .map((e) => Padding(padding: EdgeInsets.all(10), child: e))
                .toList(),
          )),
    );
  }
}
