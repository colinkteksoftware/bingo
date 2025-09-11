import 'package:bingo/utils/colores.dart';
import 'package:flutter/material.dart';

void showConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) {
  final size = MediaQuery.of(context).size;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFcaf0f8),
        title: const Text(
          '¿Desea eliminar este registro?',
          style: TextStyle(color: primaryBlue), 
        ),
        content: const Text('Confirmar eliminación.'),
        actions: <Widget>[
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      backgroundColor: Colors.red[900],
                    ),
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: size.width * 0.03,
                        color: const Color(0xFFcaf0f8),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      backgroundColor: primaryBlue,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    child: Text(
                      'Confirmar',
                      style: TextStyle(
                        fontSize: size.width * 0.03,
                        color: const Color(0xFFcaf0f8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      );
    },
  );
}
