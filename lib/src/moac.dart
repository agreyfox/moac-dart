/*
 * Package : Moac 
 * Copy from ethreurm package
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Modified By Gao Ji Hua
 * Date   : 2018/09/03
 *
 * The Moac client package
 */

part of moac;

/// The Moac JSON-RPC client class.
/// Further details of this interface and its API specification can be found at
/// https://github.com/Moac/wiki/wiki/JSON-RPC#web3_clientversion.
/// The API calls return null if an Moac error occurred.
class Moac {
  Moac(this._networkAdapter) {
    rpcClient = MoacRpcClient(_networkAdapter);
  }

  Moac.withConnectionParameters(
      MoacINetworkAdapter adapter, String hostname, String scheme,
      [port = defaultHttpPort])
      : _networkAdapter = adapter {
    rpcClient = MoacRpcClient(_networkAdapter);
    connectParameters(scheme, hostname, port);
  }

  /// Constants
  static const String rpcHttpScheme = 'http';
  static const String rpcWsScheme = 'ws';

  /// Defaults
  static const int defaultHttpPort = 8545;
  static const int defaultWsPort = 8546;

  /// Connection parameters
  int port = defaultHttpPort;
  String host;
  Uri _uri;

  Uri get uri => _uri;

  /// HTTP Adapter
  MoacINetworkAdapter _networkAdapter;

  set httpAdapter(MoacINetworkAdapter adapter) => _networkAdapter = adapter;

  /// Json RPC client
  MoacRpcClient rpcClient;

  /// Last error
  MoacError lastError = MoacError();

  /// Transmission id
  set id(int value) => rpcClient.resetTransmissionId(value);

  int get id => rpcClient.id;

  /// Connection methods

  //// Connect using a host string of the form http://thehost.com:1234,
  /// port is optional. Scheme must be http or ws
  void connectString(String hostname) {
    if (hostname == null) {
      throw ArgumentError.notNull("Moac::connectString - hostname");
    }
    final Uri uri = Uri.parse(hostname);
    _validateUri(uri);
  }

  /// Connect using a URI, port is optional
  void connectUri(Uri uri) {
    if (uri == null) {
      throw ArgumentError.notNull("Moac::connectUri - uri");
    }
    _validateUri(uri);
  }

  /// Connect by explicitly setting the connection parameters.
  /// Scheme must be either rpcScheme or rpcWsScheme
  void connectParameters(String scheme, String hostname, [int port]) {
    if (hostname == null) {
      throw ArgumentError.notNull("Moac::connectParameters - hostname");
    }
    if ((scheme != rpcHttpScheme) && (scheme != rpcWsScheme)) {
      throw FormatException("Moac::connectParameters - invalid scheme $scheme");
    }
    int uriPort;
    if (port != null) {
      uriPort = port;
    }
    final Uri uri = Uri(scheme: scheme, host: hostname, port: uriPort);
    _validateUri(uri);
  }

  void _validateUri(Uri puri) {
    // Must have a valid scheme which must be http, host and port
    if (puri.hasAuthority && (puri.host.isNotEmpty)) {
      host = puri.host;
    } else {
      throw ArgumentError.value(puri.host, "Moac::_validateUri - invalid host");
    }
    Uri newUri = puri;
    if (!puri.hasPort) {
      if (puri.scheme == rpcHttpScheme) {
        newUri = puri.replace(port: defaultHttpPort);
      } else {
        newUri = puri.replace(port: defaultWsPort);
      }
    }
    port = newUri.port;
    _uri = newUri;
    rpcClient.uri = _uri;
  }

  /// Print errors, default is off
  bool printError = false;

  /// Error processing helper
  void _processError(String method, Map res) {
    if (res == null) {
      if (printError) {
        print("ERROR:: Result from RPC call is null");
      }
      return;
    }
    final Map error = res[moacErrorKey];
    lastError.updateError(error['code'], error['message'], rpcClient.id);
    if (printError) {
      print("ERROR::$method - ${lastError.toString()}");
    }
  }

  /// API methods

