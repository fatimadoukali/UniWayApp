import 'package:uniwayapp/Model/CondidatModel.dart';

class ProfessorModel extends CondidatModel {
  final String grade;
  ProfessorModel({
    required this.grade,
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
        grade.toString().contains(lowercaseSearchText) ||
        email.toString().contains(lowercaseSearchText) ||
        nmbofphone.toString().contains(lowercaseSearchText) ||
        age.toString().contains(lowercaseSearchText) ||
        sex.toString().contains(lowercaseSearchText) ||
        specialty.toString().contains(lowercaseSearchText) ||
        yearofstart.toString().contains(lowercaseSearchText);
  }
}
