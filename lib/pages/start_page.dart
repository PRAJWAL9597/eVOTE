import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class StartPage extends StatelessWidget {
  StartPage({super.key});

  final List<Map<String, String>> techStack = [
    {
      "title": "Flutter",
      "desc": "Build beautiful UIs with a single codebase.",
      "url": "https://flutter.dev/",
    },
    {
      "title": "Solidity",
      "desc": "Smart contract language for Ethereum.",
      "url": "https://soliditylang.org/",
    },
    {
      "title": "MetaMask",
      "desc": "Connect users to the blockchain securely.",
      "url": "https://metamask.io/",
    },
    {
      "title": "flutter_web3",
      "desc": "Flutter package for Web3 interactions.",
      "url": "https://pub.dev/packages/flutter_web3",
    },
  ];

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left side image
          SizedBox(
            width: screenWidth * 0.4,
            height: double.infinity,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.black, Colors.transparent],
                  stops: [0.2, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset('assets/bg.png', fit: BoxFit.cover),
            ).animate().slideX(begin: -0.05).fadeIn(duration: 800.ms),
          ),

          // Right side content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to eVOTE",
                    style: GoogleFonts.dmSerifText(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),
                  const SizedBox(height: 20),

                  Text(
                    "Why eVOTE?",
                    style: GoogleFonts.abel(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Transparent. Decentralized. Private.\nCreate, attend, and verify polls securely on the blockchain.",
                    style: GoogleFonts.abel(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Text(
                    "Tech Stack",
                    style: GoogleFonts.abel(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ).animate().fadeIn(duration: 600.ms),
                  const SizedBox(height: 10),

                  // Scrollable Tech Stack Section
                  Expanded(
                    child: ListView.builder(
                      itemCount: techStack.length,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      itemBuilder: (context, index) {
                        final isLeft = index % 2 == 0;
                        final tech = techStack[index];

                        return Column(
                          children: [
                            Align(
                              alignment:
                                  isLeft
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => _launchURL(tech["url"]!),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  padding: const EdgeInsets.all(18),
                                  width: screenWidth * 0.38,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.orange.shade400,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        // ignore: deprecated_member_use
                                        color: Colors.orange.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tech["title"]!,
                                        style: GoogleFonts.abel(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        tech["desc"]!,
                                        style: GoogleFonts.abel(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate().fadeIn().slideX(
                                begin: isLeft ? -0.1 : 0.1,
                                duration: 600.ms,
                                curve: Curves.easeOut,
                              ),
                            ),

                            // Vertical line between boxes
                            if (index < techStack.length - 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 2,
                                    height: 20,
                                    // ignore: deprecated_member_use
                                    color: Colors.orange.shade300.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Try Now Button (moved slightly down)
                  const SizedBox(height: 25),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/metamask');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Try Now",
                        style: GoogleFonts.abel(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
