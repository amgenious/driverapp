// ignore_for_file: prefer_final_fields, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:driver_app/wrapper/wrapper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddProfilePicture extends StatefulWidget {
  final String driverid;
  const AddProfilePicture({super.key, required this.driverid});

  @override
  State<AddProfilePicture> createState() => _AddProfilePictureState();
}

class _AddProfilePictureState extends State<AddProfilePicture> {
  late String driverid;
  String? base64Image;
  @override
  void initState() {
    super.initState();
    driverid = widget.driverid;
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    var cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
    } else {}
  }

  ImagePicker _imagePicker = ImagePicker();
  File? imageFile;

  getImageFromGallery() async {
    var imageSource = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(imageSource!.path);
    });
    await imageToBase64(imageFile!);
  }

  Future imageToBase64(File imageFile) async {
    // Read image bytes
    List<int> imageBytes = await imageFile.readAsBytes();

    // Encode image bytes to Base64
    base64Image = base64Encode(imageBytes);
  }

  sendImageData() async {
    Map<String, dynamic> imageData = {
      "image": {
        "ID": driverid,
        "Name": "imagename",
        "Size": "2mb",
        "ContentType": "jpg/png",
        "Data": base64Image,
      },
    };
    await sendImage(imageData);
  }

  Future<void> sendImage(Map<String, dynamic> imageData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    const String apiUrl =
        'https://staging-bustransit-api-sfw2.encr.app/api/driver/profile';
    final String? accessToken = token;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final http.Response response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(imageData),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image Updated'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WrapperPage()),
        );
      } else if (response.statusCode == 400) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image not uploaded'),
          ),
        );
        Navigator.pop(context);
        print('Image not uploaded. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Add Profile Picture",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            getImageFromGallery();
          },
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.grey.shade300, shape: BoxShape.circle),
            child: imageFile == null
                ? const Icon(
                    Icons.camera,
                    size: 30,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        GestureDetector(
          onTap: () {
            sendImageData();
          },
          child: Container(
            alignment: Alignment.center,
            // height: 20,
            width: 100,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
            child: const Text("Upload Image"),
          ),
        )
      ],
    );
  }
}
