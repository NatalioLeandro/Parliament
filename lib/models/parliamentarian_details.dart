class ParliamentarianDetails {
  final String? nickname;
  final String? situation;
  final String? condition;
  final String? status;
  final String? cpf;
  final String? sex;
  final String? website;
  final List<dynamic>? socialMedia;
  final String? birthDate;
  final String? deathDate;
  final String? birthUf;
  final String? birthCity;
  final String? education;
  final Map<String, dynamic>? office;

  ParliamentarianDetails({
    this.nickname,
    this.situation,
    this.condition,
    this.status,
    this.cpf,
    this.sex,
    this.website,
    this.socialMedia,
    this.birthDate,
    this.deathDate,
    this.birthUf,
    this.birthCity,
    this.education,
    this.office,
  });

  factory ParliamentarianDetails.fromMap(Map<String, dynamic> map) =>
      ParliamentarianDetails(
        nickname: map['ultimoStatus']['nomeEleitoral'] ?? '',
        situation: map['ultimoStatus']['situacao'] ?? '',
        condition: map['ultimoStatus']['condicaoEleitoral'] ?? '',
        status: map['ultimoStatus']['descricaoStatus'] ?? '',
        cpf: map['cpf'] ?? '',
        sex: map['sexo'] ?? '',
        website: map['urlWebsite'] ?? '',
        socialMedia: map['redeSocial'] ?? [],
        birthDate: map['dataNascimento'] ?? '',
        deathDate: map['dataFalecimento'] ?? '',
        birthUf: map['ufNascimento'] ?? '',
        birthCity: map['municipioNascimento'] ?? '',
        education: map['escolaridade'] ?? '',
        office: map['ultimoStatus']['gabinete'] ?? {},
      );
}
