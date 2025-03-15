import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/News_Models/Create_news_model.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const String _baseUrl =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/news/postNews';

Future<void> postNews(CreateNewsModel newsPost, String action,
    BuildContext context, Function onCreateNews) async {
  final String rollNumber = UserSession().rollNumber ?? '';
  final String userType = UserSession().userType ?? '';
  String? postedOn;
  String? scheduleOn;
  String? draftedOn;
  if (action == 'post') {
    postedOn = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
  } else if (action == 'draft') {
    draftedOn = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
  } else if (action == 'schedule') {
    scheduleOn = newsPost.scheduleOn.isNotEmpty
        ? newsPost.scheduleOn
        : DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
  }
  final Map<String, String> fields = {
    'Headline': newsPost.headline,
    'News': newsPost.news,
    'UserType': userType,
    'RollNumber': rollNumber,
    'PostedOn': postedOn ?? '',
    'ScheduleOn': scheduleOn ?? '',
    'DraftedOn': draftedOn ?? '',
    'Status': newsPost.status,
    'FileType': newsPost.fileType,
    'Link': newsPost.link,
  };

  var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

  fields.forEach((key, value) {
    request.fields[key] = value;
  });

  if (newsPost.file.isNotEmpty) {
    final fileBytes = base64Decode(newsPost.file);
    final file =
        http.MultipartFile.fromBytes('File', fileBytes, filename: 'image.jpg');
    request.files.add(file);
  }

  if (newsPost.link.isNotEmpty) {
    request.fields['Link'] = newsPost.link;
  }

  request.headers['Authorization'] = 'Bearer $authToken';
  request.headers['Content-Type'] = 'multipart/form-data';

  try {
    final response = await request.send();

    final responseBody = await response.stream.bytesToString();
    print('Response Body: $responseBody');

    if (response.statusCode == 200) {
      print('News posted successfully!');

      String snackBarMessage = '';
      if (userType == 'superadmin') {
        if (action == 'post') {
          snackBarMessage = 'News Created Successfully!';
        } else if (action == 'schedule') {
          snackBarMessage = 'News Scheduled Successfully!';
        }
      } else if (userType == 'admin' || userType == 'staff') {
        if (action == 'post') {
          snackBarMessage = 'News Creation Request Was Sent Successfully!';
        } else if (action == 'schedule') {
          snackBarMessage = 'News Scheduling Request Was Sent Successfully!';
        }
      }

      // ✅ Correctly handle "Draft" case
      if (action == 'draft') {
        snackBarMessage = ' News Saved as Draft!';
      }

      if (snackBarMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(snackBarMessage),
          ),
        );
      }
      // Delay before navigation
      await Future.delayed(Duration(seconds: 2));
      onCreateNews();
      Navigator.pop(context);
      //
    } else {
      print('Failed to post news: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to post news.'),
        ),
      );
      onCreateNews();
      Navigator.pop(
        context,
      );
    }
  } catch (e) {
    print('Error posting news: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Error posting news: $e'),
      ),
    );
    onCreateNews();
    Navigator.pop(
      context,
    );
  }
}

//  **Function to Send Push Notification**
Future<void> sendPushNotification(String title, String body) async {
  final Uri uri = Uri.parse(
      'http://localhost:5001/send-notification'); // Update with your server URL
  final Map<String, dynamic> notificationData = {
    'token': "YOUR_DEVICE_FCM_TOKEN", // Replace with actual FCM token
    'title': title,
    'body': body
  };

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(notificationData),
  );

  if (response.statusCode == 200) {
    print("Push notification sent successfully!");
  } else {
    print("Failed to send push notification: ${response.body}");
  }
}
