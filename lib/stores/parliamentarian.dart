import 'package:flutter/material.dart';

import 'package:parliament/repositories/parliamentarian.dart';
import 'package:parliament/services/exceptions.dart';
import '../models/parliamentarian.dart';

class ParliamentarianStore {

  final ParliamentarianRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Parliamentarian>> state = ValueNotifier<List<Parliamentarian>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  ParliamentarianStore({required this.repository});

  Future getParliamentarians() async {

    isLoading.value = true;

    try {
      final result = await repository.getParliamentarians();
      state.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }

  }

}