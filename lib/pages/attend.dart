import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blockchain/contract_service.dart';

class AttendPage extends StatefulWidget {
  const AttendPage({super.key});

  @override
  State<AttendPage> createState() => _AttendPageState();
}

class _AttendPageState extends State<AttendPage> {
  final TextEditingController roleController = TextEditingController();
  int? selectedOption;
  String question = '';
  List<String> options = [];
  int pollId = -1;

  Future<void> fetchPoll() async {
    try {
      int id = await ContractService.getPollIdByRole(roleController.text);
      var poll = await ContractService.getResults(id);

      setState(() {
        pollId = id;
        question = poll[0];
        options = List<String>.from(poll[1]);
        selectedOption = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter valid role")));
    }
  }

  Future<void> submitVote() async {
    if (selectedOption == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an option")));
      return;
    }

    await ContractService.vote(pollId, selectedOption!);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vote submitted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left image
          SizedBox(
            width: screenWidth * 0.4,
            height: double.infinity,
            child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.black, Colors.transparent],
                      stops: [0.3, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset('assets/attend.png', fit: BoxFit.cover),
                )
                .animate()
                .slideX(begin: -0.05)
                .fadeIn(duration: 800.ms, delay: 300.ms),
          ),

          // Right side
          Expanded(
            child: Center(
              child: Container(
                    width: 600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 36,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Attend a Poll",
                                  style: GoogleFonts.dmSerifText(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                TextField(
                                  controller: roleController,
                                  decoration: InputDecoration(
                                    labelText: "Enter Role",
                                    labelStyle: GoogleFonts.abel(fontSize: 16),
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: fetchPoll,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      128,
                                      225,
                                      255,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Fetch Poll",
                                    style: GoogleFonts.abel(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // Show question and options
                                if (question.isNotEmpty) ...[
                                  Text(
                                    question,
                                    style: GoogleFonts.abel(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  for (int i = 0; i < options.length; i++)
                                    ListTile(
                                      title: Text(
                                        options[i],
                                        style: GoogleFonts.abel(fontSize: 16),
                                      ),
                                      leading: Radio<int>(
                                        value: i,
                                        groupValue: selectedOption,
                                        onChanged: (int? value) {
                                          setState(() {
                                            selectedOption = value;
                                          });
                                        },
                                      ),
                                    ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: submitVote,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        128,
                                        225,
                                        255,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Submit Vote",
                                      style: GoogleFonts.abel(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .slideX(begin: 0.05)
                  .fadeIn(duration: 800.ms, delay: 300.ms),
            ),
          ),
        ],
      ),
    );
  }
}
