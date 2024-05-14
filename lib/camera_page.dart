import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:registro_tgo/models/result.dart';
import 'package:registro_tgo/repository.dart';

import 'enums/error_enum.dart';

class CameraPage extends StatelessWidget {
  final String email;
  const CameraPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final repo = DioRepo();

    return Scaffold(
      body: SmartFaceCamera(
        showControls: true,
        enableAudio: false,
        showFlashControl: false,
        autoCapture: false,
        defaultCameraLens: CameraLens.front,
        onCapture: (image) async {
          print('object');
          await repo.saveFace(email, image!).then(
            (result) {
              Navigator.of(context).pop();
              if (result.isSuccess!) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Cara registrada con éxito',
                        style: TextStyle(color: Colors.green),
                      ),
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
                // Caso de error
                errorDialog(context, result);
              }
            },
          );
        },
      ),
    );
  }

  Future<dynamic> errorDialog(BuildContext context, Result result) {
    ErrorEnum getErrorEnum(int errorCode) {
      switch (errorCode) {
        case 1:
          return ErrorEnum.faceNotDetected;
        case 2:
          return ErrorEnum.alreadyExist;
        case 3:
          return ErrorEnum.emailNotValid;
        default:
          return ErrorEnum.unknown;
      }
    }

    String errorMessage(ErrorEnum error) {
      switch (error) {
        case ErrorEnum.faceNotDetected:
          return 'Cara no detectada';
        case ErrorEnum.alreadyExist:
          return 'Ya existe';
        case ErrorEnum.emailNotValid:
          return 'Correo electrónico no válido';
        case ErrorEnum.unknown:
          return 'Error desconocido';
      }
    }

    ErrorEnum errorType = ErrorEnum.unknown;
    if (result.error != null &&
        result.error!.errors != null &&
        result.error!.errors!.isNotEmpty) {
      errorType = getErrorEnum(result.error!.errors![0].type ?? 0);
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(errorMessage(errorType)),
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
  }
}
