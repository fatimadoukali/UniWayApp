class ScholarshipModel {
  final String ScholarshipName;
  final String ScholarshipDeadlines;
  final String ScholarshipType;
  final String SchoalrshipAmount;
  final String ScholarshipDocuments;
  final String UniversityName;
  final String AcdimicLanguage;
  final String pays;
  final String years;

  ScholarshipModel(
      {required this.ScholarshipName,
      required this.ScholarshipDeadlines,
      required this.years,
      required this.ScholarshipType,
      required this.SchoalrshipAmount,
      required this.ScholarshipDocuments,
      required this.AcdimicLanguage,
      required this.UniversityName,
      required this.pays
      });
  bool matchesSearch(String searchText) {
    final lowercaseSearchText = searchText.toString();
    return ScholarshipName.toString().contains(lowercaseSearchText) ||
        ScholarshipDeadlines.toString().contains(lowercaseSearchText) ||
        years.toString().contains(lowercaseSearchText) ||
        ScholarshipType.toString().contains(lowercaseSearchText) ||
        SchoalrshipAmount.toString().contains(lowercaseSearchText) ||
        ScholarshipDocuments.toString().contains(lowercaseSearchText) ||
        AcdimicLanguage.toString().contains(lowercaseSearchText) ||
        UniversityName.toString().contains(lowercaseSearchText) ||
        pays.toString().contains(lowercaseSearchText);
  }
}
