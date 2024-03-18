
class Occupation {

  final String? title;
  final String? entity;
  final String? entityUf;
  final String? entityCountry;
  final int? startYear;
  final int? endYear;

  Occupation({

    this.title,
    this.entity,
    this.entityUf,
    this.entityCountry,
    this.startYear,
    this.endYear,

  });

  factory Occupation.fromMap(Map<String, dynamic> map) {
    return Occupation(
      title: map['titulo'],
      entity: map['entidade'],
      entityUf: map['entidadeUF'],
      entityCountry: map['entidadePais'],
      startYear: map['anoInicio'],
      endYear: map['anoFim'],
    );
  }
}
