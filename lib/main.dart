import 'package:flutter/material.dart';
import 'package:parliament/routes/router.dart' as routes;

// https://dadosabertos.camara.leg.br/api/v2/deputados
// https://dadosabertos.camara.leg.br/api/v2/deputados/{id}
// https://dadosabertos.camara.leg.br/api/v2/deputados/{id}/despesas
// https://dadosabertos.camara.leg.br/api/v2/deputados/{id}/ocupacoes
// https://dadosabertos.camara.leg.br/api/v2/frentes
// https://dadosabertos.camara.leg.br/api/v2/frentes/{id}
// https://dadosabertos.camara.leg.br/api/v2/frentes/{id}/membros

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: routes.controller,
      initialRoute: routes.home,
      debugShowCheckedModeBanner: false,
    );
  }
}