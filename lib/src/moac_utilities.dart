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

/// General client support utilities
class MoacUtilities {
  /// Common pad values for intToHex
  static const int pad4 = 4;
  static const int pad8 = 8;
  static const int pad16 = 16;
  static const int pad32 = 32;

  /// Integer to hex string with leading 0x, lowercase.
  /// The optional pad value pads the string out to the number of bytes
  /// specified, i.e if 8 is specified the string 0x1 becomes 0x0000000000000001
  /// default is 0, no padding.The pad value must be even and positive.
  static String intToHex(int val, [int pad = 0]) {
    String ret = val.toRadixString(16);
    if (pad != 0) {
      if (pad.isNegative || pad.isOdd) {
        throw FormatException(
            "MoacUtilities:: intToHex - invalid pad value, $pad");
      }
      if (ret.length.isOdd) {
        ret = '0' + ret;
      }
      final int bytes = (ret.length / 2).round();
      if (bytes != pad) {
        final int zeroNum = (pad - bytes);
        for (int i = 0; i < zeroNum; i++) {
          ret = '00' + ret;
        }
      }
    }
    return '0x' + ret;
  }

  /// BigInt to hex string
  static String bigIntegerToHex(BigInt val) {
    return '0x' + val.toRadixString(16);
  }

  /// Hex string to integer, a value of null indicates an error.
  /// The string must start with 0x
  static int hexToInt(String val) {
    final int temp = int.tryParse(val);
    if (temp == null) {
      return null;
    }
    return temp;
  }

  /// Hex String list to Integer list
  static List<int> hexToIntList(List<String> val) {
    return List<int>.generate(val.length, (int index) => hexToInt(val[index]));
  }

  /// Hex String list to BigInt list
  static List<BigInt> hexToBigIntList(List val) {
    return List<BigInt>.generate(
        val.length, (int index) => MoacUtilities.safeParse(val[index]));
  }

  /// Integer list to Hex String list
  static List<String> intToHexList(List<int> val) {
    return List<String>.generate(
        val.length, (int index) => intToHex(val[index]));
  }

  /// BigInt list to Hex String list
  static List<String> bigIntegerToHexList(List<BigInt> val) {
    return List<String>.generate(
        val.length, (int index) => '0x' + val[index].toRadixString(16));
  }

  /// Remove null values from a map
  static Map removeNull(Map theMap) {
    final List values = theMap.values.toList();
    final List keys = theMap.keys.toList();
    int index = 0;
    for (dynamic val in values) {
      if (val == null) {
        theMap.remove(keys[index]);
      }
      index++;
    }
    return theMap;
  }

  /// Safe parser for BigInt, returns BigInt.zero if the parse fails
  /// Geth sometimes returns '0x' rather than '0x00'
  static BigInt safeParse(String val) {
    final BigInt temp = BigInt.tryParse(val);
    if (temp == null) {
      return BigInt.zero;
    }
    return temp;
  }

// the following is dart version of uttilities from chain3
  var MC_UNTIS = const [
    'sha',
    'ksha',
    'Msha',
    'Gsha',
    'femtomc',
    'picomc',
    'nanomc',
    'micromc',
    'millimc',
    'nano',
    'micro',
    'milli',
    'mc',
    'grand',
    'Mmc',
    'Gmc',
    'Tmc',
    'Pmc',
    'Emc',
    'Zmc',
    'Ymc',
    'Nmc',
    'Dmc',
    'Vmc',
    'Umc'
  ];
  var MC_PADDING = 32,
      MC_SIGNATURE_LENGTH = 4,
      MC_POLLING_TIMEOUT = 1000 / 2,
      defaultBlock = 'latest',
      defaultAccount = '';
  //MC_BIGNUMBER_ROUNDING_MODE= { ROUNDING_MODE: BigNumber.ROUND_DOWN },
  //above from config.js

