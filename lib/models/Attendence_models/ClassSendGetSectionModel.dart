class Section {
  final String sectionName;

  Section({required this.sectionName});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      sectionName: json['sectionName'],
    );
  }
}

class SectionsResponse {
  final List<Section> sections;

  SectionsResponse({required this.sections});

  factory SectionsResponse.fromJson(Map<String, dynamic> json) {
    return SectionsResponse(
      sections: List<Section>.from(
        json['sections'].map((data) => Section.fromJson(data)),
      ),
    );
  }
}
