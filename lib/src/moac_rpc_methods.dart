/*
 * Package : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 06/011/2017
 * Copyright :  S.Hamblett
 * * Modified by Gao Ji Hua
 * Data: 2018/09/04
 * A JSON RPC 2.0 client for moac 
 */

part of moac;

class MoacRpcMethods {
  /*chain3_clientVersion
chain3_sha3
net_version
net_peerCount
net_listening
mc_protocolVersion
mc_syncing
mc_coinbase
mc_mining
mc_hashrate
mc_gasPrice
mc_accounts
mc_blockNumber
mc_getBalance
mc_getStorageAt
mc_getTransactionCount
mc_getBlockTransactionCountByHash
mc_getBlockTransactionCountByNumber
mc_getUncleCountByBlockHash
mc_getUncleCountByBlockNumber
mc_getCode
mc_sign
mc_sendTransaction
mc_sendRawTransaction
mc_call
mc_estimateGas
mc_getBlockByHash
mc_getBlockByNumber
mc_getTransactionByHash
mc_getTransactionByBlockHashAndIndex
mc_getTransactionByBlockNumberAndIndex
mc_getTransactionReceipt
mc_getUncleByBlockHashAndIndex
mc_getUncleByBlockNumberAndIndex
mc_newFilter
mc_newBlockFilter
mc_newPendingTransactionFilter
mc_uninstallFilter
mc_getFilterChanges
mc_getFilterLogs
mc_getLogs
mc_getWork
mc_submitWork
*/
  static const String chain3ClientVersion = 'chain3_clientVersion';
  static const String chain3Sha3 = 'chain3_sha3';
  static const String netVersion = 'net_version';
  static const String netListening = 'net_listening';
  static const String netPeerCount = 'net_peerCount';
  static const String protocolVersion = 'mc_protocolVersion';
  static const String syncing = 'mc_syncing';
  static const String coinbaseAddress = 'mc_coinbase';
  static const String mining = 'mc_mining';
  static const String hashrate = 'mc_hashrate';
  static const String gasPrice = 'mc_gasPrice';
  static const String accounts = 'mc_accounts';
  static const String blockNumber = 'mc_blockNumber';
  static const String balance = 'mc_getBalance';
  static const String storageAt = 'mc_getStorageAt';
  static const String transactionCount = 'mc_getTransactionCount';
  static const String blockTransactionCountByHash =
      'mc_getBlockTransactionCountByHash';
  static const String blockTransactionCountByNumber =
      'mc_getBlockTransactionCountByNumber';
  static const String blockUncleCountByBlockHash =
      'mc_getUncleCountByBlockHash';
  static const String blockUncleCountByBlockNumber =
      'mc_getUncleCountByBlockNumber';
  static const String code = 'mc_getCode';
  static const String sign = 'mc_sign';
  static const String sendTransaction = 'mc_sendTransaction';
  static const String sendRawTransaction = 'mc_sendRawTransaction';
  static const String call = 'mc_call';
  static const String estimateGas = 'mc_estimateGas';
  static const String getBlockByHash = 'mc_getBlockByHash';
  static const String getBlockByNumber = 'mc_getBlockByNumber';
  static const String getTransactionByHash = 'mc_getTransactionByHash';
  static const String getTransactionByBlockHashAndIndex =
      'mc_getTransactionByBlockHashAndIndex';
  static const String getTransactionByBlockNumberAndIndex =
      'mc_getTransactionByBlockNumberAndIndex';
  static const String getTransactionReceipt = 'mc_getTransactionReceipt';
  static const String getUncleByBlockHashAndIndex =
      'mc_getUncleByBlockHashAndIndex';
  static const String getUncleByBlockNumberAndIndex =
      'mc_getUncleByBlockNumberAndIndex';
  static const String newFilter = 'mc_newFilter';
  static const String newBlockFilter = 'mc_newBlockFilter';
  static const String newPendingTransactionFilter =
      'mc_newPendingTransactionFilter';
  static const String uninstallFilter = 'mc_uninstallFilter';
  static const String getFilterChanges = 'mc_getFilterChanges';
  static const String getFilterLogs = 'mc_getFilterLogs';
  static const String getLogs = 'mc_getLogs';
  static const String getWork = 'mc_getWork';
  static const String submitWork = 'mc_submitWork';
  static const String newAccount = 'personal_newAccount';
  static const String unlockAccount = 'personal_unlockAccount';
  static const String lockAccount = 'personal_lockAccount';
  static const String personalsendTransaction = 'personal_sendTransaction';
  static const String personalSign = 'personal_sign';
  static const String importRawKey = 'personal_importRawKey';
  // static const String submitHashrate = 'eth_submitHashrate';
  // static const String shhVersion = 'shh_version';
  // static const String shhPost = 'shh_post';
  // static const String shhNewIdentity = 'shh_newIdentity';
}

