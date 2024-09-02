import 'package:flutter/material.dart';

class TicketResoluPage extends StatefulWidget {
  final int ticketId;

  TicketResoluPage({required this.ticketId});

  @override
  _TicketResoluPageState createState() => _TicketResoluPageState();
}

class _TicketResoluPageState extends State<TicketResoluPage> {
  // Simulations des données du ticket (elles doivent être récupérées de la base de données)
  final String formateur = 'MR Fat Kone';
  final String sujet = 'Application De Gestion De Tickets Pour Apprenants Et Formateurs';
  final String reponse = 'Application De Gestion De Tickets Pour Apprenants Et Formateurs...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Ticket Resolu',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),

      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Formateur : $formateur',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sujet : ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Technique',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      sujet,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Réponse',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        reponse,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
