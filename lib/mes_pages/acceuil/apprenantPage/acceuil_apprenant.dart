import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../custom_bottom_app_bar.dart';
import '../../tickets/ticket_page.dart';

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 400,
                    height: 120,
                    child: Image.asset('lib/images/odc1.jpg', fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 400,
                    height: 120,
                    child: Image.asset('lib/images/odc2.jpg', fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 400,
                    height: 120,
                    child: Image.asset('lib/images/ODC.jpg', fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 400,
                    height: 120,
                    child: Image.asset('lib/images/AT.png', fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 400,
                    height: 120,
                    child: Image.asset('lib/images/T.png', fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 400,
                    height: 120,
                    child: Image.asset('lib/images/TR.png', fit: BoxFit.cover),
                  ),
                ),
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
                    builder: (context) => TicketPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF04BBC7), // Couleur du bouton
              ),
              child: const Text(
                'Ajouter Ticket',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomAppBar(currentIndex: 0), // Page Accueil
    );
  }
}