  var msg = {
    "genesisGasLimit": {"v": 5000, "d": "Gas limit of the Genesis block."},
    "genesisDifficulty": {
      "v": 17179869184,
      "d": "Difficulty of the Genesis block."
    },
    "genesisNonce": {"v": "0x0000000000000042", "d": "the geneis nonce"},
    "genesisExtraData": {
      "v": "0x11bbe8db4e347b4e8c937c1c8370e4b5ed33adb3db69cbdb7a38e1e50b1b82fa",
      "d": "extra data "
    },
    "genesisHash": {
      "v": "0xd4e56740f876aef8c010b86a40d5f56745a118d0906a34e69aec8c0db1cb8fa3",
      "d": "genesis hash"
    },
    "genesisStateRoot": {
      "v": "0xd7f8974fb5ac78d9ac099b9ad5018bedc2ce0a72dad1827a1709da30580f0544",
      "d": "the genesis state root"
    },
    "minGasLimit": {"v": 5000, "d": "Minimum the gas limit may ever be."},
    "gasLimitBoundDivisor": {
      "v": 1024,
      "d": "The bound divisor of the gas limit, used in update calculations."
    },
    "minimumDifficulty": {
      "v": 131072,
      "d": "The minimum that the difficulty may ever be."
    },
    "difficultyBoundDivisor": {
      "v": 2048,
      "d":
          "The bound divisor of the difficulty, used in the update calculations."
    },
    "durationLimit": {
      "v": 13,
      "d":
          "The decision boundary on the blocktime duration used to determine whether difficulty should go up or not."
    },
    "maximumExtraDataSize": {
      "v": 32,
      "d": "Maximum size extra data may be after Genesis."
    },
    "epochDuration": {
      "v": 30000,
      "d": "Duration between proof-of-work epochs."
    },
    "stackLimit": {"v": 1024, "d": "Maximum size of VM stack allowed."},
    "callCreateDepth": {"v": 1024, "d": "Maximum depth of call/create stack."},
    "tierStepGas": {
      "v": [0, 2, 3, 5, 8, 10, 20],
      "d": "Once per operation, for a selection of them."
    },
    "expGas": {"v": 10, "d": "Once per EXP instuction."},
    "expByteGas": {
      "v": 10,
      "d": "Times ceil(log256(exponent)) for the EXP instruction."
    },
    "sha3Gas": {"v": 30, "d": "Once per SHA3 operation."},
    "sha3WordGas": {"v": 6, "d": "Once per word of the SHA3 operation's data."},
    "sloadGas": {"v": 50, "d": "Once per SLOAD operation."},
    "sstoreSetGas": {
      "v": 20000,
      "d": "Once per SSTORE operation if the zeroness changes from zero."
    },
    "sstoreResetGas": {
      "v": 5000,
      "d":
          "Once per SSTORE operation if the zeroness does not change from zero."
    },
    "sstoreRefundGas": {
      "v": 15000,
      "d": "Once per SSTORE operation if the zeroness changes to zero."
    },
    "jumpdestGas": {
      "v": 1,
      "d":
          "Refunded gas, once per SSTORE operation if the zeroness changes to zero."
    },
    "logGas": {"v": 375, "d": "Per LOG* operation."},
    "logDataGas": {"v": 8, "d": "Per byte in a LOG* operation's data."},
    "logTopicGas": {
      "v": 375,
      "d":
          "Multiplied by the * of the LOG*, per LOG transaction. e.g. LOG0 incurs 0 * c_txLogTopicGas, LOG4 incurs 4 * c_txLogTopicGas."
    },
    "createGas": {
      "v": 32000,
      "d": "Once per CREATE operation & contract-creation transaction."
    },
    "callGas": {
      "v": 40,
      "d": "Once per CALL operation & message call transaction."
    },
    "callStipend": {"v": 2300, "d": "Free gas given at beginning of call."},
    "callValueTransferGas": {
      "v": 9000,
      "d": "Paid for CALL when the value transfor is non-zero."
    },
    "callNewAccountGas": {
      "v": 25000,
      "d": "Paid for CALL when the destination address didn't exist prior."
    },
    "suicideRefundGas": {
      "v": 24000,
      "d": "Refunded following a suicide operation."
    },
    "memoryGas": {
      "v": 3,
      "d":
          "Times the address of the (highest referenced byte in memory + 1). NOTE: referencing happens on read, write and in instructions such as RETURN and CALL."
    },
    "quadCoeffDiv": {
      "v": 512,
      "d": "Divisor for the quadratic particle of the memory cost equation."
    },
    "createDataGas": {"v": 200, "d": ""},
    "txGas": {
      "v": 1000,
      "d":
          "Per transaction. NOTE: Not payable on data of calls between transactions."
    },
    "txCreation": {"v": 32000, "d": "the cost of creating a contract via tx"},
    "txDataZeroGas": {
      "v": 4,
      "d":
          "Per byte of data attached to a transaction that equals zero. NOTE: Not payable on data of calls between transactions."
    },
    "txDataNonZeroGas": {
      "v": 68,
      "d":
          "Per byte of data attached to a transaction that is not equal to zero. NOTE: Not payable on data of calls between transactions."
    },
    "copyGas": {
      "v": 3,
      "d":
          "Multiplied by the number of 32-byte words that are copied (round up) for any *COPY operation and added."
    },
    "ecrecoverGas": {"v": 3000, "d": ""},
    "sha256Gas": {"v": 60, "d": ""},
    "sha256WordGas": {"v": 12, "d": ""},
    "ripemd160Gas": {"v": 600, "d": ""},
    "ripemd160WordGas": {"v": 120, "d": ""},
    "identityGas": {"v": 15, "d": ""},
    "identityWordGas": {"v": 3, "d": ""},
    "freeBlockPeriod": {"v": 2}
  };

  // above from params.json
  static String sha3(value, options) {
    if (options && options.encoding == 'hex') {
      if (value.length > 2 && value.substring(0, 2) == '0x') {
        value = value.substr(2);
      }
      value = CryptoJS.enc.Hex.parse(value);
    }

    return sha3(value, {outputLength: 256}).toString();
  }
}
