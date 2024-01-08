import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/screens/photo_screen.dart';
import 'package:flutter_app/screens/userphoto_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthController authController;

  const HomeScreen(this.authController, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthController _authController;
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _authController = widget.authController;
    _screens = [
      UserPhotosScreen(authController: _authController),
      PhotoCaptureView(),
      const Placeholder(),
    ];
  }

  void _logOut(BuildContext context) async {
    await _authController.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobsCase'),
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 2) {
              _logOut(context);
            } else {
              _currentIndex = index;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.cyan,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Capture Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
