import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../custom_bottom_app_bar.dart';
import '../adminPage/admin_dashboard.dart';

class AccueilApprenant extends StatelessWidget {

  // recupere l'email de l'utilisateur
  final user = FirebaseAuth.instance.currentUser!;

  // User connecter
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F6), // Couleur de fond
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Images défilantes',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Image.network('https://via.placeholder.com/150'),
                Image.network('https://via.placeholder.com/150'),
                Image.network('https://via.placeholder.com/150'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboard(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF04BBC7), // Couleur du bouton
              ),
              child: Text('Ajouter Ticket'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomAppBar(currentIndex: 0), // Page Accueil
    );
  }
}


