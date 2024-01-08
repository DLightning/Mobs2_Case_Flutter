import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  final AuthController authController;

  const SignupScreen(this.authController, {Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signUp() async {
    final login = _loginController.text;
    final password = _passwordController.text;

    await widget.authController.signUp(login, password);

    Navigator.of(context).pushReplacementNamed('/login');
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
                Icons.person_add,
                size: 80,
                color: Colors.cyan,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _loginController,
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
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.cyan,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text(
                  'Already have an account? Login',
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
