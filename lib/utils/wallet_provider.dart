import 'package:flutter/foundation.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:web3dart/web3dart.dart';

class WalletProvider {
  static String? _userAddress;
  static bool _isConnected = false;
  static double? _balance;

  static Future<bool> connectWallet() async {
    if (ethereum != null) {
      try {
        final accounts = await ethereum!.requestAccount();
        if (accounts.isNotEmpty) {
          _userAddress = accounts.first;
          _isConnected = true;
          await _fetchBalance();
          return true;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error connecting to MetaMask: $e');
        }
      }
    }
    return false;
  }

  static Future<void> _fetchBalance() async {
    if (_userAddress != null && provider != null) {
      final rawBalance = await provider!.getBalance(_userAddress!);
      _balance =
          EtherAmount.inWei(
            rawBalance,
          ).getValueInUnit(EtherUnit.ether).toDouble();
    }
  }

  static bool isWalletConnected() => _isConnected;

  static String? getWalletAddress() => _userAddress;

  static double? getBalance() => _balance;

  static void disconnect() {
    _userAddress = null;
    _isConnected = false;
    _balance = null;
  }
}
