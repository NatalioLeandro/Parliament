import 'package:flutter/material.dart';
import 'package:parliament/routes/router.dart' as routes;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green[800],
          ),
          onPressed: () {
            Navigator.pushNamed(context, routes.parliamentarians);
          },
          child: const Text('Deputies'),
        ),
      ),
    );
  }
}
