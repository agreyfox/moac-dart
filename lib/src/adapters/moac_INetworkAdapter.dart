/*
 * Packge : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 10/011/2017
 * Copyright :  S.Hamblett
 * * Modified by Gao Ji Hua
 * Data: 2018/09/04
 * Provides a common interface for Moac to connect over HTTP,
 * allowing for different HTTP adapters to be used.
 */

part of moac;

abstract class MoacINetworkAdapter {
  MoacINetworkAdapter();

  /// Processes the HTTP request returning the  HTTP response as
  /// a map
  Future<Map> httpRequest(Uri uri, Map request);
}
