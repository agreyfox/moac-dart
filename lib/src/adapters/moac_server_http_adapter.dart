/*
 * Packge : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 10/011/2017
 * Copyright :  S.Hamblett
 * * Modified by Gao Ji Hua
 * Data: 2018/09/04
 * Provides a common interface for Moac to connect over HTTP
 * on the server.
 */

part of moac_server_client;

class MoacServerHTTPAdapter implements MoacINetworkAdapter {
  /// The HTTP client
  HttpClient _client = HttpClient();

  static const String jsonMimeType = 'application/json';

  /// Processes the HTTP request returning the  HTTP response as
  /// a map
  Future<Map> httpRequest(Uri uri, Map request) {
    final completer = Completer<Map>();
    _client.postUrl(uri).then((HttpClientRequest req) {
      final payload = json.encode(request);
      req.headers.add(HttpHeaders.contentTypeHeader, jsonMimeType);
      req.contentLength = payload.length;
      req.write(payload);
      req.close().then((HttpClientResponse resp) {
        resp.listen((data) {
          final Map payload = json.decode(String.fromCharCodes( data));
          completer.complete(payload);
        }, onError: (e) {
          print(e);
        }, onDone: () {
          _client.close();
        });
      });
    }, onError: (e) {
      print(e);
    });
    return completer.future;
  }
}
