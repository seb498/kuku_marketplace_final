import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyADVjkkkH9s5pmimGQsbXuLbMwr8VPgG1E",
        authDomain: "kuku-marketplace.firebaseapp.com",
        projectId: "kuku-marketplace",
        storageBucket: "kuku-marketplace.firebasestorage.app",
        messagingSenderId: "575455968628",
        appId: "1:575455968628:web:d713ef40abdea124d38021",
        measurementId: "G-E927NCFPSJ",
      ),
    );
  } else {
    await Firebase.initializeApp(); // Mobile
  }

  runApp(const KukuApp());
}

class KukuApp extends StatelessWidget {
  const KukuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuku Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const LandingScreen(),
    );
  }
}
