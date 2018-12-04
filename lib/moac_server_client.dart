/*
 * Package : moac
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 06/011/2017
 * Copyright :  S.Hamblett
 * Modified by Gao Ji Hua
 * Data: 2018/09/04
 *
 * An instance of moac specialised for use in the server.
 */

library moac_server_client;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:moac/moac.dart';

part 'src/adapters/moac_server_http_adapter.dart';

class MoacServerClient extends Moac {
  static MoacServerHTTPAdapter serverHttpAdapter = MoacServerHTTPAdapter();

  MoacServerClient() : super(serverHttpAdapter);

  MoacServerClient.withConnectionParameters(hostname, [port])
      : super.withConnectionParameters(
            serverHttpAdapter, hostname, Moac.rpcHttpScheme, port);
}
