
class Expense {

  final int? year;
  final int? month;
  final String? type;
  final int? documentCode;
  final String? documentType;
  final String? documentDate;
  final String? documentNumber;
  final double? documentValue;
  final String? documentUrl;
  final String? providerName;
  final String? providerCnpj;

  Expense({

    this.year,
    this.month,
    this.type,
    this.documentCode,
    this.documentType,
    this.documentDate,
    this.documentNumber,
    this.documentValue,
    this.documentUrl,
    this.providerName,
    this.providerCnpj,

  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      year: map['ano'],
      month: map['mes'],
      type: map['tipoDespesa'],
      documentCode: map['codDocumento'],
      documentType: map['tipoDocumento'],
      documentDate: map['dataDocumento'],
      documentNumber: map['numDocumento'],
      documentValue: map['valorDocumento'],
      documentUrl: map['urlDocumento'],
      providerName: map['nomeFornecedor'],
      providerCnpj: map['cnpjCpfFornecedor'],
    );
  }
}