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

/// An Moac transaction message
class MoacTransaction {
  MoacTransaction();

  MoacTransaction.fromMap(Map result) {
    construct(result);
  }

  /// Hash. hash of the transaction.
  BigInt _hash;

  BigInt get hash => _hash;

  /// Nonce. The number of transactions made by the sender prior to this one.
  int _nonce;

  int get nonce => _nonce;

  /// Block hash. Hash of the block where this transaction was in.
  /// Null when the transaction is pending.
  BigInt _blockHash;

  BigInt get blockHash => _blockHash;

  /// Block number. Block number of this transaction.
  /// Null when the transaction is pending.
  int _blockNumber;

  int get blockNumber => _blockNumber;

  /// Transaction index. The transactions index position in the block.
  /// Null when the transaction is pending.
  int _transactionIndex;

  int get transactionIndex => _transactionIndex;

  /// From. Address of the sender.
  BigInt _from;

  BigInt get from => _from;

  /// To. Address of the receiver. Null when a contract creation transaction.
  BigInt _to;

  BigInt get to => _to;

  /// Value. Value transferred in Wei.
  int _value;

  int get value => _value;

  /// Gas price. Gas price provided by the sender in Wei.
  int _gasPrice;

  int get gasPrice => _gasPrice;

  /// Gas. Gas provided by the sender.
  int _gas;

  int get gas => _gas;

  /// Input. Data sent with the transaction.
  BigInt _input;

  BigInt get input => _input;

  /// Construct from the supplied Map, only check for the keys we need.
  void construct(Map data) {
    if ((data == null) || (data[moacResultKey] == null)) {
      return;
    }
    if (data[moacResultKey].containsKey('hash')) {
      _hash = MoacUtilities.safeParse(data[moacResultKey]['hash']);
    }
    if (data[moacResultKey].containsKey('nonce')) {
      _nonce = MoacUtilities.hexToInt(data[moacResultKey]['nonce']);
    }
    if (data[moacResultKey].containsKey('blockHash')) {
      _blockHash = MoacUtilities.safeParse(data[moacResultKey]['blockHash']);
    }
    if (data[moacResultKey].containsKey('blockNumber')) {
      _blockNumber = MoacUtilities.hexToInt(data[moacResultKey]['blockNumber']);
    }
    if (data[moacResultKey].containsKey('transactionIndex')) {
      _transactionIndex =
          MoacUtilities.hexToInt(data[moacResultKey]['transactionIndex']);
    }
    if (data[moacResultKey].containsKey('from')) {
      _from = MoacUtilities.safeParse(data[moacResultKey]['from']);
    }
    if (data[moacResultKey].containsKey('to')) {
      _to = MoacUtilities.safeParse(data[moacResultKey]['to']);
    }
    if (data[moacResultKey].containsKey('value')) {
      _value = MoacUtilities.hexToInt(data[moacResultKey]['value']);
    }
    if (data[moacResultKey].containsKey('gasPrice')) {
      _gasPrice = MoacUtilities.hexToInt(data[moacResultKey]['gasPrice']);
    }
    if (data[moacResultKey].containsKey('gas')) {
      _gas = MoacUtilities.hexToInt(data[moacResultKey]['gas']);
    }
    if (data[moacResultKey].containsKey('input')) {
      _input = MoacUtilities.safeParse(data[moacResultKey]['input']);
    }
  }

  // To string
  String toString() {
    final String ret = "Moac Transaction :" +
        "\n" +
        "  Hash : $hash" +
        "\n" +
        "  Block Number: $blockNumber" +
        "\n" +
        "  Block Hash : $blockHash" +
        "\n" +
        "  Transaction Index : $transactionIndex" +
        "\n" +
        "  From : $from" +
        "\n" +
        "  To : $to " +
        "\n" +
        "  Value : $value" +
        "\n" +
        "  Gas : $gas" +
        "\n";

    return ret;
  }
}