/// The Ethereum RPC method names
class EthRpcMethods {
  static const String web3ClientVersion = 'web3_clientVersion';
  static const String web3Sha3 = 'web3_sha3';
  static const String netVersion = 'net_version';
  static const String netListening = 'net_listening';
  static const String netPeerCount = 'net_peerCount';
  static const String protocolVersion = 'eth_protocolVersion';
  static const String syncing = 'eth_syncing';
  static const String coinbaseAddress = 'eth_coinbase';
  static const String mining = 'eth_mining';
  static const String hashrate = 'eth_hashrate';
  static const String gasPrice = 'eth_gasPrice';
  static const String accounts = 'eth_accounts';
  static const String blockNumber = 'eth_blockNumber';
  static const String balance = 'eth_getBalance';
  static const String storageAt = 'eth_getStorageAt';
  static const String transactionCount = 'eth_getTransactionCount';
  static const String blockTransactionCountByHash =
      'eth_getBlockTransactionCountByHash';
  static const String blockTransactionCountByNumber =
      'eth_getBlockTransactionCountByNumber';
  static const String blockUncleCountByBlockHash =
      'eth_getUncleCountByBlockHash';
  static const String blockUncleCountByBlockNumber =
      'eth_getUncleCountByBlockNumber';
  static const String code = 'eth_getCode';
  static const String sign = 'eth_sign';
  static const String sendTransaction = 'eth_sendTransaction';
  static const String sendRawTransaction = 'eth_sendRawTransaction';
  static const String call = 'eth_call';
  static const String estimateGas = 'eth_estimateGas';
  static const String getBlockByHash = 'eth_getBlockByHash';
  static const String getBlockByNumber = 'eth_getBlockByNumber';
  static const String getTransactionByHash = 'eth_getTransactionByHash';
  static const String getTransactionByBlockHashAndIndex =
      'eth_getTransactionByBlockHashAndIndex';
  static const String getTransactionByBlockNumberAndIndex =
      'eth_getTransactionByBlockNumberAndIndex';
  static const String getTransactionReceipt = 'eth_getTransactionReceipt';
  static const String getUncleByBlockHashAndIndex =
      'eth_getUncleByBlockHashAndIndex';
  static const String getUncleByBlockNumberAndIndex =
      'eth_getUncleByBlockNumberAndIndex';
  static const String newFilter = 'eth_newFilter';
  static const String newBlockFilter = 'eth_newBlockFilter';
  static const String newPendingTransactionFilter =
      'eth_newPendingTransactionFilter';
  static const String uninstallFilter = 'eth_uninstallFilter';
  static const String getFilterChanges = 'eth_getFilterChanges';
  static const String getFilterLogs = 'eth_getFilterLogs';
  static const String getLogs = 'eth_getLogs';
  static const String getWork = 'eth_getWork';
  static const String submitWork = 'eth_submitWork';
  static const String submitHashrate = 'eth_submitHashrate';
  static const String shhVersion = 'shh_version';
  static const String shhPost = 'shh_post';
  static const String shhNewIdentity = 'shh_newIdentity';
}
