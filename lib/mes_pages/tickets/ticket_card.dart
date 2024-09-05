import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatefulWidget {
  final String ticketId;
  final String formation;
  final String categorie;
  final String description;
  final String date;
  final String userId; // Utilisé pour obtenir le nom de l'Apprenant
  final String currentUserRole;

  TicketCard({
    required this.ticketId,
    required this.formation,
    required this.categorie,
    required this.description,
    required this.date,
    required this.userId,
    required this.currentUserRole,
  });

  @override
  _TicketCardState createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  bool _isReplying = false;
  TextEditingController _replyController = TextEditingController();

  void _toggleReplyInput() {
    setState(() {
      _isReplying = !_isReplying;
    });
  }

  Future<void> _submitReply() async {
    String replyText = _replyController.text;

    if (replyText.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('tickets')
            .doc(widget.ticketId)
            .update({
          'reponseFormateur': FieldValue.arrayUnion([
            {
              'formateurId': widget.userId,
              'reponse': replyText,
              'date': Timestamp.now(),
            }
          ]),
        });

        print('Réponse envoyée: $replyText');
        _replyController.clear();
        _toggleReplyInput();
      } catch (e) {
        print('Erreur lors de l\'envoi de la réponse : $e');
      }
    }
  }

  Future<Map<String, String>> _getUserNames() async {
    try {
      // Récupération des noms en parallèle
      final apNameFuture = FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(widget.userId)
          .get();

      final formateurs = FirebaseFirestore.instance
          .collection('tickets')
          .doc(widget.ticketId)
          .get();

      final apNameSnapshot = await apNameFuture;
      final ticketSnapshot = await formateurs;

      if (apNameSnapshot.exists) {
        var apNameData = apNameSnapshot.data() as Map<String, dynamic>;
        String apName = apNameData['nom_prenom'] ?? 'Nom inconnu';

        if (ticketSnapshot.exists) {
          var ticketData = ticketSnapshot.data() as Map<String, dynamic>;
          var reponsesFormateur = ticketData['reponseFormateur'] ?? [];
          List<String> formateurNames = [];

          for (var reponse in reponsesFormateur) {
            DocumentSnapshot formateurSnapshot = await FirebaseFirestore.instance
                .collection('utilisateurs')
                .doc(reponse['formateurId'])
                .get();

            if (formateurSnapshot.exists) {
              var formateurData = formateurSnapshot.data() as Map<String, dynamic>;
              formateurNames.add(formateurData['nom_prenom'] ?? 'Formateur inconnu');
            } else {
              formateurNames.add('Formateur inconnu');
            }
          }

          return {
            'apprenant': apName,
            'formateurs': formateurNames.join(', '),
          };
        }
      }

      return {
        'apprenant': 'Nom inconnu',
        'formateurs': 'Formateur inconnu',
      };
    } catch (e) {
      print('Erreur lors de la récupération des noms : $e');
      return {
        'apprenant': 'Erreur lors de la récupération',
        'formateurs': 'Erreur lors de la récupération',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Erreur lors du chargement des noms'));
        }

        String userName = snapshot.data?['apprenant'] ?? 'Nom inconnu';
        String formateurNames = snapshot.data?['formateurs'] ?? 'Formateurs inconnus';

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tickets')
              .doc(widget.ticketId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur de chargement des données'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Ticket non trouvé'));
            }

            var ticketData = snapshot.data!.data() as Map<String, dynamic>;
            var reponsesFormateur = ticketData['reponseFormateur'] ?? [];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row for Formation and Categorie
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.school, color: Colors.blueAccent),
                            SizedBox(width: 8),
                            Text(
                              'Formation: ${widget.formation}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.category, color: Colors.blueAccent),
                            SizedBox(width: 8),
                            Text(
                              'Catégorie: ${widget.categorie}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(widget.description),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: ${widget.date}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.currentUserRole == 'Formateur')
                          ElevatedButton(
                            onPressed: _toggleReplyInput,
                            child: Text(_isReplying ? 'Annuler' : 'Répondre'),
                          ),
                      ],
                    ),
                    if (_isReplying)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Votre réponse:'),
                            SizedBox(height: 8),
                            TextField(
                              controller: _replyController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Écrivez votre réponse ici...',
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _submitReply,
                              child: Text('Envoyer'),
                            ),
                          ],
                        ),
                      ),
                    if (reponsesFormateur.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reponsesFormateur.map<Widget>((reponse) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formateurNames,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    reponse['reponse'],
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(
                                      (reponse['date'] as Timestamp).toDate(),
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
