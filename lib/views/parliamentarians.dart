import 'package:flutter/material.dart';

import 'package:parliament/repositories/parliamentarian.dart';
import 'package:parliament/stores/parliamentarian.dart';

import '../routes/router.dart' as routes;
import '../services/client.dart';

class Parliamentarians extends StatefulWidget {
  const Parliamentarians({super.key});

  @override
  State<Parliamentarians> createState() => _ParliamentariansState();
}

class _ParliamentariansState extends State<Parliamentarians> {
  final ParliamentarianStore store = ParliamentarianStore(
      repository: ParliamentarianRepository(
    client: HttpClient(),
  ));


  @override
  void initState() {
    super.initState();
    store.getParliamentarians();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[800],
          title: const Text(
            'Deputados',
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: AnimatedBuilder(
        animation: Listenable.merge(
          [
            store.isLoading,
            store.state,
            store.error,
          ],
        ),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (store.error.value.isNotEmpty) {
            return Center(
              child: Text(store.error.value),
            );
          }

          if (store.state.value.isEmpty) {
            return const Center(
              child: Text('No deputies found'),
            );
          }

          return ListView.builder(
            itemCount: store.state.value.length,
            itemBuilder: (context, index) {
              final parliamentarian = store.state.value[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    routes.parliamentarian,
                    arguments: parliamentarian,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.green[800]!,
                    ),
                  ),
                  margin: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green[800]!,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              parliamentarian.photo,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              parliamentarian.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              parliamentarian.party,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
