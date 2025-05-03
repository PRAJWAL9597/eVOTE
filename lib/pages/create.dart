import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blockchain/contract_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers = [
    TextEditingController(),
  ];
  final TextEditingController durationController = TextEditingController();

  void addOptionField() {
    setState(() {
      optionControllers.add(TextEditingController());
    });
  }

  Future<void> createPoll() async {
    if (questionController.text.isEmpty ||
        optionControllers.any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    int duration = int.tryParse(durationController.text) ?? 0;
    if (duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Duration must be a positive number")),
      );
      return;
    }

    List<String> options = optionControllers.map((c) => c.text).toList();
    await ContractService.createPoll(
      questionController.text,
      options,
      duration,
    );

    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(const SnackBar(content: Text("Poll created successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left Image
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
                  child: Image.asset('assets/create.png', fit: BoxFit.cover),
                )
                .animate()
                .slideX(begin: -0.05)
                .fadeIn(duration: 800.ms, delay: 300.ms),
          ),

          // Form Section
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
                        children: [
                          // Back Button Row
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFFFF80AB),
                                ),
                                onPressed: () => Navigator.pop(context),
                                tooltip: "Back",
                              ),
                            ],
                          ),
                          Text(
                            "Create a New Poll",
                            style: GoogleFonts.abel(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: questionController,
                            decoration: InputDecoration(
                              labelText: "Role",
                              labelStyle: GoogleFonts.abel(fontSize: 16),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...optionControllers.map(
                            (controller) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  labelText: "Participants",
                                  labelStyle: GoogleFonts.abel(fontSize: 16),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: addOptionField,
                              icon: const Icon(Icons.add, color: Colors.black),
                              label: Text(
                                "Add Participants",
                                style: GoogleFonts.abel(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Duration (in seconds)",
                              labelStyle: GoogleFonts.abel(fontSize: 16),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: createPoll,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF80AB),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Create Poll",
                              style: GoogleFonts.abel(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
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
