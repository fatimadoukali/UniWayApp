import 'package:uniwayapp/Model/CondidatModel.dart';

class AdminstratorsModele extends CondidatModel {
  final String job;
  AdminstratorsModele({
    required this.job,
    required super.firstname,
    required super.lastname,
    required super.email,
    required super.nmbofphone,
    required super.age,
    required super.situation,
    required super.sex,
    required super.yearofstart,
    required super.specialty,
    super.status,
  });

  bool matchesSearch(String searchText) {
    final lowercaseSearchText = searchText.toString();
    return firstname.toString().contains(lowercaseSearchText) ||
        lastname.toString().contains(lowercaseSearchText) ||
        job.toString().contains(lowercaseSearchText) ||
        email.toString().contains(lowercaseSearchText) ||
        nmbofphone.toString().contains(lowercaseSearchText) ||
        age.toString().contains(lowercaseSearchText) ||
        sex.toString().contains(lowercaseSearchText) ||
        specialty.toString().contains(lowercaseSearchText) ||
        yearofstart.toString().contains(lowercaseSearchText);
  }
}
