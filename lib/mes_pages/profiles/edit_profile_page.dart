import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _nomPrenom = '';
  String _module = '';
  String _adresse = '';
  String _email = '';
  String _telephone = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        // Récupérer l'utilisateur actuellement connecté
        User? utilisateur = FirebaseAuth.instance.currentUser;
        String? utilisateurId = utilisateur?.uid;

        // Vérifier que l'utilisateur est connecté
        if (utilisateurId != null) {
          // Mettre à jour les informations de l'utilisateur dans Firestore
          await FirebaseFirestore.instance
              .collection('utilisateurs')
              .doc(utilisateurId)
              .update({
            'nom_prenom': _nomPrenom,
            'module': _module,
            'adresse': _adresse,
            'email': _email,
            'telephone': _telephone,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Informations mises à jour avec succès!')),
          );

          // Réinitialiser le formulaire après la mise à jour
          _formKey.currentState?.reset();
          setState(() {
            _nomPrenom = '';
            _module = '';
            _adresse = '';
            _email = '';
            _telephone = '';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: utilisateur non connecté.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8),
                const Text(
                  'Modifier Compte',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nom et Prénom',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialValue: _nomPrenom,
                        onChanged: (value) => setState(() => _nomPrenom = value),
                        validator: (value) =>
                        value!.isEmpty ? 'Veuillez entrer votre nom et prénom' : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Module',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialValue: _module,
                        onChanged: (value) => setState(() => _module = value),
                        validator: (value) =>
                        value!.isEmpty ? 'Veuillez entrer votre module' : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Adresse',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialValue: _adresse,
                        onChanged: (value) => setState(() => _adresse = value),
                        validator: (value) =>
                        value!.isEmpty ? 'Veuillez entrer votre adresse' : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialValue: _email,
                        onChanged: (value) => setState(() => _email = value),
                        validator: (value) =>
                        value!.isEmpty ? 'Veuillez entrer votre email' : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialValue: _telephone,
                        onChanged: (value) => setState(() => _telephone = value),
                        validator: (value) =>
                        value!.isEmpty ? 'Veuillez entrer votre numéro de téléphone' : null,
                      ),
                    ),

                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF04BBC7), // Couleur du bouton
                        ),
                        child: const Text(
                          'Enregistrer',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
