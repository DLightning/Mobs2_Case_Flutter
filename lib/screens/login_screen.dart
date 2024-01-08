import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;

  const LoginScreen({Key? key, required this.authController}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final success = await widget.authController.login(username, password);

    if (success) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content:
              const Text('Invalid username or password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera,
                size: 80,
                color: Colors.cyan,
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.cyan,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize:
                          16), // Ajuste o tamanho do texto conforme necessário
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: const Text(
                  'Don\'t have an account? Sign up here',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
