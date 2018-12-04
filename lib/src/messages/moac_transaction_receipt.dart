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

/// An moac transaction receipt message
class MoacTransactionReceipt {
  MoacTransactionReceipt();

  MoacTransactionReceipt.fromMap(Map result) {
    construct(result);
  }

  /// Transaction hash. Hash of the transaction.
  BigInt _transactionHash;

  BigInt get transactionHash => _transactionHash;

  /// Transaction index. Ihe transactions index position in the block.
  int _transactionIndex;

  int get transactionIndex => _transactionIndex;

  /// Block hash. Hash of the block this transaction was in.
  BigInt _blockHash;

  BigInt get blockHash => _blockHash;

  /// Block number. Block number of this transaction.
  int _blockNumber;

  int get blockNumber => _blockNumber;

  /// Cumulative gas used. The total amount of gas used when this transaction was executed in the block.
  int _cumulativeGasUsed;

  int get cumulativeGasUsed => _cumulativeGasUsed;

  /// Gas used. The amount of gas used by this transaction.
  int _gasUsed;

  int get gasUsed => _gasUsed;

  /// Contract address. The contract address created, if the transaction was a contract creation, otherwise null.
  BigInt _contractAddress;

  BigInt get contractAddress => _contractAddress;

  /// Logs. List of log objects, which this transaction generated.
  List<MoacLog> _logs;

  List<MoacLog> get logs => _logs;

  /// Logs bloom. Bloom filter for light clients to quickly retrieve related logs.
  BigInt _logsBloom;

  BigInt get logsBloom => _logsBloom;

  /// Root. Post-transaction stateroot (pre Byzantium)
  /// Null if status is present.
  BigInt _root;

  BigInt get root => _root;

  /// Status. Either 1 (success) or 0 (failure)
  /// Null if root is present
  int _status;

  int get status => _status;

  /// Construct from the supplied Map, only check for the keys we need.
  void construct(Map data) {
    if ((data == null) || (data[moacResultKey] == null)) {
      return;
    }
    if (data[moacResultKey].containsKey('transactionHash')) {
      _transactionHash =
          MoacUtilities.safeParse(data[moacResultKey]['transactionHash']);
    }
    if (data[moacResultKey].containsKey('transactionIndex')) {
      _transactionIndex =
          MoacUtilities.hexToInt(data[moacResultKey]['transactionIndex']);
    }
    if (data[moacResultKey].containsKey('blockHash')) {
      _blockHash = MoacUtilities.safeParse(data[moacResultKey]['blockHash']);
    }
    if (data[moacResultKey].containsKey('blockNumber')) {
      _blockNumber = MoacUtilities.hexToInt(data[moacResultKey]['blockNumber']);
    }
    if (data[moacResultKey].containsKey('cumulativeGasUsed')) {
      _cumulativeGasUsed =
          MoacUtilities.hexToInt(data[moacResultKey]['cumulativeGasUsed']);
    }
    if (data[moacResultKey].containsKey('gasUsed')) {
      _gasUsed = MoacUtilities.hexToInt(data[moacResultKey]['gasUsed']);
    }
    if (data[moacResultKey].containsKey('contractAddress')) {
      _contractAddress =
          MoacUtilities.safeParse(data[moacResultKey]['contractAddress']);
    }
    if (data[moacResultKey].containsKey('logsBloom')) {
      _logsBloom = MoacUtilities.safeParse(data[moacResultKey]['logsBloom']);
    }
    if (data[moacResultKey].containsKey('root')) {
      _root = MoacUtilities.safeParse(data[moacResultKey]['root']);
    }
    if (data[moacResultKey].containsKey('status')) {
      _status = MoacUtilities.hexToInt(data[moacResultKey]['status']);
    }
    if (data[moacResultKey].containsKey('logs')) {
      if ((data[moacResultKey]['logs'] != null) &&
          (data[moacResultKey]['logs'].isNotEmpty)) {
        _logs = List<MoacLog>();
        for (Map log in data[moacResultKey]['logs']) {
          final Map buildLog = {moacResultKey: log};
          final MoacLog entry = MoacLog.fromMap(buildLog);
          _logs.add(entry);
        }
      }
    }
  }

  // To string
  String toString() {
    final String ret = "Moac Transaction Receipt:" +
        "\n" +
        "  Transaction Hash : $transactionHash" +
        "\n" +
        "  Block Number: $blockNumber" +
        "\n" +
        "  Block Hash : $blockHash" +
        "\n" +
        "  Transaction Index : $transactionIndex" +
        "\n" +
        "  Contract Address : $contractAddress" +
        "\n" +
        "  Gas used : $gasUsed" +
        "\n";

    return ret;
  }
}
