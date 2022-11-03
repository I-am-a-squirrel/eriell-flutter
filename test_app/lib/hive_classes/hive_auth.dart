import 'package:hive/hive.dart';
part 'hive_auth.g.dart';

@HiveType(typeId: 0)
class Person {
  Person({required this.login, required this.password});

  @HiveField(0)
  String login;

  @HiveField(1)
  String password;
}