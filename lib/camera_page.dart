import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:registro_tgo/repository.dart';

class CameraPage extends StatelessWidget {
  final String email;
  const CameraPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {

    final repo = DioRepo();

    return SmartFaceCamera(
      showControls: true,
      enableAudio: false,
      showFlashControl: false,
      autoCapture: false,
      defaultCameraLens: CameraLens.back,
      onCapture: (image) async {

        await repo.saveFace(email, image!).then((value) {
          if (value) {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Cara registrada con exito', style: TextStyle(
                    color: Colors.green
                  ),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cerrar'),
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error al guardar la cara'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cerrar'),
                    ),
                  ],
                );
              },
            );
          }
        });
      },
    );
  }
}
