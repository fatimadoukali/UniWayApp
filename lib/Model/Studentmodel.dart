import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniwayapp/Model/CondidatModel.dart';

class Studentmodel extends CondidatModel {
  late final String level;

  Studentmodel({
    required this.level,
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

  factory Studentmodel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return Studentmodel(
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      email: data['email'] ?? '',
      nmbofphone: data['phone'] ?? '',
      age: data['age'] ?? '',
      situation: data['situation'] ?? '',
      sex: data['sex'] ?? '',
      specialty: data['specialty'] ?? '',
      yearofstart: data['yearOfStart'] ?? '',
      level: data['level'] ?? '',
    );
  }

  bool matchesSearch(String searchText) {
    final lowercaseSearchText = searchText.toString();
    return firstname.toString().contains(lowercaseSearchText) ||
        lastname.toString().contains(lowercaseSearchText) ||
        level.toString().contains(lowercaseSearchText) ||
        email.toString().contains(lowercaseSearchText) ||
        nmbofphone.toString().contains(lowercaseSearchText) ||
        age.toString().contains(lowercaseSearchText) ||
        sex.toString().contains(lowercaseSearchText) ||
        specialty.toString().contains(lowercaseSearchText) ||
        yearofstart.toString().contains(lowercaseSearchText);
  }
}
