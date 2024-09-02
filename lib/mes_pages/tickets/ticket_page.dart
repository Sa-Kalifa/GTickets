import 'package:flutter/material.dart';
import 'package:gestion_tickets/mes_pages/tickets/ticket_resolu_page.dart';
import '../custom_bottom_app_bar.dart';
import 'add_form_page.dart';

class TicketPage extends StatefulWidget {
  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'Ticket',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Retire le Back Icon
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Logique pour ajouter un ticket
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => AddFormPage(),
                  ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF04BBC7), // Couleur du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Ajouter', style: TextStyle(color: Colors.black),),
              ),
            ),
            SizedBox(height: 50), // Augmente l'espace entre le bouton "Ajouter" et les trois boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('Tous'),
                _buildFilterButton('Technique'),
                _buildFilterButton('Pédagogique'),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Nombre d'éléments dans la liste (à récupérer de la base de données)
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigation vers la page "Ticket résolu"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketResoluPage(ticketId: index),
                        ),
                      );
                    },
                    child: TicketCard(
                      name: 'MR Fat Kone',
                      status: index == 0 ? 'Attente' : index == 1 ? 'En Cours' : 'Résolu',
                      statusColor: index == 0
                          ? Colors.orange
                          : index == 1
                          ? Colors.blue
                          : Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(currentIndex: 1),
    );
  }

  Widget _buildFilterButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // Logique pour filtrer les tickets
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.grey[300], // Couleur du texte
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }
}


class TicketCard extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;

  TicketCard({
    required this.name,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Assurez-vous que le chemin est correct et que le fichier existe
                Image.asset(
                  'lib/images/Book.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: Colors.red); // Affiche une icône d'erreur si l'image ne se charge pas
                  },
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Application De Gestion De Tickets',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Pour Apprenants Et Formateurs',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '17/08/24  14h00',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Technique',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

