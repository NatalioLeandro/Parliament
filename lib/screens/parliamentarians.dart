import 'package:flutter/material.dart';

import 'package:parliament/repositories/parliamentarian.dart';
import 'package:parliament/stores/parliamentarian.dart';

import '../models/parliamentarian.dart';
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

  String query = '';

  @override
  void initState() {
    super.initState();
    store.getParliamentarians();
  }

  List<Parliamentarian> filterParliamentarians(List<Parliamentarian> parliamentarians) {
    return parliamentarians.where((parliamentarian) =>
    parliamentarian.name.toLowerCase().contains(query.toLowerCase()) ||
        parliamentarian.party.toLowerCase().contains(query.toLowerCase()) ||
        parliamentarian.uf.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Deputados',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar Deputados...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (value) => setState(() {
                query = value;
              }),
            ),
          ),
        ),
      ),
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

          if (store.state.value.isEmpty) {
            return const Center(
              child: Text('Nenhum deputado encontrado.'),
            );
          }

          final filteredParliamentarians = filterParliamentarians(store.state.value);

          return ListView.builder(
            itemCount: filteredParliamentarians.length,
            itemBuilder: (context, index) {
              final parliamentarian = filteredParliamentarians[index];
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
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Color(0xFF00BCD4)],
                    ),
                    border: Border.all(
                      color: Colors.blue,
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
                              color: Colors.blue,
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
                        child: DefaultTextStyle(
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                parliamentarian.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${parliamentarian.party} - ${parliamentarian.uf}',
                              ),
                            ],
                          ),
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
