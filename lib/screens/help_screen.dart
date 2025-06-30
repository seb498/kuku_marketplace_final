import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF558B2F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
              'How do I create an account?\n'
              'Click on the Sign Up button and fill in your details as either a poultry farmer or buyer. Verify your email to activate your account.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'How do I list my poultry products?\n'
              'Farmers can add new products by navigating to the My Products section and clicking Add Product. Fill in the details such as type, quantity, price, and upload clear photos.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 24),
            Text(
              'Ordering & Payments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'How can buyers place an order?\n'
              'Browse available products, select what you want, and click Order Now. You will receive an order confirmation and estimated delivery details.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'What payment methods are accepted?\n'
              'We support secure online payments including mobile money and credit/debit cards to ensure smooth transactions.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'Can I track my order?\n'
              'Yes! Once your order is confirmed, you can track its status in the My Orders section.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 24),
            Text(
              'Communication',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'How can I communicate with buyers or farmers?\n'
              'Use the built-in messaging system to chat directly and clarify any details before finalizing orders.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 24),
            Text(
              'Troubleshooting',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'I forgot my password. What do I do?\n'
              'Click on Forgot Password on the login page, enter your registered email, and follow the instructions to reset your password.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'I’m having trouble with payment. Who do I contact?\n'
              'Please reach out to our support team via the Contact Us page or email mutuaseb@gmail.com for assistance.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 24),
            Text(
              'Policies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Where can I find Kukumarketplace’s privacy policy and terms of service?\n'
              'Links to our Privacy Policy and Terms of Service are located at the bottom of every page.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
