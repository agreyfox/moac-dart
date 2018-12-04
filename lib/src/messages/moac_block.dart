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

/// An Moac block descriptor message
class MoacBlock {
  MoacBlock();

  MoacBlock.fromMap(Map result) {
    construct(result);
  }

  /// The block number. Null when its a pending block.
  int _number;

  int get number => _number;

  /// Hash of the block. Null when its a pending block.
  BigInt _hash;

  BigInt get hash => _hash;

  /// Parent hash. Hash of the parent block.
  BigInt _parentHash;

  BigInt get parentHash => _parentHash;

  /// nonce. Hash of the generated proof-of-work. Null when its pending block.
  BigInt _nonce;

  BigInt get nonce => _nonce;

  /// Sha3 Uncles. SHA3 of the uncles data in the block.
  BigInt _sha3Uncles;

  BigInt get sha3Uncles => _sha3Uncles;

  /// Logs bloom. The bloom filter for the logs of the block. Null when its pending block.
  BigInt _logsBloom;

  BigInt get logsBloom => _logsBloom;

  /// Transactions root. The root of the transaction tree of the block.
  BigInt _transactionsRoot;

  BigInt get transactionsRoot => _transactionsRoot;

  /// State root. The root of the final state tree of the block.
  BigInt _stateRoot;

  BigInt get stateRoot => _stateRoot;

  /// Receipts root. The root of the receipts tree of the block.
  BigInt _receiptsRoot;

  BigInt get receiptsRoot => _receiptsRoot;

  /// Miner. The address of the beneficiary to whom the mining rewards were given.
  BigInt _miner;

  BigInt get miner => _miner;

  /// Difficulty. Integer of the difficulty for this block.
  int _difficulty;

  int get difficulty => _difficulty;

  /// Total difficulty. Integer of the total difficulty of the chain until this block.
  int _totalDifficulty;

  int get totalDifficulty => _totalDifficulty;

  /// Extra data. The "extra data" field of this block.
  BigInt _extraData;

  BigInt get extraData => _extraData;

  /// Size. Integer the size of this block in bytes.
  int _size;

  int get size => _size;

  /// Gas limit. The maximum gas allowed in this block.
  int _gasLimit;

  int get gasLimit => _gasLimit;

  /// Gas used. The total used gas by all transactions in this block.
  int _gasUsed;

  int get gasUsed => _gasUsed;

  /// Timestamp. The unix timestamp for when the block was collated.
  DateTime _timestamp;

  DateTime get timestamp => _timestamp;

  /// Transactions. A list of transaction objects, or 32 Bytes transaction hashes
  /// depending on the last given parameter.
  List<dynamic> _transactions;

  List<dynamic> get transactions => _transactions;

  /// Indicates if the transactions are hashes or transaction objects
  bool _transactionsAreHashes = false;

  bool get transactionsAreHashes => _transactionsAreHashes;

  /// Uncles. A list of uncle hashes.
  List<BigInt> _uncles;

  List<BigInt> get uncles => _uncles;

  /// Construct from the supplied Map, only check for the keys we need.
  void construct(Map data) {
    if ((data == null) || (data[moacResultKey] == null)) {
      return;
    }
    if (data[moacResultKey].containsKey('number')) {
      _number = MoacUtilities.hexToInt(data[moacResultKey]['number']);
    }
    if (data[moacResultKey].containsKey('hash')) {
      _hash = MoacUtilities.safeParse(data[moacResultKey]['hash']);
    }
    if (data[moacResultKey].containsKey('parentHash')) {
      _parentHash = MoacUtilities.safeParse(data[moacResultKey]['parentHash']);
    }
    if (data[moacResultKey].containsKey('nonce')) {
      _nonce = MoacUtilities.safeParse(data[moacResultKey]['nonce']);
    }
    if (data[moacResultKey].containsKey('sha3Uncles')) {
      _sha3Uncles = MoacUtilities.safeParse(data[moacResultKey]['sha3Uncles']);
    }
    if (data[moacResultKey].containsKey('logsBloom')) {
      _logsBloom = MoacUtilities.safeParse(data[moacResultKey]['logsBloom']);
    }
    if (data[moacResultKey].containsKey('transactionsRoot')) {
      _transactionsRoot =
          MoacUtilities.safeParse(data[moacResultKey]['transactionsRoot']);
    }
    if (data[moacResultKey].containsKey('stateRoot')) {
      _stateRoot = MoacUtilities.safeParse(data[moacResultKey]['stateRoot']);
    }
    if (data[moacResultKey].containsKey('receiptsRoot')) {
      _receiptsRoot =
          MoacUtilities.safeParse(data[moacResultKey]['receiptsRoot']);
    }
    if (data[moacResultKey].containsKey('miner')) {
      _miner = MoacUtilities.safeParse(data[moacResultKey]['miner']);
    }
    if (data[moacResultKey].containsKey('difficulty')) {
      _difficulty = MoacUtilities.hexToInt(data[moacResultKey]['difficulty']);
    }
    if (data[moacResultKey].containsKey('totalDifficulty')) {
      _totalDifficulty =
          MoacUtilities.hexToInt(data[moacResultKey]['totalDifficulty']);
    }
    if (data[moacResultKey].containsKey('extraData')) {
      _extraData = MoacUtilities.safeParse(data[moacResultKey]['extraData']);
    }
    if (data[moacResultKey].containsKey('size')) {
      _size = MoacUtilities.hexToInt(data[moacResultKey]['size']);
    }
    if (data[moacResultKey].containsKey('gasLimit')) {
      _gasLimit = MoacUtilities.hexToInt(data[moacResultKey]['gasLimit']);
    }
    if (data[moacResultKey].containsKey('gasUsed')) {
      _gasUsed = MoacUtilities.hexToInt(data[moacResultKey]['gasUsed']);
    }
    if (data[moacResultKey].containsKey('timestamp')) {
      _timestamp = DateTime.fromMillisecondsSinceEpoch(
          MoacUtilities.hexToInt(data[moacResultKey]['timestamp']));
    }
    if (data[moacResultKey].containsKey('uncles')) {
      _uncles = MoacUtilities.hexToBigIntList(data[moacResultKey]['uncles']);
    }
    if (data[moacResultKey].containsKey('transactions')) {
      if ((data[moacResultKey]['transactions'] != null) &&
          (data[moacResultKey]['transactions'].isNotEmpty)) {
        if (data[moacResultKey]['transactions'][0] is String) {
          // Hashes
          _transactionsAreHashes = true;
          _transactions = MoacUtilities.hexToBigIntList(
              data[moacResultKey]['transactions']);
        } else {
          // Transaction objects
          _transactions = List<MoacTransaction>();
          for (Map transaction in data[moacResultKey]['transactions']) {
            final Map buildTrans = {moacResultKey: transaction};
            final MoacTransaction entry = MoacTransaction.fromMap(buildTrans);
            _transactions.add(entry);
          }
        }
      }
    }
  }

  // To string
  String toString() {
    final String ret = "Moac Block :" +
        "\n" +
        "  Number : $number" +
        "\n" +
        "  Hash : $hash" +
        "\n" +
        "  Parent Hash : $parentHash" +
        "\n" +
        "  Miner : $miner" +
        "\n" +
        "  Difficulty : $difficulty" +
        "\n" +
        "  Gas Used : $gasUsed" +
        "\n" +
        "  Time : $timestamp" +
        "\n";
    return ret;
  }
}
