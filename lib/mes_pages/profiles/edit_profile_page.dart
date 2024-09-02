import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  String _prenom = '';
  String _adresse = '';
  String _tel = '';

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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nom'),
                      initialValue: _nom,
                      onChanged: (value) => setState(() => _nom = value),
                      validator: (value) => value!.isEmpty ? 'Veuillez entrer votre nom' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Prénom'),
                      initialValue: _prenom,
                      onChanged: (value) => setState(() => _prenom = value),
                      validator: (value) => value!.isEmpty ? 'Veuillez entrer votre prénom' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Adresse'),
                      initialValue: _adresse,
                      onChanged: (value) => setState(() => _adresse = value),
                      validator: (value) => value!.isEmpty ? 'Veuillez entrer votre adresse' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Téléphone'),
                      initialValue: _tel,
                      onChanged: (value) => setState(() => _tel = value),
                      validator: (value) => value!.isEmpty ? 'Veuillez entrer votre numéro de téléphone' : null,
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Enregistrez les modifications
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF04BBC7), // Couleur du bouton
                        ),
                        child: Text('Enregistrer'),
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