  //// Client version
  Future<String> clientVersion() async {
    final String method = MoacRpcMethods.chain3ClientVersion;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }

  /// Returns Keccak-256 (not the standardized SHA3-256) of the given data.
  Future<BigInt> sha3(BigInt data) async {
    if (data == null) {
      throw ArgumentError.notNull("Moac::sha3 - data");
    }
    final String method = MoacRpcMethods.chain3Sha3;
    final List params = [MoacUtilities.bigIntegerToHex(data)];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.safeParse(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Net version
  Future<String> netVersion() async {
    final String method = MoacRpcMethods.netVersion;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }

  /// Net listening, true when listening
  Future<bool> netListening() async {
    final String method = MoacRpcMethods.netListening;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }

  /// Net peer count,
  Future<int> netPeerCount() async {
    final String method = MoacRpcMethods.netPeerCount;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Protocol version
  Future<String> protocolVersion() async {
    final String method = MoacRpcMethods.protocolVersion;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }

  /// Sync status, an object with data about the sync status if syncing or false if not.
  Future<MoacSyncStatus> syncStatus() async {
    final String method = MoacRpcMethods.syncing;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacSyncStatus.fromMap(res);
    }
    _processError(method, res);
    return null;
  }

  /// The client coinbase address.
  Future<BigInt> coinbaseAddress() async {
    final String method = MoacRpcMethods.coinbaseAddress;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.safeParse(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Mining, true when mining
  Future<bool> mining() async {
    final String method = MoacRpcMethods.mining;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }

  /// Hashrate, returns the number of hashes per second that the node is mining with.
  Future<int> hashrate() async {
    final String method = MoacRpcMethods.hashrate;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// The current price per gas in wei.
  Future<int> gasPrice() async {
    final String method = MoacRpcMethods.gasPrice;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Accounts,  a list of addresses owned by client.
  Future<List<BigInt>> accounts() async {
    final String method = MoacRpcMethods.accounts;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToBigIntList(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Block number, the number of most recent block.
  Future<int> blockNumber() async {
    final String method = MoacRpcMethods.blockNumber;
    final res = await rpcClient.request(method);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get balance, the balance of the account of the given address.
  Future<int> getBalanceEx(String accountNumber, MoacDefaultBlock block) async {
    if (accountNumber == null) {
      throw ArgumentError.notNull("Moac::getBalance - accountNumber");
    }
    if (block == null) {
      throw ArgumentError.notNull("Moac::getBalance - block");
    }
    final String method = MoacRpcMethods.balance;
    final String blockString = block.getSelection();
    final List params = [accountNumber, blockString];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get balance, the balance of the account of the given address.
  Future<int> getBalance(BigInt accountNumber, MoacDefaultBlock block) async {
    if (accountNumber == null) {
      throw ArgumentError.notNull("Moac::getBalance - accountNumber");
    }
    if (block == null) {
      throw ArgumentError.notNull("Moac::getBalance - block");
    }
    final String method = MoacRpcMethods.balance;
    final String blockString = block.getSelection();
    final List params = [
      MoacUtilities.bigIntegerToHex(accountNumber),
      blockString
    ];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get Storage at, the value from a storage position at a given address.
  /// Parameters are the address of the storage, the integer position of the storage and
  // the default block parameter.
  Future<BigInt> getStorageAt(
      BigInt address, int pos, MoacDefaultBlock block) async {
    if (address == null) {
      throw ArgumentError.notNull("Moac::getStorageAt - address");
    }
    if (pos == null) {
      throw ArgumentError.notNull("Moac::getStorageAt - pos");
    }
    if (block == null) {
      throw ArgumentError.notNull("Moac::getStorageAt - block");
    }
    final String method = MoacRpcMethods.storageAt;
    final String blockString = block.getSelection();
    final List params = [
      MoacUtilities.bigIntegerToHex(address),
      MoacUtilities.intToHex(pos),
      blockString
    ];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.safeParse(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Transaction count, returns the number of transactions sent from an address.
  Future<int> getTransactionCount(
      BigInt address, MoacDefaultBlock block) async {
    if (address == null) {
      throw ArgumentError.notNull("Moac::getTransactionCount - address");
    }
    if (block == null) {
      throw ArgumentError.notNull("Moac::getTransactionCount - block");
    }
    final String method = MoacRpcMethods.transactionCount;
    final String blockString = block.getSelection();
    final List params = [MoacUtilities.bigIntegerToHex(address), blockString];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Block Transaction Count By Hash
  /// The number of transactions in a block from a block matching the given block hash.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getBlockTransactionCountByHash(BigInt blockHash) async {
    if (blockHash == null) {
      throw ArgumentError.notNull(
          "Moac::getBlockTransactionCountByHash - blockHash");
    }
    final String method = MoacRpcMethods.blockTransactionCountByHash;
    final List params = [MoacUtilities.bigIntegerToHex(blockHash)];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      if (res[moacResultKey] != null) {
        return MoacUtilities.hexToInt(res[moacResultKey]);
      } else {
        return 0;
      }
    }
    _processError(method, res);
    return null;
  }

  /// Block Transaction Count By Number
  /// The number of transactions in a block matching the given block number.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getBlockTransactionCountByNumber(
      MoacDefaultBlock blockNumber) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull(
          "Moac::getBlockTransactionCountByNumber - blockNumber");
    }
    final String method = MoacRpcMethods.blockTransactionCountByNumber;
    final String blockString = blockNumber.getSelection();
    final List params = [blockString];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      if (res[moacResultKey] != null) {
        return MoacUtilities.hexToInt(res[moacResultKey]);
      } else {
        return 0;
      }
    }
    _processError(method, res);
    return null;
  }

  /// Block Uncle Count By Hash
  /// The number of uncles in a block from a block matching the given block hash.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getUncleCountByHash(BigInt blockHash) async {
    if (blockHash == null) {
      throw ArgumentError.notNull("Moac::getUncleCountByHash - blockHash");
    }
    final String method = MoacRpcMethods.blockUncleCountByBlockHash;
    final List params = [MoacUtilities.bigIntegerToHex(blockHash)];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      if (res[moacResultKey] != null) {
        return MoacUtilities.hexToInt(res[moacResultKey]);
      } else {
        return 0;
      }
    }
    _processError(method, res);
    return null;
  }

  /// Block Uncle Count By Number
  /// The number of uncles in a block matching the given block number.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getUncleCountByNumber(MoacDefaultBlock blockNumber) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull("Moac::getUncleCountByNumber - blockNumber");
    }
    final String method = MoacRpcMethods.blockUncleCountByBlockNumber;
    final String blockString = blockNumber.getSelection();
    final List params = [blockString];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      if (res[moacResultKey] != null) {
        return MoacUtilities.hexToInt(res[moacResultKey]);
      } else {
        return 0;
      }
    }
    _processError(method, res);
    return null;
  }

  /// Get code, the code at the given address.
  Future<int> getCode(BigInt address, MoacDefaultBlock block) async {
    if (address == null) {
      throw ArgumentError.notNull("Moac::getCode - address");
    }
    if (block == null) {
      throw ArgumentError.notNull("Moac::getCode - block");
    }
    final String method = MoacRpcMethods.code;
    final String blockString = block.getSelection();
    final List params = [MoacUtilities.bigIntegerToHex(address), blockString];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Sign
  /// The sign method calculates an Moac specific signature with:
  /// sign(keccak256("\x19Moac Signed Message:\n" + len(message) + message))).
  /// Note the address to sign with must be unlocked.
  Future<int> sign(BigInt account, int message) async {
    if (account == null) {
      throw ArgumentError.notNull("Moac::sign - account");
    }
    if (message == null) {
      throw ArgumentError.notNull("Moac::sign - message");
    }
    final String method = MoacRpcMethods.sign;
    final List params = [
      MoacUtilities.bigIntegerToHex(account),
      MoacUtilities.intToHex(message)
    ];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Send transaction
  /// Creates new message call transaction or a contract creation, if the data field contains code.
  /// address: The address the transaction is sent from.
  /// to: (optional when creating new contract) The address the transaction is directed to.
  /// gas: (optional, default: 90000) Integer of the gas provided for the transaction execution. It will return unused gas.
  /// gasPrice: (optional, default: To-Be-Determined) Integer of the gasPrice used for each paid gas
  /// value: (optional) Integer of the value send with this transaction
  /// data: The compiled code of a contract OR the hash of the invoked method signature and encoded parameters. For details see Moac Contract ABI
  /// nonce: optional) Integer of a nonce. This allows to overwrite your own pending transactions that use the same nonce.
  /// Returns the transaction hash, or the zero hash if the transaction is not yet available.
  Future<int> sendTransaction(BigInt address, BigInt data,
      {BigInt to, int gas = 9000, int gasPrice, int value, int nonce}) async {
    if (address == null) {
      throw ArgumentError.notNull("Moac::sendTransaction - address");
    }
    if (data == null) {
      throw ArgumentError.notNull("Moac::sendTransaction - data");
    }
    final String method = MoacRpcMethods.sendTransaction;
    Map<String, String> paramBlock = {
      "from": MoacUtilities.bigIntegerToHex(address),
      "to": to == null ? null : MoacUtilities.bigIntegerToHex(to),
      "gas": MoacUtilities.intToHex(gas),
      "gasPrice": gasPrice == null ? null : MoacUtilities.intToHex(gasPrice),
      "value": value == null ? null : MoacUtilities.intToHex(value),
      "data": MoacUtilities.bigIntegerToHex(data),
      "nonce": nonce == null ? null : MoacUtilities.intToHex(nonce)
    };
    paramBlock = MoacUtilities.removeNull(paramBlock);
    final dynamic params = [paramBlock];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Send raw transaction
  /// Creates new message call transaction or a contract creation for signed transactions.
  /// Takes the signed transaction data.
  /// Returns the transaction hash, or the zero hash if the transaction is not yet available.
  Future<int> sendRawTransaction(BigInt signedTransaction) async {
    if (signedTransaction == null) {
      throw ArgumentError.notNull(
          "Moac::sendRawTransaction - signedTransaction");
    }
    final String method = MoacRpcMethods.sendRawTransaction;
    final dynamic params = [MoacUtilities.bigIntegerToHex(signedTransaction)];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Call
  /// Executes a new message call immediately without creating a transaction on the block chain.
  /// address: The address the transaction is sent to.
  /// from: (optional) The address the transaction is sent from.
  /// gas: (optional) Integer of the gas provided for the transaction execution. eth_call consumes zero gas,
  /// but this parameter may be needed by some executions.
  /// gasPrice: (optional) Integer of the gasPrice used for each paid gas
  /// value: (optional) Integer of the value send with this transaction
  /// data: (optional) Hash of the method signature and encoded parameters. For details see Moac Contract ABI
  /// block: default block parameter
  /// Returns the return value of executed contract.
  Future<int> call(BigInt address, MoacDefaultBlock block,
      {BigInt from, int gas, int gasPrice, int value, BigInt data}) async {
    if (address == null) {
      throw ArgumentError.notNull("Moac::call - address");
    }
    if (block == null) {
      throw ArgumentError.notNull("Moac::call - block");
    }
    final String method = MoacRpcMethods.call;
    final String blockString = block.getSelection();
    Map<String, String> paramBlock = {
      "from": from == null ? null : MoacUtilities.bigIntegerToHex(from),
      "to": MoacUtilities.bigIntegerToHex(address),
      "gas": gas == null ? null : MoacUtilities.intToHex(gas),
      "gasPrice": gasPrice == null ? null : MoacUtilities.intToHex(gasPrice),
      "value": value == null ? null : MoacUtilities.intToHex(value),
      "data": data == null ? null : MoacUtilities.bigIntegerToHex(data)
    };
    paramBlock = MoacUtilities.removeNull(paramBlock);
    final dynamic params = [paramBlock, blockString];
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Estimate gas
  /// Makes a call or transaction, which won't be added to the blockchain and returns the used gas,
  /// which can be used for estimating the used gas.
  /// See eth_call parameters, expect that all properties are optional. If no gas limit is specified geth
  /// uses the block gas limit from the pending block as an upper bound. As a result the returned estimate
  /// might not be enough to executed the call/transaction when the amount of gas is higher than the
  /// pending block gas limit.
  /// Returns the amount of gas used.
  Future<int> estimateGas(
      {BigInt address,
      BigInt from,
      int gas,
      int gasPrice,
      int value,
      BigInt data}) async {
    Map<String, String> paramBlock = {
      "from": from == null ? null : MoacUtilities.bigIntegerToHex(from),
      "to": address == null ? null : MoacUtilities.bigIntegerToHex(address),
      "gas": gas == null ? null : MoacUtilities.intToHex(gas),
      "gasPrice": gasPrice == null ? null : MoacUtilities.intToHex(gasPrice),
      "value": value == null ? null : MoacUtilities.intToHex(value),
      "data": data == null ? null : MoacUtilities.bigIntegerToHex(data)
    };
    paramBlock = MoacUtilities.removeNull(paramBlock);
    final dynamic params = [paramBlock];
    final String method = MoacRpcMethods.estimateGas;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get block by hash
  /// Returns information about a block by hash
  /// Hash of a block and a boolean, if true it returns the full transaction objects,
  /// if false only the hashes of the transactions, defaults to true.
  /// Returns A block object, or null when no block was found :
  Future<MoacBlock> getBlockByHash(BigInt blockHash, [bool full = true]) async {
    if (blockHash == null) {
      throw ArgumentError.notNull("Moac::getBlockByHash - blockHash");
    }
    final dynamic params = [MoacUtilities.bigIntegerToHex(blockHash), full];
    final String method = MoacRpcMethods.getBlockByHash;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacBlock.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get block by number
  /// Returns information about a block by block number.
  /// blockNumber - defualt block parameter
  /// as in the default block parameter.
  /// A boolean, if true it returns the full transaction objects,
  /// if false only the hashes of the transactions, defaults to true.
  /// Returns See getBlockByHash
  Future<MoacBlock> getBlockByNumber(MoacDefaultBlock blockNumber,
      [bool full = true]) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull("Moac::getBlockByNumber - blockNumber");
    }
    final String blockString = blockNumber.getSelection();
    final dynamic params = [blockString, full];
    final String method = MoacRpcMethods.getBlockByNumber;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacBlock.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get transaction by hash
  /// Returns the information about a transaction requested by transaction hash.
  /// Hash of a transaction
  /// Returns a transaction object, or null when no transaction was found:
  Future<MoacTransaction> getTransactionByHash(BigInt hash) async {
    if (hash == null) {
      throw ArgumentError.notNull("Moac::getTransactionByHash - hash");
    }
    final dynamic params = [MoacUtilities.bigIntegerToHex(hash)];
    final String method = MoacRpcMethods.getTransactionByHash;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacTransaction.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get transaction by block hash and index.
  /// Returns information about a transaction by block hash and transaction index position.
  /// Hash of a block and integer of the transaction index position.
  /// Returns see getTransactionByHash.
  Future<MoacTransaction> getTransactionByBlockHashAndIndex(
      BigInt blockHash, int index) async {
    if (blockHash == null) {
      throw ArgumentError.notNull(
          "Moac::getTransactionByBlockHashAndIndex - blockHash");
    }
    if (index == null) {
      throw ArgumentError.notNull(
          "Moac::getTransactionByBlockHashAndIndex - index");
    }
    final dynamic params = [
      MoacUtilities.bigIntegerToHex(blockHash),
      MoacUtilities.intToHex(index)
    ];
    final String method = MoacRpcMethods.getTransactionByBlockHashAndIndex;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacTransaction.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get transaction by block number and index.
  /// Returns information about a transaction by block number and transaction index position.
  /// A block number as in the default block parameter.
  /// Returns see getTransactionByHash.
  Future<MoacTransaction> getTransactionByBlockNumberAndIndex(
      MoacDefaultBlock blockNumber, int index) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull(
          "Moac::getTransactionByBlockNumberAndIndex - blockNumber");
    }
    if (index == null) {
      throw ArgumentError.notNull(
          "Moac::getTransactionByBlockNumberAndIndex - index");
    }
    final String blockNumberString = blockNumber.getSelection();
    final dynamic params = [blockNumberString, MoacUtilities.intToHex(index)];
    final String method = MoacRpcMethods.getTransactionByBlockNumberAndIndex;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacTransaction.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get transaction receipt
  /// Returns the receipt of a transaction by transaction hash.
  /// Note That the receipt is not available for pending transactions.
  /// Hash of a transaction
  /// Returns a transaction receipt object, or null when no receipt was found:
  Future<MoacTransactionReceipt> getTransactionReceipt(
      BigInt transactionHash) async {
    if (transactionHash == null) {
      throw ArgumentError.notNull(
          "Moac::getTransactionReceipt - transactionHash");
    }
    final dynamic params = [MoacUtilities.bigIntegerToHex(transactionHash)];
    final String method = MoacRpcMethods.getTransactionReceipt;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacTransactionReceipt.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get uncle by block hash and index.
  /// Returns information about an uncle by block hash and uncle index position.
  /// Note: An uncle doesn't contain individual transactions.
  /// Hash of a block and integer of the uncle index position.
  /// Returns see getBlockByHash.
  Future<MoacBlock> getUncleByBlockHashAndIndex(
      BigInt blockHash, int index) async {
    if (blockHash == null) {
      throw ArgumentError.notNull(
          "Moac::getUncleByBlockHashAndIndex - blockHash");
    }
    if (index == null) {
      throw ArgumentError.notNull("Moac::getUncleByBlockHashAndIndex - index");
    }
    final dynamic params = [
      MoacUtilities.bigIntegerToHex(blockHash),
      MoacUtilities.intToHex(index)
    ];
    final String method = MoacRpcMethods.getUncleByBlockHashAndIndex;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacBlock.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get uncle by block number and index.
  /// Returns information about an uncle by block number and uncle index position.
  /// Note: An uncle doesn't contain individual transactions.
  /// A block number as in the default block parameter.
  /// Returns see getBlockByHash.
  Future<MoacBlock> getUncleByBlockNumberAndIndex(
      MoacDefaultBlock blockNumber, int index) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull(
          "Moac::getUncleByBlockNumberAndIndex - blockNumber");
    }
    if (index == null) {
      throw ArgumentError.notNull(
          "Moac::getUncleByBlockNumberAndIndex - index");
    }
    final String blockNumberString = blockNumber.getSelection();
    final dynamic params = [blockNumberString, MoacUtilities.intToHex(index)];
    final String method = MoacRpcMethods.getUncleByBlockNumberAndIndex;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacBlock.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// New filter
  /// Creates a filter object, based on filter options, to notify when the state changes (logs).
  /// To check if the state has changed, call getFilterChanges.
  /// note on specifying topic filters:
  /// Topics are order-dependent. A transaction with a log with topics [A, B] will be matched by the following topic filters:
  /// [] "anything"
  /// ['A'] "A in first position (and anything after)"
  /// [null, B] "anything in first position AND B in second position (and anything after)"
  /// [A, B] "A in first position AND B in second position (and anything after)"
  /// [[A, B], [A, B]] "(A OR B) in first position AND (A OR B) in second position (and anything after)"
  /// fromBlock: - (optional, default: "latest") Integer block number, or "latest" for the last mined block or "pending",
  /// "earliest" for not yet mined transactions.
  /// toBlock: - (optional, default: "latest") Integer block number, or "latest" for the last mined block or "pending", "earliest" for not
  /// yet mined transactions.
  /// address: - (optional) Contract address or a list of addresses from which logs should originate.
  /// topics: - (optional) topics. Topics are order-dependent.
  /// Note: the user must build this structure using the utilities in the MoacUtilities class. See the Moac
  /// Wiki RPC page for examples.
  /// Returns a filter id.
  Future<int> newFilter(
      {MoacDefaultBlock fromBlock,
      MoacDefaultBlock toBlock,
      dynamic address,
      List<BigInt> topics}) async {
    final String fromBlockString = fromBlock.getSelection();
    final String toBlockString = toBlock.getSelection();
    final Map params = {"toBlock": toBlockString, "fromBlock": fromBlockString};
    if (address != null) {
      if (address is List) {
        final List<String> addresses =
            MoacUtilities.bigIntegerToHexList(address);
        params["address"] = addresses;
      } else {
        params["address"] = (MoacUtilities.bigIntegerToHex(address));
      }
    }
    if (topics != null) {
      params["topics"] = MoacUtilities.bigIntegerToHexList(topics);
    }
    final List paramBlock = [params];
    final String method = MoacRpcMethods.newFilter;
    final res = await rpcClient.request(method, paramBlock);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// New block filter
  /// Creates a filter in the node, to notify when a new block arrives.
  /// To check if the state has changed, call getFilterChanges.
  /// Returns a filter id.
  Future<int> newBlockFilter() async {
    final List params = [];
    final String method = MoacRpcMethods.newBlockFilter;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// New pending transaction filter
  /// Creates a filter in the node, to notify when a new pending transaction arrives.
  /// To check if the state has changed, call getFilterChanges.
  /// Returns a filter id.
  Future<int> newPendingTransactionFilter() async {
    final List params = [];
    final String method = MoacRpcMethods.newPendingTransactionFilter;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacUtilities.hexToInt(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Uninstall filter
  /// Uninstalls a filter with given id. Should always be called when watch is no longer needed.
  /// Additionally Filters timeout when they aren't requested with getFilterChanges for a period of time.
  /// Filter id
  /// Returns true if the filter was successfully uninstalled, otherwise false.
  Future<bool> uninstallFilter(int filterId) async {
    if (filterId == null) {
      throw ArgumentError.notNull("Moac::uninstallFilter - filterId");
    }
    final List params = [MoacUtilities.intToHex(filterId)];
    final String method = MoacRpcMethods.uninstallFilter;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }

  /// Get filter changes
  /// Polling method for a filter, which returns an list of logs which occurred since last poll.
  /// Filter Id
  /// Returns an MoacFilter object or null
  Future<MoacFilter> getFilterChanges(int filterId) async {
    if (filterId == null) {
      throw ArgumentError.notNull("Moac::getFilterChanges - filterId");
    }
    final List params = [MoacUtilities.intToHex(filterId)];
    final String method = MoacRpcMethods.getFilterChanges;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacFilter.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get filter logs
  /// Filter Id
  /// Returns see getFilterChanges
  Future<MoacFilter> getFilterLogs(int filterId) async {
    if (filterId == null) {
      throw ArgumentError.notNull("Moac::getFilterLogs - filterId");
    }
    final List params = [MoacUtilities.intToHex(filterId)];
    final String method = MoacRpcMethods.getFilterLogs;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacFilter.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get logs
  /// The filter definition, see newFilter parameters.
  /// Returns see getFilterChanges
  Future<MoacFilter> getLogs(
      {MoacDefaultBlock fromBlock,
      MoacDefaultBlock toBlock,
      dynamic address,
      List<BigInt> topics}) async {
    final String fromBlockString = fromBlock.getSelection();
    final String toBlockString = toBlock.getSelection();
    final Map params = {"toBlock": toBlockString, "fromBlock": fromBlockString};
    if (address != null) {
      if (address is List) {
        final List<String> addresses =
            MoacUtilities.bigIntegerToHexList(address);
        params["address"] = addresses;
      } else {
        params["address"] = (MoacUtilities.bigIntegerToHex(address));
      }
    }
    if (topics != null) {
      params["topics"] = MoacUtilities.bigIntegerToHexList(topics);
    }
    final List paramBlock = [params];
    final String method = MoacRpcMethods.getLogs;
    final res = await rpcClient.request(method, paramBlock);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacFilter.fromMap(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Get work
  /// Returns the hash of the current block, the seedHash, and the boundary condition to be met ("target").
  /// Returns an MoacWork object or null
  Future<MoacWork> getWork() async {
    final List paramBlock = [];
    final String method = MoacRpcMethods.getWork;
    final res = await rpcClient.request(method, paramBlock);
    if (res != null && res.containsKey(moacResultKey)) {
      return MoacWork.fromList(res[moacResultKey]);
    }
    _processError(method, res);
    return null;
  }

  /// Submit work
  /// Used for submitting a proof-of-work solution.
  /// The nonce found
  /// The header's pow-hash
  /// The mix digest
  /// Returns  true if the provided solution is valid, otherwise false.
  Future<bool> submitWork(BigInt nonce, BigInt powHash, BigInt digest) async {
    if (nonce == null) {
      throw ArgumentError.notNull("Moac::submitWork - nonce");
    }
    if (powHash == null) {
      throw ArgumentError.notNull("Moac::submitWork - powHash");
    }
    if (digest == null) {
      throw ArgumentError.notNull("Moac::submitWork - digest");
    }
    final List params = [
      MoacUtilities.bigIntegerToHex(nonce),
      MoacUtilities.bigIntegerToHex(powHash),
      MoacUtilities.bigIntegerToHex(digest)
    ];
    final String method = MoacRpcMethods.submitWork;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }

  /*/// Submit hash rate
  /// Used for submitting mining hashrate.
  /// Hash rate
  /// Id, a random hexadecimal(32 bytes) string identifying the client
  /// Returns true if submitting went through successfully and false otherwise.
  Future<bool> submitHashrate(BigInt hashRate, String id) async {
    if (hashRate == null) {
      throw ArgumentError.notNull("Moac::submitHashRate - hashRate");
    }
    if (id == null) {
      throw ArgumentError.notNull("Moac::submitHashRate - id");
    }
    final List params = [MoacUtilities.bigIntegerToHex(hashRate), id];
    final String method = MoacRpcMethods.submitHashrate;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }

  /// SHH version
  /// Returns the current whisper protocol version.
  Future<String> shhVersion() async {
    final List params = [];
    final String method = MoacRpcMethods.shhVersion;
    final res = await rpcClient.request(method, params);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }

  /// SHH post
  /// Sends a whisper message
  /// from: - (optional) The identity of the sender.
  /// to: - (optional) The identity of the receiver. When present whisper will encrypt the message so that only
  ///  the receiver can decrypt it.
  /// topics: - List of topics, for the receiver to identify messages.
  /// payload: - The payload of the message.
  /// priority: - The integer of the priority in a range from ... (?).
  /// ttl: - integer of the time to live in seconds.
  /// Returns true if the message was send, otherwise false.
  Future<bool> shhPost(
      List<BigInt> topics, BigInt payload, int priority, int ttl,
      {BigInt to, BigInt from}) async {
    if (topics == null) {
      throw ArgumentError.notNull("Moac::shhPost - topics");
    }
    if (payload == null) {
      throw ArgumentError.notNull("Moac::shhPost - payload");
    }
    if (priority == null) {
      throw ArgumentError.notNull("Moac::shhPost - priority");
    }
    if (ttl == null) {
      throw ArgumentError.notNull("Moac::shhPost - ttl");
    }
    Map<String, dynamic> params = {
      "topics": MoacUtilities.bigIntegerToHexList(topics),
      "payload": MoacUtilities.bigIntegerToHex(payload),
      "priority": MoacUtilities.intToHex(priority),
      "ttl": ttl,
      "to": MoacUtilities.bigIntegerToHex(to),
      "from": MoacUtilities.bigIntegerToHex(from)
    };
    params = MoacUtilities.removeNull(params);
    final List paramBlock = [params];
    final String method = MoacRpcMethods.shhPost;
    final res = await rpcClient.request(method, paramBlock);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }*/

  /// Get newaccount with return wallet address.
  Future<String> newAccount(String pass) async {
    if (pass == null) {
      throw ArgumentError.notNull("Moac::newAccount - need Password");
    }

    final String method = MoacRpcMethods.newAccount;

    final List params = [pass];
    final res = await rpcClient.request(method, params);
    print(res);
    if (res != null && res.containsKey(moacResultKey)) {
      return res[moacResultKey];
    }
    _processError(method, res);
    return null;
  }
}
