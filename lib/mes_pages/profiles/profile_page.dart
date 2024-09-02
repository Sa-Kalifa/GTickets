import 'package:flutter/material.dart';
import '../custom_bottom_app_bar.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F6),
      appBar: AppBar(
        title: Text('Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, // Centre le titre
        leading: SizedBox.shrink(), // Retire l'icône de retour
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/100'), // Image de l'utilisateur
              ),
            ),
            SizedBox(height: 16),
            const Center(
              child: Text(
                'Nom Prénom',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Center(
              child: Text(
                'ID: 123456',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF04BBC7)),
              title: const Text('Modifier son Compte'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF04BBC7)),
              title: const Text('Utilisateur'),
              onTap: () {
                _showUserTypeDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF04BBC7)),
              title: const Text('Se Déconnecter'),
              onTap: () {
                // Ajoutez ici la logique de déconnexion
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(currentIndex: 3), // Page Profile
    );
  }

  void _showUserTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sélectionner le type d'utilisateur"),
          content: DropdownButtonFormField<String>(
            items: const [
              DropdownMenuItem(value: 'Admin', child: Text('Admin')),
              DropdownMenuItem(value: 'Formateur', child: Text('Formateur')),
              DropdownMenuItem(value: 'Apprenant', child: Text('Apprenant')),
            ],
            onChanged: (value) {
              // Gestion de la sélection
              Navigator.pop(context);
            },
            hint: Text('Sélectionner un type'),
          ),
        );
      },
    );
  }
}
