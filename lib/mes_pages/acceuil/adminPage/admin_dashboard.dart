import 'package:flutter/material.dart';

import 'inscription.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  get bottomNavigationBar => 4;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Main content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistiques',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),

                    // Tickets statistics card
                    _buildStatsCard(
                      context,
                      title: 'Tickets Traitements',
                      value: 'Tickets soumis: 150\nTickets traités: 112',
                      color: Colors.blue[100]!,
                      percentage: 0.75,
                    ),

                    SizedBox(height: 20),

                    // Formateurs statistics card
                    _buildStatsCard(
                      context,
                      title: 'Formateurs',
                      value: 'Nombre de formateurs: 10\nFormateurs actifs: 5',
                      color: Colors.green[100]!,
                      percentage: 0.50,
                    ),

                    SizedBox(height: 20),

                    // Apprenants statistics card
                    _buildStatsCard(
                      context,
                      title: 'Apprenants',
                      value: 'Nombre d\'apprenants: 200\nApprenants inscrits: 170',
                      color: Colors.orange[100]!,
                      percentage: 0.85,
                    ),

                    SizedBox(height: 40),

                    // Button to navigate to users list page
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to users list page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Inscription(),
                          ),
                        );
                      },
                      child: Text('Voir la liste des Utilisateurs'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF04BBC7), // Button color
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

  // Helper function to build a custom stats card
  Widget _buildStatsCard(BuildContext context, {
    required String title,
    required String value,
    required Color color,
    required double percentage,
  }) {
    return Card(
      color: color,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(value),
            SizedBox(height: 10),
            _buildProgressBar(context, percentage: percentage),
          ],
        ),
      ),
    );
  }

  // Helper function to build a custom progress bar
  Widget _buildProgressBar(BuildContext context, {required double percentage}) {
    return Container(
      width: double.infinity,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * percentage,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
