import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int currentIndex;

  CustomBottomAppBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFFF3F5F6), // Couleur de l'AppBar en bas
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            color: currentIndex == 0 ? Color(0xFF04BBC7) : Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/accueil');
            },
          ),
          IconButton(
            icon: Icon(Icons.confirmation_number),
            color: currentIndex == 1 ? Color(0xFF04BBC7) : Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/ticket');
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: currentIndex == 2 ? Color(0xFF04BBC7) : Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            color: currentIndex == 3 ? Color(0xFF04BBC7) : Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),


          // le test
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            color: currentIndex == 4 ? Color(0xFF04BBC7) : Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/admin');
            },
          ),


        ],
      ),
    );
  }
}

