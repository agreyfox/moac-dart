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

/// An Moac work message.
/// All elements of the work message must be present.
class MoacWork {
  MoacWork();

  MoacWork.fromList(List result) {
    construct(result);
  }

  /// Current block header pow-hash
  BigInt _powHash;

  BigInt get powHash => _powHash;

  /// Seed hash used for the DAG.
  BigInt _seedHash;

  BigInt get seedHash => _seedHash;

  /// The boundary condition ("target"), 2^256 / difficulty.
  BigInt _boundaryCondition;

  BigInt get boundaryCondition => _boundaryCondition;

  /// Construct from the supplied Map, only check for the keys we need.
  void construct(List data) {
    if (data == null) {
      return;
    }
    if (data.length != 3) {
      return;
    }
    _powHash = MoacUtilities.safeParse(data[0]);
    _seedHash = MoacUtilities.safeParse(data[1]);
    _boundaryCondition = MoacUtilities.safeParse(data[2]);
  }

  // To string
  String toString() {
    final String ret = "Moac Work :" +
        "\n" +
        "  Pow Hash : $powHash" +
        "\n" +
        "  Seed Hash : $seedHash" +
        "\n" +
        "  Boundary Condition : $boundaryCondition" +
        "\n";

    return ret;
  }
}
