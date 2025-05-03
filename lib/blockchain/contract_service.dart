import 'package:flutter_web3/flutter_web3.dart';
import './config.dart';

class ContractService {
  static Contract? _contract;

  static Future<void> initializeContract() async {
    final provider = Web3Provider(ethereum!);
    final signer = provider.getSigner();
    _contract = Contract(contractAddress, Interface(contractABI), signer);
  }

  static Future<void> createPoll(
    String question,
    List<String> options,
    int duration,
  ) async {
    await initializeContract();
    await _contract!.send('createPoll', [question, options, duration]);
  }

  static Future<void> vote(int pollId, int optionIndex) async {
    await initializeContract();
    await _contract!.send('vote', [pollId, optionIndex]);
  }

  static Future<List<dynamic>> getResults(int pollId) async {
    await initializeContract();
    return await _contract!.call('getResults', [pollId]);
  }

  static Future<int> getPollIdByRole(String role) async {
    await initializeContract();
    return await _contract!.call('getPollIdByRole', [role]);
  }
}
