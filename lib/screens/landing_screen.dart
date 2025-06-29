import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'public_marketplace_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8BC34A), Color(0xFFF1F8E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                // 🐔 App Name
                const Text(
                  '🐓 Kuku Marketplace',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF558B2F),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Connecting Farmers with Customers',
                  style: TextStyle(fontSize: 16, color: Color(0xFF33691E)),
                ),
                const SizedBox(height: 20),

                // 📝 What it Does
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white.withOpacity(0.95),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          Text(
                            'What is Kuku Marketplace?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF558B2F),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Kuku Marketplace is a digital platform that connects poultry farmers directly with customers. '
                            'Farmers can showcase and sell their eggs, meat, or live chickens, while customers browse, order, and rate farmers easily.',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          FeatureTile(
                            icon: Icons.add_box,
                            title: 'Farmers List Products',
                            subtitle: 'Eggs, Meat, and Live Chickens',
                          ),
                          FeatureTile(
                            icon: Icons.shopping_cart,
                            title: 'Customers Browse & Buy',
                            subtitle: 'Find fresh poultry products fast',
                          ),
                          FeatureTile(
                            icon: Icons.reviews,
                            title: 'Ratings & Reviews',
                            subtitle: 'Help others pick the best farmer',
                          ),
                          FeatureTile(
                            icon: Icons.admin_panel_settings,
                            title: 'Admin Oversight',
                            subtitle: 'Manages listings, users, and feedback',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🔘 Browse Marketplace Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF558B2F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Color(0xFF33691E)),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, size: 30, color: Color(0xFF8BC34A)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
