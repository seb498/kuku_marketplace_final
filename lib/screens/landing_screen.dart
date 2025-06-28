import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'public_marketplace_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 🐔 App Name
            const Text(
              '🐓 Kuku Marketplace',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Connecting Farmers with Customers',
              style: TextStyle(fontSize: 16, color: Colors.brown),
            ),

            const SizedBox(height: 30),

            // 📋 Features
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  FeatureTile(
                    icon: Icons.add_box,
                    title: 'Farmers List Products',
                    subtitle: 'Eggs, Meat, and Live Chickens',
                  ),
                  FeatureTile(
                    icon: Icons.shopping_cart,
                    title: 'Customers Browse & Buy',
                    subtitle: 'Find fresh products easily',
                  ),
                  FeatureTile(
                    icon: Icons.admin_panel_settings,
                    title: 'Admin Oversight',
                    subtitle: 'Manage listings and users',
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 🔘 Browse Marketplace Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PublicMarketplaceScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Browse Marketplace',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            // 🔐 Login Link
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Already have an account? Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.brown),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
