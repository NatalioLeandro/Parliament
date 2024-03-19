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
        centerTitle: true,
        title: const Text(
          'Início',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, routes.parliamentarians);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Color(0xFF00BCD4)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Deputados',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, routes.parliamentarians);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Color(0xFF00BCD4)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Frentes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
