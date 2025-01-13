import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Exam_Timetable/Update_ExamTimetable_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

Future<void> updateExamTimeTable(UpdateExamTimetableModel examTimeTable,
    PlatformFile selectedFile, BuildContext context) async {
  const String apiUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeExamTimetable/updateExamTimeTable";

  try {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(apiUrl),
    );

    request.headers['Authorization'] = 'Bearer $authToken';

    request.fields['Id'] = examTimeTable.id;
    request.fields['UserType'] = examTimeTable.userType;
    request.fields['RollNumber'] = examTimeTable.rollNumber;
    request.fields['HeadLine'] = examTimeTable.headLine;
    request.fields['Description'] = examTimeTable.description;
    request.fields['Exam'] = examTimeTable.exam;
    request.fields['FileType'] = examTimeTable.fileType;
    request.fields['UpdatedOn'] = examTimeTable.updatedOn;

    if (selectedFile != null && selectedFile.path != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'File',
        selectedFile.path!,
        contentType: MediaType('image', selectedFile.extension!),
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print(response);
      print("Data updated successfully.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exam TimeTable updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update Exam TimeTable. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print("Failed to update data. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
