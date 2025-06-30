import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: const Color(0xFF558B2F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
