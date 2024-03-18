import 'package:flutter/material.dart';
import 'package:parliament/models/parliamentarian.dart';
import 'package:parliament/stores/expense.dart';
import 'package:parliament/stores/occupation.dart';
import 'package:parliament/stores/parliamentarian_details.dart';

import '../repositories/expense.dart';
import '../repositories/occupation.dart';
import '../repositories/parliamentarian_details.dart';
import '../services/client.dart';

class ParliamentarianDetails extends StatefulWidget {
  final Parliamentarian parliamentarian;
  const ParliamentarianDetails({super.key, required this.parliamentarian});

  @override
  State<ParliamentarianDetails> createState() => _ParliamentarianDetailsState();
}

class _ParliamentarianDetailsState extends State<ParliamentarianDetails> {
  final ParliamentarianDetailsStore detailsStore = ParliamentarianDetailsStore(
      repository: ParliamentarianDetailsRepository(
    client: HttpClient(),
  ));

  final ExpenseStore expenseStore = ExpenseStore(
      repository: ExpenseRepository(
    client: HttpClient(),
  ));

  final OccupationStore occupationStore = OccupationStore(
      repository: OccupationRepository(
    client: HttpClient(),
  ));

  @override
  void initState() {
    super.initState();
    detailsStore.getParliamentarianDetails(widget.parliamentarian.id);
    expenseStore.getExpenses(widget.parliamentarian.id);
    occupationStore.getOccupations(widget.parliamentarian.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: const Text(
          'Detalhes do Deputado',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          detailsStore.isLoading,
          detailsStore.state,
          detailsStore.error,
          expenseStore.isLoading,
          expenseStore.state,
          expenseStore.error,
          occupationStore.isLoading,
          occupationStore.state,
          occupationStore.error,
        ]),
        builder: (context, child) {
          if (detailsStore.isLoading.value ||
              expenseStore.isLoading.value ||
              occupationStore.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (detailsStore.error.value.isNotEmpty ||
              expenseStore.error.value.isNotEmpty ||
              occupationStore.error.value.isNotEmpty) {
            return Center(
              child: Text(detailsStore.error.value +
                  expenseStore.error.value +
                  occupationStore.error.value),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.green,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          widget.parliamentarian.photo,
                          width: 100,
                          height: 100,
                        ),
                        Text(
                          widget.parliamentarian.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Partido: ${widget.parliamentarian.party}',
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Legislatura: ${widget.parliamentarian.legislature}',
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Estado: ${widget.parliamentarian.uf}',
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Email: ${widget.parliamentarian.email}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.green,
                        width: 1,
                      ),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.green,
                        Colors.greenAccent,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: detailsStore.state,
                          builder: (context, value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 190,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Detalhes',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                            'Nome Eleitoral: ${value.nickname}'),
                                        Text('Situação: ${value.situation}'),
                                        Text(
                                            'Condição Eleitoral: ${value.condition}'),
                                        Text('CPF: ${value.cpf}'),
                                        Text('Sexo: ${value.sex}'),
                                        Text(
                                            'Escolaridade: ${value.education}'),
                                        Text(
                                            'Data de Nascimento: ${value.birthDate}'),
                                        Text(
                                            'Data de Falecimento: ${value.deathDate}'),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 190,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Gabinete',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        for (var office
                                            in value.office!.entries)
                                          Text(
                                              '${office.key}: ${office.value}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.green,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Despesas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: expenseStore.state,
                                builder: (context, value, child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var expense in value)
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              width: 365,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.green,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.green,
                                                    Colors.greenAccent,
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Ano: ${expense.year}'),
                                                    Text(
                                                        'Mês: ${expense.month}'),
                                                    Text(
                                                        'Tipo: ${expense.type}'),
                                                    Text(
                                                        'Valor: ${expense.documentValue}'),
                                                    Text(
                                                        'Nome Fornecedor: ${expense.providerName}'),
                                                    Text(
                                                        'CNPJ Fornecedor: ${expense.providerCnpj}'),
                                                    Text(
                                                        'Data Documento: ${expense.documentDate}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.green,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Ocupações',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: occupationStore.state,
                                builder: (context, value, child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        for (var occupation in value)
                                          if (occupation.title == '')
                                            const SizedBox(
                                              width: 365,
                                              child: Text(
                                                'Sem ocupações',
                                              ),
                                            )
                                          else
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              width: 365,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.green,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.green,
                                                    Colors.greenAccent,
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Titulo: ${occupation.title}'),
                                                    Text(
                                                        'Entidade: ${occupation.entity}'),
                                                    Text(
                                                        'UF Entidade: ${occupation.entityUf}'),
                                                    Text(
                                                        'País Entidade: ${occupation.entityCountry}'),
                                                    Text(
                                                        'Ano Início: ${occupation.startYear == 'null' ? 'Atual' : occupation.startYear}'),
                                                    Text(
                                                        'Ano Fim: ${occupation.endYear == 'null' ? 'Atual' : occupation.endYear}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
