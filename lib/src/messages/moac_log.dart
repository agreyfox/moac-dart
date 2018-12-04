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

/// Moac log message
class MoacLog {
  MoacLog();

  MoacLog.fromMap(Map result) {
    construct(result);
  }

  /// Removed. True when the log was removed, due to a chain reorganization. false if its a valid log.
  bool _removed;

  bool get removed => _removed;

  /// Log index. The log index position in the block. Null when the log is pending.
  int _logIndex;

  int get logIndex => _logIndex;

  /// Transaction index. The transactions index position the log was created from. Null when the log is pending.
  int _transactionIndex;

  int get transactionIndex => _transactionIndex;

  /// Transaction hash. Hash of the transactions this log was created from. Null when the log is pending.
  BigInt _transactionHash;

  BigInt get transactionHash => _transactionHash;

  /// Block hash. Hash of the block where this log was in. Null when the log is pending.
  BigInt _blockHash;

  BigInt get blockHash => _blockHash;

  /// Block number. The block number of this log. Null when the log is pending.
  int _blockNumber;

  int get blockNumber => _blockNumber;

  /// Address. Address from which this log originated.
  BigInt _address;

  BigInt get address => _address;

  /// Data. Contains one or more 32 Bytes non-indexed arguments of the log.
  BigInt _data;

  BigInt get data => _data;

  /// Topics. List of 0 to 4 32 of indexed log arguments. (In solidity:
  /// The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)),
  /// except you declared the event with the anonymous specifier.)
  List<BigInt> _topics;

  List<BigInt> get topics => _topics;

  /// Construct from the supplied Map, only check for the keys we need.
  void construct(Map data) {
    if (data[moacResultKey] == null) {
      return;
    }
    if (data[moacResultKey].containsKey('removed')) {
      _removed = data[moacResultKey]['removed'];
    }
    if (data[moacResultKey].containsKey('logIndex')) {
      _logIndex = MoacUtilities.hexToInt(data[moacResultKey]['logIndex']);
    }
    if (data[moacResultKey].containsKey('transactionIndex')) {
      _transactionIndex =
          MoacUtilities.hexToInt(data[moacResultKey]['transactionIndex']);
    }
    if (data[moacResultKey].containsKey('transactionHash')) {
      _transactionHash =
          MoacUtilities.safeParse(data[moacResultKey]['transactionHash']);
    }
    if (data[moacResultKey].containsKey('blockHash')) {
      _blockHash = MoacUtilities.safeParse(data[moacResultKey]['blockHash']);
    }
    if (data[moacResultKey].containsKey('blockNumber')) {
      _blockNumber = MoacUtilities.hexToInt(data[moacResultKey]['blockNumber']);
    }
    if (data[moacResultKey].containsKey('address')) {
      _address = MoacUtilities.safeParse(data[moacResultKey]['address']);
    }
    if (data[moacResultKey].containsKey('data')) {
      _data = MoacUtilities.safeParse(data[moacResultKey]['data']);
    }
    if (data[moacResultKey].containsKey('topics')) {
      if ((data[moacResultKey]['topics'] != null) &&
          (data[moacResultKey]['topics'].isNotEmpty)) {
        _topics = List<BigInt>();
        for (String topic in data[moacResultKey]['topics']) {
          final BigInt entry = MoacUtilities.safeParse(topic);
          _topics.add(entry);
        }
      }
    }
  }

  // To string
  String toString() {
    final String ret = "Moac Log :" +
        "\n" +
        "  Removed : $removed" +
        "\n" +
        "  Log Index : $logIndex" +
        "\n" +
        "  Transaction Index : $transactionIndex" +
        "\n" +
        "  Transaction Hash: $transactionHash" +
        "\n" +
        "  Block Number: $blockNumber" +
        "\n" +
        "  Block Hash : $blockHash" +
        "\n" +
        "  Address : $address" +
        "\n";
    return ret;
  }
}
