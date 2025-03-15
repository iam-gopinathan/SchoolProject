import 'package:flutter_application_1/models/Approver_model/News_update_Approver_model.dart';

import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';

const String apiUrl =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeNews/updateNews';

Future<bool> ApproverEditWithFormData(
    NewsUpdateApproverModel news, File? file) async {
  try {
    final request = http.MultipartRequest('PUT', Uri.parse(apiUrl))
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $authToken', // Ensure authToken is defined
      })
      ..fields['id'] = news.id.toString()
      ..fields['rollNumber'] = news.rollNumber
      ..fields['userType'] = news.userType
      ..fields['headLine'] = news.headLine
      ..fields['news'] = news.news
      ..fields['fileType'] = news.fileType
      ..fields['link'] = news.link
      ..fields['scheduleOn'] = news.scheduleOn ?? ''
      ..fields['updatedOn'] = news.updatedOn ?? ''
      ..fields['action'] = news.action; // Ensure action field is included

    if (file != null) {
      String contentType = _getContentType(file);
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(contentType),
      ));
    }

    final response = await request.send();
    final responseBody =
        await response.stream.bytesToString(); // Read response body

    if (response.statusCode == 200) {
      print('News updated successfully: $responseBody');
      return true;
    } else {
      print('Failed to update news: ${response.statusCode} - $responseBody');
      return false;
    }
  } catch (e) {
    print('Error updating news: ${e.toString()}');
    return false;
  }
}

String _getContentType(File file) {
  String fileExtension = file.path.split('.').last.toLowerCase();
  switch (fileExtension) {
    case 'jpeg':
    case 'jpg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    default:
      return 'application/octet-stream';
  }
}
