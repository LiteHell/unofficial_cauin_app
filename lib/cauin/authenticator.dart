import 'package:unofficial_cauin_app/cauin/httpClient.dart';
import 'package:html/parser.dart' show parse;

class _HtmlForm {
  final Map<String, String> _formData;
  final String _action;
  _HtmlForm(this._formData, this._action);

  Map<String, String> get formData => _formData;
  String get submitUrl => _action;
}

class CauinAuthenticator {
  static _HtmlForm parseForm(String html) {
    final form = parse(html).querySelector('form')!;
    final formData = Map.fromEntries(form.querySelectorAll('input').map((e) =>
        MapEntry<String, String>(
            e.attributes['name']!, e.attributes['value']!)));
    return _HtmlForm(formData, form.attributes['action']!);
  }

  static Future<void> parseFormAndSubmit(CauinHttpClient client, String html,
      [ignoreClientInit = false]) async {
    final form = parseForm(html);
    await client.postUrlencoded(
        Uri.parse(form.submitUrl), form.formData, ignoreClientInit);
  }

  static Future<void> loginAnonymous(CauinHttpClient client) async {
    final firstHttpResponse = await client.get(
        Uri.https('cauin.cau.ac.kr', '/cauin/index.php'), true);

    await parseFormAndSubmit(client, firstHttpResponse, true);
    await client.get(Uri.https('cauin.cau.ac.kr', '/cauin/index.php'), true);
  }

  static Future<void> login(CauinHttpClient client,
      {required String id, required String password}) async {
    final ssoResponse = await client.postUrlencoded(
        Uri.https('sso2.cau.ac.kr', '/SSO/AuthWeb/Logon.aspx',
            {'ssosite': 'cauin.cau.ac.kr'}),
        {
          'credType': 'BASIC',
          'retURL': 'http://cauin.cau.ac.kr/cauin/web/ssologin',
          'userID': id,
          'password': password
        });

    // LogonDomain
    final form = parseForm(ssoResponse);
    if (form.formData.containsKey('AUTHERR') &&
        form.formData['AUTHERR'] != '0') {
      // Wrong password or id
      throw Exception('Invalid credentials');
    }

    // NACookieManage
    await client.postUrlencoded(Uri.parse(form.submitUrl), form.formData);

    // Finish login
    await client.get(Uri.https('cauin.cau.ac.kr', '/cauin/web/sso/login'));
  }
}
