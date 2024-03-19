import 'dart:convert';

import '../models/parliamentarian_details.dart';
import '../services/client.dart';
import '../services/exceptions.dart';

abstract class ParliamentarianDetailsInterface {
  Future<ParliamentarianDetails> getParliamentarian(int id);
}

class ParliamentarianDetailsRepository implements ParliamentarianDetailsInterface {

  final HttpInterface client;

  ParliamentarianDetailsRepository({required this.client});

  @override
  Future<ParliamentarianDetails> getParliamentarian(int id) async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados/$id',
    );

    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);
      return ParliamentarianDetails.fromMap(body['dados']);

    } else if (response.statusCode == 404) {

      throw NotFoundException('A url informada não foi encontrada');

    } else {

      throw Exception('Error: ${response.statusCode}');

    }
  }
}