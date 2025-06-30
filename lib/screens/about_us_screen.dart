import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF558B2F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
