import 'package:flutter/material.dart';

class SaleNoFound extends StatelessWidget {
  const SaleNoFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(        
        color: const Color(0xFFcaf0f8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_dissatisfied,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text(
                "😵‍💫 ¡Ups! Ni una sola venta a la vista...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "¿Seguro que no escondiste las cartillas? 🧐\nRevisa bien o espera a que alguien se anime a comprar.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
