import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'public_marketplace_screen.dart';

// Screens for pages
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF558B2F),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Kukumarketplace — your trusted digital marketplace connecting poultry farmers directly with buyers.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33691E),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'At Kukumarketplace, we understand the challenges poultry farmers face in reaching customers directly. Middlemen often reduce farmers’ profits, making it difficult for them to grow their businesses sustainably. At the same time, consumers struggle to find fresh, affordable poultry products conveniently.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Our mission is to bridge this gap by providing a simple, secure, and transparent platform where poultry farmers can easily list their products, manage orders, communicate with buyers, and process payments with confidence. By removing unnecessary intermediaries, we help farmers maximize their earnings while offering buyers access to quality poultry products at fair prices.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'We believe in empowering local farmers and promoting a healthier, more direct supply chain that benefits everyone.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Join us in transforming poultry trading — fresh, fair, and just a few clicks away.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF558B2F),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Kukumarketplace Help Center! Here you’ll find answers to common questions and tips to get the most out of our platform.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33691E),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Getting Started',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'How do I create an account?\nClick on the Sign Up button and fill in your details as either a poultry farmer or buyer. Verify your email to activate your account.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'How do I list my poultry products?\nFarmers can add new products by navigating to the My Products section and clicking Add Product. Fill in the details such as type, quantity, price, and upload clear photos.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Ordering & Payments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'How can buyers place an order?\nBrowse available products, select what you want, and click Order Now. You will receive an order confirmation and estimated delivery details.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'What payment methods are accepted?\nWe support secure online payments including mobile money and credit/debit cards to ensure smooth transactions.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'Can I track my order?\nYes! Once your order is confirmed, you can track its status in the My Orders section.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Communication',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'How can I communicate with buyers or farmers?\nUse the built-in messaging system to chat directly and clarify any details before finalizing orders.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Troubleshooting',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'I forgot my password. What do I do?\nClick on Forgot Password on the login page, enter your registered email, and follow the instructions to reset your password.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'I’m having trouble with payment. Who do I contact?\nPlease reach out to our support team via the Contact Us page or email mutuaseb@gmail.com for assistance.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Policies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Where can I find Kukumarketplace’s privacy policy and terms of service?\nLinks to our Privacy Policy and Terms of Service are located at the bottom of every page.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: const Color(0xFF558B2F),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need more help? We’re here for you!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33691E),
              ),
            ),
            SizedBox(height: 24),
            Text(
              '📞 Call or WhatsApp:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('0723 598 936\n0798 377 275', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text(
              '📧 Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('mutuaseb@gmail.com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text(
              'Feel free to reach out with any questions, feedback, or support needs — we’ll get back to you as soon as possible.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Color(0xFF33691E)),
          onSelected: (value) {
            switch (value) {
              case 'about':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                );
                break;
              case 'help':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpScreen()),
                );
                break;
              case 'contact':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactScreen()),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'about', child: Text('About Us')),
            const PopupMenuItem(value: 'help', child: Text('Help & Support')),
            const PopupMenuItem(value: 'contact', child: Text('Contact Us')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Color(0xFF33691E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              );
            },
            child: const Text(
              'Register',
              style: TextStyle(
                color: Color(0xFF33691E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/hero_poultry.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '🐓 Kuku Marketplace',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33691E),
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Connecting Poultry Farmers Directly with Fresh Customers.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF558B2F)),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: const [
                          Text(
                            '🌱 About Kuku Marketplace',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF558B2F),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Kuku Marketplace is a smart online hub connecting poultry farmers directly with eager customers. Farmers can easily showcase eggs, meat, or live chickens. Customers browse fresh listings, place orders securely, and leave helpful reviews.',
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 1.4),
                          ),
                          SizedBox(height: 20),
                          FeatureTile(
                            icon: Icons.add_box,
                            title: 'List Your Products',
                            subtitle: 'Farmers sell fresh poultry stock',
                          ),
                          FeatureTile(
                            icon: Icons.shopping_cart_checkout,
                            title: 'Order Easily',
                            subtitle: 'Customers buy in just a few taps',
                          ),
                          FeatureTile(
                            icon: Icons.thumb_up,
                            title: 'Trusted Ratings',
                            subtitle: 'Leave reviews & boost trust',
                          ),
                          FeatureTile(
                            icon: Icons.admin_panel_settings_outlined,
                            title: 'Admin Support',
                            subtitle: 'Admins monitor quality & user safety',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.storefront, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF558B2F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                    label: const Text(
                      'Browse Marketplace',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(icon, size: 32, color: Color(0xFF8BC34A)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(subtitle),
    );
  }
}
