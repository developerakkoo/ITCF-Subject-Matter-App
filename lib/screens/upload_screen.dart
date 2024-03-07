import 'dart:io';

import 'package:dio/dio.dart';
import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class UploadFilesScreen extends StatefulWidget {
  const UploadFilesScreen({super.key});

  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  List<File> _selectedFiles = [];
  SharedPreferences? prefs;
  String? userId;
  double progress = 0;

  void getUserId() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs?.getString("id") ?? "";
    print(userId);
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  void pickFiles() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.paths.map((path) => File(path!)));
        });
        print(_selectedFiles);
        _uploadFiles();
      } else {
        // User canceled the picker
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) {
      return;
    }

    FormData formData = FormData();
    for (int i = 0; i < _selectedFiles.length; i++) {
      File file = _selectedFiles[i];
      formData.files.add(MapEntry(
        'Docs',
        await MultipartFile.fromFile(file.path),
      ));
    }

    Dio dio = Dio();

    await dio
        .put(
          'http://35.78.76.21:8000/post/subMatterEx/Docs/$userId',
          data: formData,
          onSendProgress: (int sent, int total) {
            setState(() {
              progress = (sent / total) * 90;
            });
          },
        )
        .then((success) => {
              print(success),
              print(success.statusCode),
              print("-----RESPONSE------"),
              setState(() {
                progress = 100;
              }),
              EmojiAlert(
                  height: 280,
                  alertTitle: Text("Success",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  emojiType: EMOJI_TYPE.HAPPY,
                  description: Column(
                    children: [
                      Text(
                        "You have successfully submitted your application. We will get back to you shortly!",
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/login');
                          },
                          child: Text("Okay!"))
                    ],
                  )).displayAlert(context)
            })
        .catchError((error) => {print(error)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Upload your Files",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "Your Resume, Certifications, Etc",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            Text(
              "$progress %",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            GestureDetector(
                onTap: () => pickFiles(),
                child: Image.asset(
                  'assets/images/uploadbtn.png',
                ))
          ],
        ),
      ),
    );
  }
}
