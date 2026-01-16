import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase/auth_page.dart';
import 'firebase/notif_service.dart';
import 'note_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotifService.instance.init();
  await NotifService.instance.showNow(
    title: "Test Notifikiasi",
    body: "Muncul Sekarang",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes Firebase',
      theme: ThemeData(useMaterial3: true),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          final user = snap.data;
          if (user == null) return const AuthPage();
          return const NotesPage();
        },
      ),
    );
  }
}
