import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestion_tickets/mes_pages/acceuil/apprenantPage/acceuil_apprenant.dart';
import 'package:gestion_tickets/mes_pages/authentification/input_connexion.dart';
import 'package:gestion_tickets/mes_pages/authentification/my_boutton.dart';
import '../acceuil/adminPage/admin_dashboard.dart';
import '../acceuil/formateurPage/acceuil_formateur.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controller
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  // Clé de formulaire pour validation
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  // Méthode pour email et mot de passe
  void signUserIn(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      // Appel de la méthode pour gérer les rôles après la connexion réussie
      RoleManager().RoleUser(context);

    } on FirebaseAuthException catch (e) {
      // Arrêt de la fenêtre de chargement
      Navigator.pop(context);
      // Gérer l'erreur ici
      if (e.code == 'user-not-found') {
        emailMessage(context);
      } else if (e.code == 'wrong-password') {
        passwordMessage(context);
      }
    }
  }

  // Les Méthodes de Message d'erreur
  // Email
  void emailMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Email Incorrect'),
        );
      },
    );
  }

  // Mot de Passe
  void passwordMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Mot de Passe Incorrect'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 236, 236),
      body: SafeArea(
        child: Center(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Se Connecter',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Image.asset('lib/images/Tickets.png', height: 80),
                const SizedBox(height: 25),
                // Les Input
                Input_connexion(
                  controller: emailcontroller,
                  hintText: 'Votre Nom d\'utilisateur',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                Input_connexion(
                  controller: passwordcontroller,
                  hintText: 'Votre Mot de passe',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Mot de passe Oublié',
                        style: TextStyle(
                          color: Color.fromRGBO(4, 187, 199, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                MyBouton(
                  onTap: () {
                    if (formkey.currentState!.validate()) {
                      signUserIn(context);
                    }
                  },
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous n’avez pas de compte ?,",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "S’inscrire",
                      style: TextStyle(
                        color: Color.fromRGBO(4, 187, 199, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ******************** La gestion de Role **********************************

class RoleManager {
  // Méthode qui gère les rôles des utilisateurs
  void RoleUser(BuildContext context) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(currentUser.uid)
            .get();

        if (snapshot.exists) {
          final role = snapshot['role'];
          print("Rôle trouvé: $role");

          if (role == 'Admin') {
            print("Redirection vers AdminDashboard");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
          } else if (role == 'Formateur') {
            print("Redirection vers AccueilFormateur");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AccueilFormateur()),
            );
          } else if (role == 'Apprenant') {
            print("Redirection vers AccueilApprenant");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AccueilApprenant()),
            );
          } else {
            print("Rôle inconnu. Redirection vers LoginPage");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        } else {
          print("Document utilisateur non trouvé. Redirection vers LoginPage");
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>  AccueilFormateur()),
          );
        }
      } else {
        print("Utilisateur non authentifié. Redirection vers LoginPage");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      print("Erreur lors de la récupération du rôle: $e");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }


  // Fonction pour enregistrer un utilisateur avec un rôle
  Future<void> registerUser(String email, String password, String role) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Ajouter un document utilisateur avec le rôle dans Firestore
    await FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(userCredential.user!.uid)
        .set({
      'email': email,
      'role': role,
    });
  }
}
