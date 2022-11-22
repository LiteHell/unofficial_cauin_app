import 'dart:async';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'dart:io';
import 'package:cp949_codec/cp949_codec.dart';
import 'package:flutter/foundation.dart';
import 'package:unofficial_cauin_app/cauin/authenticator.dart';

class CauinHttpClient {
  final _userAgent = 'Mozilla/5.0 (compatible; Unofficial-cauin-app/0.1)';
  final _cookies = CookieJar();
  final _innerClient = HttpClient();
  final utf8 = Encoding.getByName('UTF-8')!;
  var _intiialized = false;

  CauinHttpClient() {
    CauinAuthenticator.loginAnonymous(this).then((a) {
      _intiialized = true;
    });
  }

  Future _waitUntilInitialization() async {
    if (!_intiialized) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 200));
        return !_intiialized;
      });
    }
  }

  Future clearCookies() async {
    await _cookies.deleteAll();
  }

  Future<String> parseResponse(HttpClientResponse response) async {
    final charset =
        response.headers.contentType?.charset?.toUpperCase() ?? 'UTF-8';
    final decoder = Encoding.getByName(charset)?.decoder;
    if (decoder == null && charset != "EUC-KR") {
      throw UnsupportedError('Unsupported encoding');
    }
    final useCp949Codec = decoder == null && charset == "EUC-KR";

    if (useCp949Codec) {
      final Completer<String> completer = Completer();
      List<int> data = [];
      response.listen((chunk) {
        data.addAll(chunk);
      }, onDone: () {
        try {
          completer.complete(cp949.decode(data));
        } catch (err) {
          completer.completeError(err);
        }
      });
      return completer.future;
    } else {
      return await response.transform(decoder!).join();
    }
  }

  Future<String> get(Uri url, [ignoreWaitForInitialization = false]) async {
    if (!ignoreWaitForInitialization) {
      await _waitUntilInitialization();
    }
    // Open request and set User-Agent, Cookies, Encoding
    // Follow redirects if needed
    final request = await _innerClient.getUrl(url);
    request.cookies.addAll(await _cookies.loadForRequest(url));
    request.followRedirects = true;
    request.headers.add('user-agent', _userAgent);

    // Open response
    final response = await request.close();

    // Get final url for cookie saving, and save cookies
    final finalUrl =
        response.isRedirect ? response.redirects.last.location : url;
    _cookies.saveFromResponse(finalUrl, response.cookies);

    // Return response as string
    return parseResponse(response);
  }

  Future<String> postUrlencoded(Uri url, Map<String, String> data,
      [ignoreWaitForInitialization = false]) async {
    if (!ignoreWaitForInitialization) {
      await _waitUntilInitialization();
    }
    // Open request and set Cookies, Content-Type, User-Agent, Encoding
    // Follow redirects if needed
    final request = await _innerClient.postUrl(url);
    request.cookies.addAll(await _cookies.loadForRequest(url));
    request.followRedirects = true;
    request.headers.contentType =
        ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
    request.headers.add('user-agent', _userAgent);

    // Serialize formData
    final serialized = data.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    // Write serialized formData
    request.write(serialized);
    await request.flush();

    // Open response and save cookies
    final response = await request.close();
    final finalUrl =
        response.isRedirect ? response.redirects.last.location : url;
    _cookies.saveFromResponse(finalUrl, response.cookies);

    // Return response as string
    return parseResponse(response);
  }
}
