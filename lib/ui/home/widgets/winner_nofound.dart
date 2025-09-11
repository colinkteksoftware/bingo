import 'package:flutter/material.dart';

class WinnerNoFound extends StatelessWidget {
  const WinnerNoFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Card(
          color: const Color(0xFFcaf0f8),
          elevation: 5,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  '¡Sin ganador!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Aún no hay ganadores en este bingo.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  '¡No pierdas la fe, que el premio puede caer en cualquier momento!.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
