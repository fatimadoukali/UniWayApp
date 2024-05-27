class CondidatModel {
  final String firstname;
  final String lastname;
  final String email;
  final String nmbofphone;
  final String age;
  final String situation;
  final String specialty;
  final String sex;
  final String yearofstart;
  late String? status;
  CondidatModel(
      {this.status = 'Reject',
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.nmbofphone,
      required this.age,
      required this.situation,
      required this.specialty,
      required this.sex,
      required this.yearofstart});
}
