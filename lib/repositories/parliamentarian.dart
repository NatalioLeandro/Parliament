import 'dart:convert';

import 'package:parliament/services/client.dart';
import '../models/parliamentarian.dart';
import '../services/exceptions.dart';

abstract class ParliamentarianInterface {
  Future<List<Parliamentarian>> getParliamentarians();
}

class ParliamentarianRepository implements ParliamentarianInterface {

  final HttpInterface client;

  ParliamentarianRepository({required this.client});

  @override
  Future<List<Parliamentarian>> getParliamentarians() async {

    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados',
    );

    if (response.statusCode == 200) {

      final List<Parliamentarian> parliamentarians = [];
      final body = jsonDecode(response.body);

      body['dados'].map((parliamentarian) {
        parliamentarians.add(Parliamentarian.fromMap(parliamentarian));
      }).toList();

      return parliamentarians;

    } else if (response.statusCode == 404) {

      throw NotFoundException('A url informada não foi encontrada');

    } else {

      throw Exception('Error: ${response.statusCode}');

    }

  }

}