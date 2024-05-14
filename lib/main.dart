import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:registro_tgo/repository.dart';
import 'package:registro_tgo/widgets/main_button.dart';

import 'enums/error_enum.dart';
import 'models/result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      color: primaryColor,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController emailController = TextEditingController();
  bool isEmailValid = false;
  File? _selectedImage;
  bool loading = false;
  double fontSize = 17;

  final repo = DioRepo();

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      final isValid = isEmail(emailController.text);
      if (isEmailValid != isValid) {
        setState(() {
          isEmailValid = isValid;
        });
      }
    });
  }

  bool isEmail(String input) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/acudir_logo.png',
                width: 300.0,
                height: 200.0,
                fit: BoxFit.contain,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              PrimaryButton(
                title: "Registrar rostro",
                enabled: isEmailValid,
                onTap: () async {
                  if (isEmailValid) {
                    await pickImageFormGallery();
                    if (_selectedImage == null) return;
                    _showImageConfirmationDialog();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                            'Por favor, ingresa un correo electrónico válido.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cerrar',
                              style: TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> errorDialog(BuildContext context, Result result) {
    log(result.error!.errors![0].type.toString());
    ErrorEnum getErrorEnum(int errorCode) {
      switch (errorCode) {
        case 1:
          return ErrorEnum.faceNotDetected;
        case 2:
          return ErrorEnum.emailNotValid;
        case 3:
          return ErrorEnum.alreadyExist;
        default:
          return ErrorEnum.unknown;
      }
    }

    String errorMessage(ErrorEnum error) {
      switch (error) {
        case ErrorEnum.faceNotDetected:
          return 'Cara no detectada';
        case ErrorEnum.alreadyExist:
          return 'Ya existe un registro con el email ${emailController.text}\n\n\n ¿Desea actualizar la fotografía?';
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
          title: Text(
            errorMessage(errorType),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (loading) return;
                Navigator.of(context).pop();
              },
              child: Text('Cerrar',
                  style: TextStyle(color: primaryColor, fontSize: fontSize)),
            ),
            Visibility(
              visible: errorType == ErrorEnum.alreadyExist,
              child: PrimaryButton(
                title: "Si",
                onTap: () async {
                  loading = true;
                  await repo
                      .editFace(emailController.text, _selectedImage!)
                      .then(
                    (result) {
                      Navigator.of(context).pop();
                      if (result.isSuccess!) {
                        loading = false;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Rostro editado con éxito al email ${emailController.text}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: primaryColor),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cerrar',
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        loading = false;
                        errorDialog(context, result);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showImageConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Imagen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedImage != null)
                SizedBox(
                  height: 300,
                  width: 800,
                  child: Image.file(
                    File(_selectedImage!.path),
                    fit: BoxFit.contain,
                  ),
                ),
              const SizedBox(height: 20),
              const Text('¿La foto fue tomada correctamente?'),
            ],
          ),
          actions: [
            TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(primaryColor),
                ),
                onPressed: () {
                  if (loading) return;
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Reintentar',
                  style: TextStyle(fontSize: fontSize),
                )),
            PrimaryButton(
              title: "Si",
              onTap: () async {
                loading = true;
                await repo.saveFace(emailController.text, _selectedImage!).then(
                  (result) {
                    Navigator.of(context).pop();
                    if (result.isSuccess!) {
                      loading = false;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Rostro registrado con éxito al email ${emailController.text}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: primaryColor),
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
                      loading = false;
                      errorDialog(context, result);
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future pickImageFormGallery() async {
    final imageFinal = await ImagePicker().pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    if (imageFinal == null) return;
    setState(() {
      _selectedImage = File(imageFinal.path);
    });
  }
}
