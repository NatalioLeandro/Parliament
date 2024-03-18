import 'package:flutter/material.dart';
import 'package:parliament/repositories/occupation.dart';
import 'package:parliament/services/exceptions.dart';

import '../models/occupation.dart';

class OccupationStore {

  final OccupationRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Occupation>> state = ValueNotifier<List<Occupation>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  OccupationStore({required this.repository});

  Future getOccupations(int id) async {
    isLoading.value = true;
    try {
      final result = await repository.getOccupations(id);
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