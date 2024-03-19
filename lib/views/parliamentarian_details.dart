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
        centerTitle: true,
        title: const Text(
          'Detalhes do Deputado',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
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
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  widget.parliamentarian.photo,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.parliamentarian.name,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Partido: ${widget.parliamentarian.party}',
                                    ),
                                    Text(
                                      'Estado: ${widget.parliamentarian.uf}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 170,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Legislatura: ${widget.parliamentarian.legislature}',
                                    ),
                                    Text(
                                      'Email: ${widget.parliamentarian.email}',
                                    ),
                                    Text(
                                      'URI: ${widget.parliamentarian.uri}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: const Text(
                          'Detalhes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nome Civil: ${detailsStore.state.value.civilName}',
                                  ),
                                  Text(
                                    'Nome Eleitoral: ${detailsStore.state.value.nickname}',
                                  ),
                                  Text(
                                    'CPF: ${detailsStore.state.value.cpf}',
                                  ),
                                  Text(
                                    'Data de nascimento: ${detailsStore.state.value.birthDate}',
                                  ),
                                  Text(
                                    'Escolaridade: ${detailsStore.state.value.education}',
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.blue,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: Colors.blue,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Detalhes do Gabinete',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  for (var officeinfo in detailsStore
                                      .state.value.office!.entries)
                                    Text(
                                      '${officeinfo.key}: ${officeinfo.value}',
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: const Text(
                          'Despesas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: expenseStore.state,
                              builder: (context, state, child) {
                                if (expenseStore.state.value.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'Nenhuma despesa encontrada',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }
                                return Row(
                                  children: expenseStore.state.value
                                      .map((expense) => Container(
                                            width: 365,
                                            margin: const EdgeInsets.all(4),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Tipo: ${expense.type}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Fornecedor: ${expense.providerName}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Valor: ${expense.documentValue}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Data: ${expense.documentDate}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: const Text(
                          'Ocupações',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: occupationStore.state,
                              builder: (context, state, child) {
                                if (occupationStore.state.value.first.title ==
                                    '') {
                                  return Center(
                                    child: Container(
                                      width: 365,
                                      margin: const EdgeInsets.all(4),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Nenhuma ocupação encontrada',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Row(
                                  children: occupationStore.state.value
                                      .map((occupation) => Container(
                                            width: 365,
                                            margin: const EdgeInsets.all(4),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Nome: ${occupation.title}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Entidade: ${occupation.entity == '' ? 'Não informado' : occupation.entity}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Data de início: ${occupation.startYear == 'null' ? 'Não informado' : occupation.startYear}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Data de fim: ${occupation.startYear == 'null' && occupation.endYear == 'null' ? 'Não Informado' : occupation.endYear == 'null' ? 'Até o momento' : occupation.endYear}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
