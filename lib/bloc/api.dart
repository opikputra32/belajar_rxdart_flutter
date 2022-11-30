import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show immutable;

import 'package:testingrxdart_course/models/animal.dart';
import 'package:testingrxdart_course/models/person.dart';
import 'package:testingrxdart_course/models/thing.dart';

typedef SearchTerm = String;

@immutable
class Api {
  List<Animal>? _animals;
  List<Person>? _persons;
  Api();

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;
    if (cachedAnimals != null && cachedPersons != null) List<Thing> result = [];
    for (final animal in cachedAnimals!) {
      if (animal.name.trimmedContains(term) ||
          animal.type.name.trimmedContains(term)) {}
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((response) => response.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimmedContains(String other) => trim().toLowerCase().contains(
        other.trim().toLowerCase(),
      );
}
