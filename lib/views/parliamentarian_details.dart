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

  static const defaultImage =
      'https://www.camara.leg.br/internet/deputado/bandep/178992.jpg';

  @override
  void initState() {
    super.initState();
    detailsStore.getParliamentarianDetails(widget.parliamentarian.id ?? 0);
    expenseStore.getExpenses(widget.parliamentarian.id ?? 0);
    occupationStore.getOccupations(widget.parliamentarian.id ?? 0);
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network(
                        widget.parliamentarian.photo ?? defaultImage,
                        width: 100,
                        height: 100,
                      ),
                      Text(widget.parliamentarian.name ?? ''),
                      Text('id: ${widget.parliamentarian.id}'),
                      Text(widget.parliamentarian.party ?? ''),
                      Text(widget.parliamentarian.uf ?? ''),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: detailsStore.state,
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                const Text('Detalhes'),
                                Text(value.nickname ?? 'deputado sem apelido'),
                                Text(value.birthDate ?? ''),
                                Text(value.education ?? ''),
                                Text(value.birthCity ?? ''),
                                Text(value.status ?? ''),
                                const Text('Gabinete:'),
                                for (var office in value.office!.entries)
                                  Text('${office.key}: ${office.value}')
                              ],
                            );
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text('Despesas'),
                      for (var expense in expenseStore.state.value)
                        Column(
                          children: [
                            Text(expense.type ?? ''),
                            Text(expense.documentDate ?? ''),
                            Text(expense.providerName ?? ''),
                          ],
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text('Ocupações'),
                      ValueListenableBuilder(
                          valueListenable: occupationStore.state,
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                for (var occupation in value)
                                  Column(
                                    children: [
                                      Text(occupation.title ?? 'Sem título'),
                                      Text(occupation.entity ?? ''),
                                      Text(
                                          '${occupation.startYear ?? 0} - ${occupation.endYear ?? 'Em exercício'}'),
                                    ],
                                  ),
                              ],
                            );
                          }),
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
