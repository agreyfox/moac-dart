/*
 * Package : Moac
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 08/01/2017
 * Copyright :  S.Hamblett
 * * Modified by Gao Ji Hua
 * Data: 2018/09/04
 * A JSON RPC 2.0 client for Moac
 */

part of moac;

/// Filter message
/// For filters created with newBlockFilter the object contains block hashes.
/// For filters created with pendingTransactionFilter the class contains transaction hashes.
/// For filters created with newFilter or getFilterChanges the class contains logs
/// which are are MoacLog objects.
class MoacFilter {
  MoacFilter();

  MoacFilter.fromMap(Map result) {
    construct(result);
  }

  /// Hashes, block or transaction
  List<BigInt> _hashes;

  List<BigInt> get hashes => _hashes;

  /// Logs
  List<MoacLog> _logs;

  List<MoacLog> get logs => _logs;

  /// Moac log objects, returned by
  /// Construct from the supplied Map, only check for the keys we need.
  void construct(Map data) {
    if (data[moacResultKey] == null) {
      return;
    }
    if (data[moacResultKey].isNotEmpty) {
      if (data[moacResultKey][0] is String) {
        // Hashes
        _hashes = MoacUtilities.hexToBigIntList(data[moacResultKey]);
      } else {
        // Logs
        _logs = List<MoacLog>();
        for (Map log in data[moacResultKey]) {
          final Map buildLog = {moacResultKey: log};
          final MoacLog entry = MoacLog.fromMap(buildLog);
          _logs.add(entry);
        }
      }
    }
  }
}
