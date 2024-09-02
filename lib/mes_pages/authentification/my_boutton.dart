import 'package:flutter/material.dart';

class MyBouton extends StatelessWidget {
  final Function()? onTap;
  const MyBouton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(4, 187, 199, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child:const Text(
          "Connexion",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white
          ),
          ),
      ),
    );
  }
}