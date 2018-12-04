/*
 * Package : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 03/11/2017
 * Copyright :  S.Hamblett
 */

@TestOn("vm")
import 'package:moac/moac_server_client.dart';
import 'package:test/test.dart';
import 'moac_common.dart';

void main() {
  if (MoacTestConfiguration.runServer) {
    // Run the common API tests
    final MoacServerClient client =
        MoacServerClient.withConnectionParameters("localhost");
    // Print errors
    client.printError = true;
    MoacCommon.run(client);
  } else {
    print("Server tests not selected");
  }
}

class MoacTestConfiguration {
  static BigInt defaultAccount =
      BigInt.parse("0xd10de988e845d33859c3f96c7f1fc723b7b56f4c");

  /// True runs the browser HTTP tests, you will need CORS support for this as above
  static bool runBrowserHttp = false;

  /// True runs the browser WS tests, you should be OK with --wsorigins as above
  static bool runBrowserWS = true;

  /// True runs the server tests
  static bool runServer = true;
}
