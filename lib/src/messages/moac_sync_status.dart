/*
 * Package : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 08/01/2017
 * Copyright :  S.Hamblett
 * * Modified by Gao Ji Hua
 * Data: 2018/09/04
 * A JSON RPC 2.0 client for Moac
 */

part of moac;

/// Sync status message
class MoacSyncStatus {
  MoacSyncStatus();

  MoacSyncStatus.fromMap(Map result) {
    construct(result);
  }

  /// Syncing indicator, true if syncing
  bool _syncing = false;

  bool get syncing => _syncing;

  /// Starting block, only valid if syncing
  int _startingBlock;

  int get startingBlock => _startingBlock;

  /// Current block, only valid if syncing
  int _currentBlock;

  int get currentBlock => _currentBlock;

  /// Highest block, only valid if syncing
  int _highestBlock;

  int get highestBlock => _highestBlock;

  /// Construct from the supplied Map, only check for the keys we need.
  void construct(Map data) {
    if (!(data[moacResultKey] is bool)) {
      _syncing = true;
      if (data.containsKey('startingBlock')) {
        _startingBlock = MoacUtilities.hexToInt(data['startingBlock']);
      }
      if (data.containsKey('currentBlock')) {
        _currentBlock = MoacUtilities.hexToInt(data['currentBlock']);
      }
      if (data.containsKey('highestBlock')) {
        _highestBlock = MoacUtilities.hexToInt(data['highestBlock']);
      }
    }
  }

  // To string
  String toString() {
    String ret = "Moac Sync Status :" + "\n" + "  Syncing : $syncing" + "\n";
    if (syncing) {
      ret += "  Starting Block : $startingBlock" +
          "\n" +
          "  Current Block : $currentBlock" +
          "\n" +
          "  Highest Block : $highestBlock" +
          "\n";
    }

    return ret;
  }
}
