import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:get/get.dart';

class GradeController extends GetxController {
  var gradeList = [].obs;
  var examList = <String>[].obs;
  var subjectList = <String>[].obs;
  var filteredSubjects = <String>[].obs;

  Future<void> fetchGrades() async {
    const url =
        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/GradeValueFetch/GettingGrades';

    try {
      final response = await GetConnect().get(url, headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        gradeList.value = response.body;

        print(response.body);
        examList.value = gradeList
            .expand((grade) => grade['exams'])
            .toSet()
            .toList()
            .cast<String>();

        //subjects..
        subjectList.value = gradeList
            .expand((grade) => grade['subjects'])
            .toSet()
            .toList()
            .cast<String>();
      } else {
        print('Error, Failed to fetch grades: ${response.statusCode}');
      }
    } catch (e) {
      print('Error, An error occurred: $e');
    }
  }

  // Filter subjects based on grade ID
  void filterSubjectsByGrade(int gradeId) {
    final grade = gradeList.firstWhere(
      (grade) => grade['id'] == gradeId,
      orElse: () => null,
    );

    if (grade != null) {
      filteredSubjects.value = List<String>.from(grade['subjects'] ?? []);
    } else {
      filteredSubjects.clear();
      Get.snackbar('Info', 'No subjects found for the selected grade.');
    }
  }
}
