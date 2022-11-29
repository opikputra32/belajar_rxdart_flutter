import 'package:flutter/foundation.dart' show immutable;
import 'package:testingrxdart_course/models/thing.dart';

@immutable
class Person extends Thing {
  final int age;

  Person({required String name, required this.age}) : super(name: name);

  @override
  String toString() {
    return 'Person, name $name, type: $age ';
  }

  Person.fromJson(Map<String, dynamic> json)
      : age = json["age"] as int,
        super(name: json["name"] as String);
}
