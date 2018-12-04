/*
 * Package : Moac
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 03/11/2017
 * Copyright :  S.Hamblett
 */

import 'package:moac/moac.dart';
import 'package:flutter_test/flutter_test.dart';

class MoacTestConfiguration {
  static BigInt defaultAccount =
      BigInt.parse("0xe2a7ff1861e8b9a08852f6817d8b25209dfc6fd3");

  /// True runs the browser HTTP tests, you will need CORS support for this as above
  static bool runBrowserHttp = false;

  /// True runs the browser WS tests, you should be OK with --wsorigins as above
  static bool runBrowserWS = true;

  /// True runs the server tests
  static bool runServer = true;
}

/// Class to run the common Moac API tests
class MoacCommon {
  static void run(Moac client) {
    int id = 0;
    test("Protocol version 1", () async {
      final String version = await client.protocolVersion();
      expect(version, isNotNull);
      expect(client.id, ++id);
      print("Protocol Version is $version");
    });
    test("Protocol version 2", () async {
      final String version = await client.protocolVersion();
      expect(version, isNotNull);
      expect(client.id, ++id);
      print("Protocol Version is $version");
    });
    test("Client version", () async {
      final String version = await client.clientVersion();
      expect(version, isNotNull);
      expect(client.id, ++id);
      print("Client Version is $version");
    });
    test("SHA3", () async {
      final BigInt data = MoacUtilities.safeParse("0x68656c6c6f20776f726c64");
      final BigInt hash = await client.sha3(data);
      expect(hash, isNotNull);
      print("sha3: $hash");
      expect(client.id, ++id);
    });
    test("Net version", () async {
      final String version = await client.netVersion();
      expect(version, isNotNull);
      expect(client.id, ++id);
      print("Net Version is $version");
    });
    test("Net listening", () async {
      final bool listening = await client.netListening();
      expect(listening, isNotNull);
      expect(client.id, ++id);
      print("Net Listening is $listening");
    });
    test("Net peer count", () async {
      final int count = await client.netPeerCount();
      expect(count, isNotNull);
      expect(client.id, ++id);
      print("Net peer count is $count");
    });
    test("Sync status", () async {
      final MoacSyncStatus res = await client.syncStatus();
      expect(res, isNotNull);
      expect(client.id, ++id);
      if (res.syncing) {
        print("Sync status is syncing");
        print("Starting Block is ${res.startingBlock}");
        print("Current Block is ${res.currentBlock}");
        print("Highest Block is ${res.highestBlock}");
      } else {
        print("Sync status is not syncing");
      }
    });
    test("Coinbase address", () async {
      final BigInt address = await client.coinbaseAddress();
      expect(client.id, ++id);
      if (address != null) {
        print("Coinbase address is $address");
      } else {
        expect(client.lastError.code, -32000);
        expect(client.lastError.message,
            "etherbase address must be explicitly specified");
      }
    });
    test("Mining", () async {
      final bool mining = await client.mining();
      expect(mining, isNotNull);
      expect(client.id, ++id);
      print("Mining is $mining");
    });
    test("Hashrate", () async {
      final int rate = await client.hashrate();
      expect(rate, isNotNull);
      expect(client.id, ++id);
      print("Hashrate is $rate");
    });
    test("Gas price", () async {
      final int price = await client.gasPrice();
      expect(price, isNotNull);
      expect(client.id, ++id);
      print("Gas price is $price");
    });
    test("Accounts", () async {
      final List<BigInt> accounts = await client.accounts();
      expect(accounts, isNotNull);
      final List<String> accountsStr =
          MoacUtilities.bigIntegerToHexList(accounts);
      expect(client.id, ++id);
      if (accounts.length != 0) {
        print("Accounts are $accountsStr");
        expect(accounts[0], MoacTestConfiguration.defaultAccount);
      } else {
        print("There are no accounts");
      }
    });
    test("Block number", () async {
      final int num = await client.blockNumber();
      expect(num, isNotNull);
      expect(client.id, ++id);
      print("Block number is $num");
    });
    test("Balance - number", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0;
      final int balance = await client.getBalance(
          MoacUtilities.safeParse("0x407d73d8a49eeb85d32cf465507dd71d507100c1"),
          block);
      expect(balance, isNotNull);
      expect(client.id, ++id);
      print("Balance number is $balance");
    });
    test("Balance - latest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.latest = true;
      final int balance = await client.getBalance(
          MoacUtilities.safeParse("0x407d73d8a49eeb85d32cf465507dd71d507100c1"),
          block);
      expect(balance, isNotNull);
      expect(client.id, ++id);
      print("Balance latest is $balance");
    });
    test("Balance - earliest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.earliest = true;
      final int balance = await client.getBalance(
          MoacUtilities.safeParse("0x407d73d8a49eeb85d32cf465507dd71d507100c1"),
          block);
      expect(balance, isNotNull);
      expect(client.id, ++id);
      print("Balance earliest is $balance");
    });
    test("Balance - pending", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.pending = true;
      final int balance = await client.getBalance(
          MoacUtilities.safeParse("0x407d73d8a49eeb85d32cf465507dd71d507100c1"),
          block);
      expect(balance, isNotNull);
      expect(client.id, ++id);
      print("Balance pending is $balance");
    });
    test("Get storage at - latest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.latest = true;
      final BigInt storage = await client.getStorageAt(
          MoacUtilities.safeParse("0x295a70b2de5e3953354a6a8344e616ed314d7251"),
          0x0,
          block);
      expect(storage, isNotNull);
      expect(client.id, ++id);
      print("Storage at latest is $storage");
    });
    test("Get storage at - earliest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.earliest = true;
      final BigInt storage = await client.getStorageAt(
          MoacUtilities.safeParse("0x295a70b2de5e3953354a6a8344e616ed314d7251"),
          0x0,
          block);
      expect(storage, isNotNull);
      expect(client.id, ++id);
      print("Storage at earliest is $storage");
    });
    test("Get storage at - pending", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.pending = true;
      final BigInt storage = await client.getStorageAt(
          MoacUtilities.safeParse("0x295a70b2de5e3953354a6a8344e616ed314d7251"),
          0x0,
          block);
      expect(storage, isNotNull);
      expect(client.id, ++id);
      print("Storage at pending is $storage");
    });
    test("Get storage at - block", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0x4b7;
      final BigInt storage = await client.getStorageAt(
          MoacUtilities.safeParse("0x295a70b2de5e3953354a6a8344e616ed314d7251"),
          0x0,
          block);
      if (storage != null) {
        expect(storage, BigInt.zero);
      }
      expect(client.id, ++id);
      print("Storage at block is $storage");
    });
    test("Transaction count - number", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0;
      final int count = await client.getTransactionCount(
          MoacUtilities.safeParse("0x407d73d8a49eeb85d32cf465507dd71d507100c1"),
          block);
      expect(count, isNotNull);
      expect(client.id, ++id);
      print("Transaction count is $count");
    });
    test("Transaction count - earliest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.earliest = true;
      final int count = await client.getTransactionCount(
          MoacUtilities.safeParse("0x407d73d8a49eeb85d32cf465507dd71d507100c1"),
          block);
      expect(count, isNotNull);
      expect(client.id, ++id);
      print("Transaction count  is $count");
    });
    test("Transaction count - pending", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.pending = true;
      final int count = await client.getTransactionCount(
          MoacUtilities.safeParse("0x407d73d8a49eeb85d32cf465507dd71d507100c1"),
          block);
      expect(count, isNotNull);
      expect(client.id, ++id);
      print("Transaction count  is $count");
    });
    test("Transaction count - latest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.latest = true;
      final int count = await client.getTransactionCount(
          MoacUtilities.safeParse("0x407d73d8a49eeb85d32cf465507dd71d507100c1"),
          block);
      expect(count, isNotNull);
      expect(client.id, ++id);
      print("Transaction count  is $count");
    });
    test("Block transaction count by hash", () async {
      final int count = await client.getBlockTransactionCountByHash(
          MoacUtilities.safeParse(
              "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"));
      expect(count, 0);
      expect(client.id, ++id);
    });
    test("Block transaction count by number - number", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0xe8;
      final int count = await client.getBlockTransactionCountByNumber(block);
      expect(count, isNotNull);
      expect(client.id, ++id);
    });
    test("Block transaction count by number - latest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.latest = true;
      final int count = await client.getBlockTransactionCountByNumber(block);
      expect(count, isNotNull);
      expect(client.id, ++id);
    });
    test("Block transaction count by number - pending", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.pending = true;
      final int count = await client.getBlockTransactionCountByNumber(block);
      expect(count, isNotNull);
      expect(client.id, ++id);
    });
    test("Block transaction count by number - earliest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.earliest = true;
      final int count = await client.getBlockTransactionCountByNumber(block);
      expect(count, isNotNull);
      expect(client.id, ++id);
    });
    test("Block uncle count by hash", () async {
      final int count = await client.getUncleCountByHash(MoacUtilities.safeParse(
          "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"));
      expect(count, 0);
      expect(client.id, ++id);
    });
    test("Uncle count by number - number", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0xe8;
      final int count = await client.getUncleCountByNumber(block);
      expect(count, isNotNull);
      expect(client.id, ++id);
    });
    test("Block uncle count by number - latest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.latest = true;
      final int count = await client.getUncleCountByNumber(block);
      expect(count, isNotNull);
      expect(client.id, ++id);
    });
    test("Block uncle count by number - pending", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.pending = true;
      final int count = await client.getUncleCountByNumber(block);
      expect(count, isNotNull);
      expect(client.id, ++id);
    });
    test("Block uncle count by number - earliest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.earliest = true;
      final int count = await client.getUncleCountByNumber(block);
      expect(count, isNotNull);
      expect(client.id, ++id);
    });
    test("Code - address", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0;
      final int code = await client.getCode(
          MoacUtilities.safeParse("0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b"),
          block);
      expect(code, isNull);
      expect(client.id, ++id);
      print("Code is $code");
    });
    test("Code - latest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.latest = true;
      final int code = await client.getCode(
          MoacUtilities.safeParse("0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b"),
          block);
      expect(code, isNull);
      expect(client.id, ++id);
      print("Code is $code");
    });
    test("Code - pending", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.pending = true;
      final int code = await client.getCode(
          MoacUtilities.safeParse("0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b"),
          block);
      expect(code, isNull);
      expect(client.id, ++id);
      print("Code is $code");
    });
    test("Code - earliest", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.earliest = true;
      final int code = await client.getCode(
          MoacUtilities.safeParse("0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b"),
          block);
      expect(code, isNull);
      expect(client.id, ++id);
      print("Code is $code");
    });
    test("Sign", () async {
      final int signature =
          await client.sign(MoacTestConfiguration.defaultAccount, 0xdeadbeaf);
      if (signature != null) {
        print(signature);
      } else {
        print("You must unlock your account for this method to work");
      }
      expect(client.id, ++id);
    });
    test("Send transaction", () async {
      final int hash = await client.sendTransaction(
          MoacTestConfiguration.defaultAccount,
          MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"),
          to: MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8058bb8eb970870f07244567"),
          gas: 0x100,
          gasPrice: 0x1000,
          value: 0x2000,
          nonce: 2);
      if (hash != null) {
        print(hash);
      }
      expect(client.id, ++id);
      expect(client.lastError.id, id);
    });
    test("Send transaction - some null", () async {
      final int hash = await client.sendTransaction(
          MoacTestConfiguration.defaultAccount,
          MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"),
          to: MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8058bb8eb970870f07244567"),
          nonce: 2);
      if (hash != null) {
        print(hash);
      }
      expect(client.id, ++id);
      expect(client.lastError.id, id);
    });
    test("Send raw transaction", () async {
      final int hash = await client.sendRawTransaction(MoacUtilities.safeParse(
          "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"));
      if (hash != null) {
        print(hash);
      }
      expect(client.id, ++id);
      expect(client.lastError.id, id);
    });
    test("Call ", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0x10;
      final int ret = await client.call(
          MoacTestConfiguration.defaultAccount, block,
          from: MoacUtilities.safeParse(
              "0xd10de988e845d33859c3f96c7f1fc723b7b56f4c"),
          gas: 0x2000,
          gasPrice: 0x1000,
          value: 0x2000,
          data: MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"));
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Call - some null", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.latest = true;
      final int ret = await client.call(
          MoacTestConfiguration.defaultAccount, block,
          from: MoacUtilities.safeParse(
              "0xd10de988e845d33859c3f96c7f1fc723b7b56f4c"),
          gasPrice: 0x1000,
          data: MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"));
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Estimate gas", () async {
      final int ret = await client.estimateGas(
          address: MoacTestConfiguration.defaultAccount,
          from: MoacUtilities.safeParse(
              "0xd10de988e845d33859c3f96c7f1fc723b7b56f4c"),
          gas: 0x2000,
          gasPrice: 0x1000,
          value: 0x2000,
          data: MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"));
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Estimate gas - some null", () async {
      final int ret = await client.estimateGas(
          address: MoacTestConfiguration.defaultAccount,
          from: MoacUtilities.safeParse(
              "0xd10de988e845d33859c3f96c7f1fc723b7b56f4c"),
          gas: 0x2000,
          gasPrice: 0x1000);
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get block by hash", () async {
      final MoacBlock ret = await client.getBlockByHash(MoacUtilities.safeParse(
          "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8"));
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get block by number", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0x01;
      final MoacBlock ret = await client.getBlockByNumber(block);
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get transaction by hash", () async {
      final MoacTransaction ret = await client.getTransactionByHash(
          MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8"));
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get transaction by block hash and index", () async {
      final MoacTransaction ret = await client.getTransactionByBlockHashAndIndex(
          MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8"),
          0);
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get transaction by block number and index", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0x100;
      final MoacTransaction ret =
          await client.getTransactionByBlockNumberAndIndex(block, 0);
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get transaction receipt", () async {
      final MoacTransactionReceipt ret = await client.getTransactionReceipt(
          MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8"));
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get uncle by block hash and index", () async {
      final MoacBlock ret = await client.getUncleByBlockHashAndIndex(
          MoacUtilities.safeParse(
              "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8"),
          0);
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get uncle by block number and index", () async {
      final MoacDefaultBlock block = MoacDefaultBlock();
      block.number = 0x100;
      final MoacBlock ret =
          await client.getUncleByBlockNumberAndIndex(block, 0);
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    int filterId = 0;
    test("New filter - address", () async {
      final MoacDefaultBlock from = MoacDefaultBlock();
      from.number = 1;
      final MoacDefaultBlock to = MoacDefaultBlock();
      from.number = 2;
      filterId = await client.newFilter(
          fromBlock: from,
          toBlock: to,
          address: MoacUtilities.safeParse(
              "0x8888f1f195afa192cfee860698584c030f4c9db1"),
          topics: [
            MoacUtilities.safeParse(
                "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b"),
            MoacUtilities.safeParse(
                "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b")
          ]);
      if (filterId != null) {
        print(filterId);
      }
      expect(client.id, ++id);
    });
    test("New filter - address list", () async {
      final MoacDefaultBlock from = MoacDefaultBlock();
      from.number = 1;
      final MoacDefaultBlock to = MoacDefaultBlock();
      from.number = 2;
      filterId = await client.newFilter(fromBlock: from, toBlock: to, address: [
        MoacUtilities.safeParse("0x8888f1f195afa192cfee860698584c030f4c9db1"),
        MoacUtilities.safeParse("0x8888f1f195afa192cfee860698584c030f4c9db2")
      ], topics: [
        MoacUtilities.safeParse(
            "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b"),
        MoacUtilities.safeParse(
            "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b")
      ]);
      if (filterId != null) {
        print(filterId);
      }
      expect(client.id, ++id);
    });
    test("New block filter", () async {
      final int filterId = await client.newBlockFilter();
      if (filterId != null) {
        print(filterId);
      }
      expect(client.id, ++id);
    });
    int pendFilterId = 0;
    test("New pending transaction filter", () async {
      pendFilterId = await client.newPendingTransactionFilter();
      if (filterId != null) {
        print(filterId);
      }
      expect(client.id, ++id);
    });
    test("Uninstall filter", () async {
      if (pendFilterId == null) {
        return;
      }
      final bool res = await client.uninstallFilter(pendFilterId);
      expect(res, isNotNull);
      expect(client.id, ++id);
    });
    test("Get filter changes", () async {
      final dynamic ret = await client.getFilterChanges(0);
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get filter logs", () async {
      final dynamic ret = await client.getFilterLogs(0);
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get logs", () async {
      final MoacDefaultBlock from = MoacDefaultBlock();
      final MoacDefaultBlock to = MoacDefaultBlock();
      to.earliest = true;
      final MoacFilter ret = await client.getLogs(
          fromBlock: from,
          toBlock: to,
          address: MoacUtilities.safeParse(
              "0x8888f1f195afa192cfee860698584c030f4c9db2"),
          topics: [
            MoacUtilities.safeParse(
                "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b")
          ]);
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Get work", () async {
      final MoacWork ret = await client.getWork();
      if (ret != null) {
        print(ret);
      }
      expect(client.id, ++id);
    });
    test("Submit work", () async {
      final bool ret = await client.submitWork(
          MoacUtilities.safeParse("0x123456789abcdef0"),
          MoacUtilities.safeParse(
              "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"),
          MoacUtilities.safeParse(
              "0xD1FE5700000000000000000000000000D1FE5700000000000000000000000000"));
      expect(ret, isFalse);
      expect(client.id, ++id);
    });
    test("new Account", () async {
      final String ret = await client.newAccount("abc");
      expect(ret,isNotNull);
      print(ret);
    });
  }
}
