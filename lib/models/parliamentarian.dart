
class Parliamentarian {

  final int id;
  final String uri;
  final String name;
  final String party;
  final String uf;
  final int legislature;
  final String photo;
  final String email;

  Parliamentarian({

    required this.id,
    required this.uri,
    required this.name,
    required this.party,
    required this.uf,
    required this.legislature,
    required this.photo,
    required this.email,

  });

  factory Parliamentarian.fromMap(Map<String, dynamic> map) {
    return Parliamentarian(
      id: map['id'] ?? 0,
      uri: map['uri'] ?? '',
      name: map['nome'] ?? '',
      party: map['siglaPartido'] ?? '',
      uf: map['siglaUf'] ?? '',
      legislature: map['idLegislatura'] ?? 0,
      photo: map['urlFoto'] ?? '',
      email: map['email'] ?? '',
    );
  }
}