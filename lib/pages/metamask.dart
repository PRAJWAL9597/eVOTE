import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/wallet_provider.dart';
import 'home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MetaMaskLoginPage extends StatefulWidget {
  const MetaMaskLoginPage({super.key});

  @override
  State<MetaMaskLoginPage> createState() => _MetaMaskLoginPageState();
}

class _MetaMaskLoginPageState extends State<MetaMaskLoginPage> {
  Future<void> loginWithMetaMask() async {
    await WalletProvider.connectWallet();
    if (WalletProvider.isWalletConnected()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/metamask-fox.svg',
                      width: 100,
                      height: 100,
                    ).animate().fadeIn(duration: 800.ms).scale(delay: 300.ms),

                    const SizedBox(height: 32),

                    Text(
                          '" Connect to MetaMask "',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSerifText(
                            fontSize: 60,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF202124),
                          ),
                        )
                        .animate()
                        .slideY(begin: -0.3, curve: Curves.easeOutBack)
                        .fadeIn(duration: 800.ms, delay: 300.ms),

                    const SizedBox(height: 12),

                    Text(
                      '''Authenticate securely and access your voting dashboard.''',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.abel(
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF5F6368),
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

                    const SizedBox(height: 48),

                    ElevatedButton(
                      onPressed: loginWithMetaMask,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 45,
                          vertical: 18,
                        ),
                        backgroundColor: const Color.fromARGB(
                          255,
                          64,
                          192,
                          173,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 6,
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () {
                        launchUrl(
                          Uri.parse('https://metamask.io/download.html'),
                        );
                      },
                      child: Text(
                        "Don't have MetaMask? Get the extension",
                        style: GoogleFonts.abel(
                          fontSize: 16,
                          color: Color(0xFF202124),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ).animate().fadeIn(delay: 900.ms),
                  ],
                ),
              ),
            ),
          ),

          // Right Side Image
          SizedBox(
            width: screenWidth * 0.4,
            height: double.infinity,
            child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.black, Colors.transparent],
                      stops: [0.3, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset('assets/bgb.png', fit: BoxFit.cover),
                )
                .animate()
                .slideX(begin: 0.05)
                .fadeIn(duration: 800.ms, delay: 300.ms),
          ),
        ],
      ),
    );
  }
}
