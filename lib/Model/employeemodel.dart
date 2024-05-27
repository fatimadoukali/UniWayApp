class EmployeeRequest {
  String name;
  String password;
  String job;
  String email;

  EmployeeRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.job,
  });
  bool matchesSearch(String searchText) {
    final lowercaseSearchText = searchText.toString();
    return name.toString().contains(lowercaseSearchText) ||
        password.toString().contains(lowercaseSearchText) ||
        job.toString().contains(lowercaseSearchText) ||
        email.toString().contains(lowercaseSearchText);
  }
}
