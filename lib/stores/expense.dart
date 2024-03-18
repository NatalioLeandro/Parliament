import 'package:flutter/material.dart';
import 'package:parliament/repositories/expense.dart';
import 'package:parliament/services/exceptions.dart';

import '../models/expense.dart';

class ExpenseStore {

  final ExpenseRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Expense>> state = ValueNotifier<List<Expense>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  ExpenseStore({required this.repository});

  Future getExpenses(int id) async {
    isLoading.value = true;
    try {
      final result = await repository.getExpenses(id);
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