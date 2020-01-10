import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ALPR extends StatefulWidget {
  @override
  _ALPRState createState() => _ALPRState();
}

class _ALPRState extends State<ALPR> {
  File _image;
  final String API_TOKEN = '5fd073409dd7239a9d071e7b4f292744c1abe267';

  // using http.post

//  void _getData(File image) async {
//    String base64Image = base64Encode(image.readAsBytesSync());
//    var response = await http.post(
//        "https://api.platerecognizer.com/v1/plate-reader/",
//        body: json.encode({"upload": base64Image}),
//        headers: {
//          'Content-Type': 'application/json',
//          HttpHeaders.authorizationHeader: "Token ${API_TOKEN}",
//        });
//
//    if (response.statusCode == 200) {
//      String data = response.body;
//      print("It worked!!!");
//      // return jsonDecode(data);
//    } else {
//      print(response.statusCode);
//    }
//  }

  //using the multipart class to convert the code to.
//  void _getData(File image) async {
//    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
//    var length = await image.length();
//    var uri = Uri.parse("https://api.platerecognizer.com/v1/plate-reader/");
//
//    var request = new http.MultipartRequest("POST", uri);
//    var multipartFIle = new http.MultipartFile("imagefile", stream, length);
//
//    request.headers['authorization'] = "Token ${API_TOKEN}";
//    request.files.add(multipartFIle);
//    var response = await request.send();
//    print(response.statusCode);
//  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse("https://api.platerecognizer.com/v1/plate-reader/");

    var request = new http.MultipartRequest("POST", uri);
    var multipartFIle = new http.MultipartFile("imagefile", stream, length);

    request.headers['authorization'] = "Token ${API_TOKEN}";
    request.files.add(multipartFIle);
    var response = await request.send();
    print(response.statusCode);

    setState(() {
      _image = image;
    });
    //   _getData(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Licence Plate recognizer"),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.blue),
              child: Center(
                child: Text(
                  'Automatic License Plate Number Recogniser',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
              width: 310,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15)),
            width: 300,
            height: 300,
            child: Center(
                child: _image == null
                    ? Text("No image selected")
                    : Image.file(_image)),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child: Center(
              child: Text(
                "platenumber Appears here...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Montserrat'),
              ),
            ),
            height: 80,
            width: 350,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getImage();
        },
        label: Text("Take Picture"),
        icon: Icon(Icons.camera),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
