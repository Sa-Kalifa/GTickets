import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestion_tickets/mes_pages/tickets/ticket_card.dart';
import 'package:intl/intl.dart';
import '../custom_bottom_app_bar.dart';
import 'add_ticket_page.dart'; // Import de la page d'ajout de ticket

class TicketPage extends StatefulWidget {
  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserRole;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserRole();
  }

  Future<void> _loadCurrentUserRole() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        currentUserId = user.uid;
        DocumentSnapshot userDoc = await _firestore.collection('utilisateurs').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            currentUserRole = userDoc.get('role');
          });
        } else {
          print("L'utilisateur n'a pas de rôle défini dans Firestore.");
        }
      } else {
        print("Aucun utilisateur connecté.");
      }
    } catch (e) {
      print("Erreur lors de la récupération du rôle : $e");
    }
  }

  Future<String> _getApprenantName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('utilisateurs').doc(userId).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        return userData['nom_prenom'] ?? 'Nom inconnu';
      } else {
        return 'Utilisateur inconnu';
      }
    } catch (e) {
      print('Erreur lors de la récupération du nom de l\'Apprenant : $e');
      return 'Erreur lors de la récupération';
    }
  }

  Future<void> _deleteTicket(String ticketId) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).delete();
      print('Ticket supprimé avec succès.');
    } catch (e) {
      print('Erreur lors de la suppression du ticket : $e');
    }
  }

  Future<void> _updateResponse(String ticketId, String responseId, String newResponseText) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).collection('responses').doc(responseId).update({
        'responseText': newResponseText,
      });
      print('Réponse mise à jour avec succès.');
    } catch (e) {
      print('Erreur lors de la mise à jour de la réponse : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'Tickets',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: currentUserRole == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tickets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun ticket trouvé.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var ticketData = snapshot.data!.docs[index];
              var data = ticketData.data() as Map<String, dynamic>;

              String formation = data['formation'] ?? 'Formation non spécifiée';
              String categorie = data['categorie'] ?? 'Catégorie non spécifiée';
              String description = data['description'] ?? 'Description non spécifiée';
              Timestamp timestamp = data['date'] ?? Timestamp.now();
              String date = DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate());
              String userId = data['userId'] ?? 'Utilisateur inconnu';

              return FutureBuilder<String>(
                future: _getApprenantName(userId),
                builder: (context, nameSnapshot) {
                  if (nameSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (nameSnapshot.hasError || !nameSnapshot.hasData) {
                    return Center(child: Text('Erreur lors du chargement du nom'));
                  }

                  String userName = nameSnapshot.data ?? 'Nom inconnu';

                  return ListTile(
                    title: TicketCard(
                      ticketId: ticketData.id,
                      formation: formation,
                      categorie: categorie,
                      description: description,
                      date: date,
                      userId: userName, // Passer le nom à TicketCard
                      currentUserRole: currentUserRole!,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (currentUserRole == 'Formateur' ||
                            (currentUserRole == 'Apprenant' && currentUserId == userId)) ...[
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddFormPage(
                                    ticketId: ticketData.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                        if (currentUserRole == 'Formateur' ||
                            (currentUserRole == 'Apprenant' && currentUserId == userId)) ...[
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteTicket(ticketData.id);
                            },
                          ),
                        ],
                      ],
                    ),
                    subtitle: StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('tickets').doc(ticketData.id).collection('responses').snapshots(),
                      builder: (context, responseSnapshot) {
                        if (responseSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!responseSnapshot.hasData || responseSnapshot.data!.docs.isEmpty) {
                          return Text('Aucune réponse trouvée.');
                        }

                        return Column(
                          children: responseSnapshot.data!.docs.map((responseDoc) {
                            var responseData = responseDoc.data() as Map<String, dynamic>;
                            String responseText = responseData['responseText'] ?? 'Réponse non spécifiée';
                            String authorId = responseData['authorId'] ?? 'Auteur inconnu';
                            String responseId = responseDoc.id;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(text: responseText),
                                      readOnly: !(currentUserRole == 'Formateur' && authorId == currentUserId),
                                      onChanged: (newText) {
                                        if (currentUserRole == 'Formateur' && authorId == currentUserId) {
                                          _updateResponse(ticketData.id, responseId, newText);
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Réponse',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: currentUserRole == 'Apprenant'
          ? FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFormPage()),
          );
        },
        child: Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: CustomBottomAppBar(currentIndex: 1),
    );
  }
}
