import 'package:flutter/material.dart';
import 'package:parliament/views/parliamentarians.dart';

import '../models/parliamentarian.dart';
import '../views/home.dart';
import '../views/parliamentarian_details.dart';

const String home = '/';
const String parliamentarians = '/parliamentarians';
const String parliamentarian = '/parliamentarian';

Route controller(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const Home());
    case '/parliamentarians':
      return MaterialPageRoute(builder: (context) => const Parliamentarians());
    case '/parliamentarian':
      return MaterialPageRoute(builder: (context) => ParliamentarianDetails(parliamentarian: settings.arguments as Parliamentarian));
    default:
      return MaterialPageRoute(builder: (context) => const Home());
  }
}