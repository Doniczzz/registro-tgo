import 'package:flutter/material.dart';
import 'package:registro_tgo/widgets/main_button.dart';

import 'camera_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
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
                // enabled: isEmailValid,
                onTap: () async {
                  if (isEmailValid) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CameraPage(email: emailController.text),
                    ));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                            'Por favor, ingresa un correo electrónico válido.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cerrar'),
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
}
