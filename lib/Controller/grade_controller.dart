import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:get/get.dart';

class GradeController extends GetxController {
  var gradeList = [].obs;

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
      } else {
        Get.snackbar('Error', 'Failed to fetch grades: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
