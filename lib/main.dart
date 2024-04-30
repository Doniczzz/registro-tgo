import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:registro_tgo/camera_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Add this

  await FaceCamera.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return CameraPage(email: emailController.text);
                    },
                  ));
                },
                child: Text('Registrar cara'),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                controller: emailController,
              )
            ],
          ),
        ),
      ),
    );
  }
}
