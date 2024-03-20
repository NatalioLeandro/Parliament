import 'package:flutter/material.dart';

import '../models/commission.dart';
import '../repositories/commission.dart';
import '../stores/commission.dart';
import '../services/client.dart';

class Commissions extends StatefulWidget {
  const Commissions({super.key});

  @override
  State<Commissions> createState() => _CommissionsState();
}

class _CommissionsState extends State<Commissions> {
  final CommissionStore store = CommissionStore(
      repository: CommissionRepository(
    client: HttpClient(),
  ));

  @override
  void initState() {
    super.initState();
    store.getCommissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Comissões',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBuilder(
        animation: store.isLoading,
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (store.error.value.isNotEmpty) {
            return Center(
              child: Text(store.error.value),
            );
          }

          return ListView.builder(
            itemCount: store.state.value.length,
            itemBuilder: (context, index) {
              final Commission commission = store.state.value[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Color(0xFF00BCD4)],
                  ),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                margin: const EdgeInsets.all(4),
                child: ListTile(
                  title: Text(commission.title,
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          scrollable: true,
                          alignment: Alignment.center,
                          titleTextStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          title: Text(commission.title),
                          content: Column(
                            children: [
                              FutureBuilder(
                                future: store.repository
                                    .getCommissionDetails(commission.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }

                                  final Map<String, dynamic> details =
                                      snapshot.data as Map<String, dynamic>;

                                  return Container(
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
                                          padding: const EdgeInsets.all(4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Titulo: ${details['dados']['titulo']}',
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Telefone: ${details['dados']['telefone']}',
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Email: ${details['dados']['email']}',
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                          ),
                                          child: const Text(
                                            'Detalhes do Coordenador',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    details['dados']
                                                            ['coordenador']
                                                        ['urlFoto'],
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              for (var info in details['dados']
                                                      ['coordenador']
                                                  .entries)
                                                if (info.key != 'urlFoto' &&
                                                    info.key != 'id' &&
                                                    info.key != 'uri' &&
                                                    info.key != 'uriPartido' &&
                                                    info.key != 'email')
                                                  Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.only(
                                                      bottom: 2,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '${info.key}: ',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${info.value}',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.blue,
                                                          ),
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
                              FutureBuilder(
                                future: store.repository
                                    .getCommissionParliamentarians(
                                        commission.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }

                                  final List<dynamic> parliamentarians =
                                      snapshot.data as List<dynamic>;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                        ),
                                        child: const Text(
                                          'Membros',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      for (var parliamentarian
                                          in parliamentarians)
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Colors.blue,
                                                Color(0xFF00BCD4)
                                              ],
                                            ),
                                            border: Border.all(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(4),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      parliamentarian[
                                                          'urlFoto'],
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: DefaultTextStyle(
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        parliamentarian['nome'],
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${parliamentarian['titulo']}' ,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${parliamentarian['siglaPartido']} - ${parliamentarian['siglaUf']}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Fechar',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
