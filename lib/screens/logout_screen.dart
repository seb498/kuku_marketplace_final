import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'landing_screen.dart'; // 🔁 Replace with your actual public marketplace screen

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logged Out"),
        centerTitle: true,
        backgroundColor: const Color(0xFF558B2F),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F8E9), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 80, color: Color(0xFF558B2F)),
            const SizedBox(height: 24),
            const Text(
              'You have been logged out successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF33691E),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text("Login Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF558B2F),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
            const SizedBox(height: 16),

            OutlinedButton.icon(
              icon: const Icon(Icons.storefront, color: Color(0xFF558B2F)),
              label: const Text(
                "Go to Public Marketplace",
                style: TextStyle(color: Color(0xFF558B2F)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF558B2F)),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LandingScreen(),
                  ), // Replace if needed
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
