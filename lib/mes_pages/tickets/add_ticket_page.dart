import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddFormPage extends StatefulWidget {
  final String? ticketId; // Ajouter un paramètre optionnel pour le ticketId

  AddFormPage({this.ticketId}); // Modifier le constructeur pour accepter un ticketId

  @override
  _AddFormPageState createState() => _AddFormPageState();
}

class _AddFormPageState extends State<AddFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedFormation;
  String? _selectedCategory;
  String? _description;
  final List<String> _formations = [
    'DevWeb et Mobile',
    'Java',
    'Frontend',
    'Backend',
    'Flutter',
    'CMS',
    'Robotique',
    'Autre'
  ];
  final List<String> _categories = [
    'Technique',
    'Pédagogique'
  ];
  bool _isLoading = false; // Indique si les données du ticket sont en cours de chargement

  @override
  void initState() {
    super.initState();
    if (widget.ticketId != null) {
      _loadTicketData(); // Charger les données du ticket si un ticketId est fourni
    }
  }

  // Fonction pour charger les données du ticket à partir de Firestore
  Future<void> _loadTicketData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('tickets')
          .doc(widget.ticketId)
          .get();

      if (doc.exists) {
        setState(() {
          _selectedFormation = doc['formation'];
          _selectedCategory = doc['categorie'];
          _description = doc['description'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket introuvable.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement du ticket: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        User? utilisateurs = FirebaseAuth.instance.currentUser;
        String? utilisateurId = utilisateurs?.uid;

        if (utilisateurId != null) {
          if (widget.ticketId == null) {
            // Créer un nouveau ticket
            DocumentReference docRef = await FirebaseFirestore.instance
                .collection('tickets')
                .add({
              'userId': utilisateurId,
              'formation': _selectedFormation,
              'categorie': _selectedCategory,
              'description': _description,
              'date': Timestamp.now(),
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ticket enregistré avec succès!')),
            );
          } else {
            // Mettre à jour un ticket existant
            await FirebaseFirestore.instance
                .collection('tickets')
                .doc(widget.ticketId)
                .update({
              'formation': _selectedFormation,
              'categorie': _selectedCategory,
              'description': _description,
              'date': Timestamp.now(),
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ticket modifié avec succès!')),
            );
          }

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: utilisateur non connecté.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter / Modifier ticket',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Afficher un loader pendant le chargement des données
          : Padding(
        padding: const EdgeInsets.all(80.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Formation',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: _selectedFormation,
                      items: _formations.map((String formation) {
                        return DropdownMenuItem<String>(
                          value: formation,
                          child: Text(formation),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFormation = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner une formation';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Catégorie',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: _selectedCategory,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner une catégorie';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 3,
                      initialValue: _description, // Charger la description
                      onSaved: (value) {
                        _description = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une description';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Enregistrer',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Color(0xFF04BBC7),
                  textStyle: TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
