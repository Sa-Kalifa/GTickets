import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'mes_pages/acceuil/adminPage/admin_dashboard.dart';
import 'mes_pages/acceuil/apprenantPage/acceuil_apprenant.dart';
import 'mes_pages/acceuil/formateurPage/acceuil_formateur.dart';
import 'mes_pages/authentification/login_page.dart';
import 'mes_pages/notification/notification_page.dart';
import 'mes_pages/profiles/profile_page.dart';
import 'mes_pages/tickets/ticket_page.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: const FirebaseOptions(apiKey: "AIzaSyByvGC7AcGYrIfpIdx5KZrob0Bum7zAVsM",
     authDomain: "gestionticket-9d01f.firebaseapp.com",
     projectId: "gestionticket-9d01f",
     storageBucket: "gestionticket-9d01f.appspot.com",
     messagingSenderId: "353042503516",
     appId: "1:353042503516:web:b6a3a99abdcb2c47b5d399"
   ),);

 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/admin': (context) => AdminDashboard(),
        '/formateur': (context) => AccueilFormateur(),
        '/apprenant': (context) => AccueilApprenant(),
        '/ticket': (context) => TicketPage(),
        '/notification': (context) => NotificationPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
