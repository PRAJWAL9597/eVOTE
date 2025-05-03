import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import '../blockchain/contract_service.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final TextEditingController roleController = TextEditingController();
  String question = "";
  List<String> options = [];
  List<int> voteCounts = [];
  Map<String, double> pieData = {};
  Map<String, Color> customColors = {};

  final List<Color> pieColors = [
    Color(0xFFe74c3c), // red
    Color(0xFF8e44ad), // purple
    Color(0xFF3498db), // blue
    Color(0xFFf1c40f), // yellow
    Color(0xFF2ecc71), // green
    Color(0xFFe67e22), // orange
    Color(0xFF1abc9c), // turquoise
    Color(0xFF34495e), // dark blue
  ];

  Future<void> fetchResults() async {
    try {
      final pollId = await ContractService.getPollIdByRole(roleController.text);
      final results = await ContractService.getResults(pollId);
      setState(() {
        question = results[0];
        options = List<String>.from(results[1]);
        voteCounts = List<int>.from(results[2]);

        // Prepare pie chart data
        pieData = {};
        customColors = {};
        for (int i = 0; i < options.length; i++) {
          pieData[options[i]] = voteCounts[i].toDouble();
          customColors[options[i]] = pieColors[i % pieColors.length];
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
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
                  child: Image.asset('assets/result.png', fit: BoxFit.cover),
                )
                .animate()
                .slideX(begin: -0.05)
                .fadeIn(duration: 800.ms, delay: 300.ms),
          ),

          // Right Panel
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Poll Results",
                                  style: GoogleFonts.dmSerifText(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                TextField(
                                  controller: roleController,
                                  decoration: InputDecoration(
                                    labelText: "Role",
                                    labelStyle: GoogleFonts.abel(fontSize: 16),
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: fetchResults,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      190,
                                      190,
                                      189,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 14,
                                    ),
                                  ),
                                  child: Text(
                                    "Fetch Results",
                                    style: GoogleFonts.abel(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Display results
                                if (question.isNotEmpty) ...[
                                  Text(
                                    question,
                                    style: GoogleFonts.abel(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  for (int i = 0; i < options.length; i++)
                                    Text(
                                      "${options[i]}: ${voteCounts[i]} vote(s)",
                                      style: GoogleFonts.abel(fontSize: 18),
                                    ),
                                  const SizedBox(height: 30),

                                  // Pie Chart
                                  if (pieData.isNotEmpty)
                                    PieChart(
                                      dataMap: pieData,
                                      animationDuration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      chartRadius: 180,
                                      chartType: ChartType.disc,
                                      baseChartColor: const Color.fromARGB(
                                        255,
                                        49,
                                        47,
                                        47,
                                      ),
                                      colorList: customColors.values.toList(),
                                      chartValuesOptions:
                                          const ChartValuesOptions(
                                            showChartValues: true,
                                            showChartValuesInPercentage: true,
                                            showChartValueBackground: false,
                                          ),
                                      legendOptions: const LegendOptions(
                                        showLegends: true,
                                        legendPosition: LegendPosition.bottom,
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
