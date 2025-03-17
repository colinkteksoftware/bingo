import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<void> requestCameraPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.camera.request();

    if (status.isDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Camera permission'),
          content: const Text(
              'Please enable camera access in your device settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
