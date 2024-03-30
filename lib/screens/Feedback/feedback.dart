import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E1219),
      appBar: AppBar(
        title: Text(
          "FeedbackForm",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        backgroundColor: const Color(0xff0E1219),
        iconTheme: const IconThemeData(color: Color(0xffffffff)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const FeedbackFormContent(),
    );
  }
}

class FeedbackFormContent extends StatefulWidget {
  const FeedbackFormContent({super.key});

  @override
  _FeedbackFormContentState createState() => _FeedbackFormContentState();
}

class _FeedbackFormContentState extends State<FeedbackFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();
  File? _image;
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10.0), // adjust the value as needed
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10.0), // adjust the value as needed
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10.0), // adjust the value as needed
              child: TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                    labelText: 'Feedback',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await showDialog<File>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Select option'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () async {
                              final pickedFile = await picker.pickImage(
                                  source: ImageSource.camera);
                              if (pickedFile != null) {
                                Navigator.pop(context, File(pickedFile.path));
                              }
                            },
                            child: const Text('Take a picture'),
                          ),
                          SimpleDialogOption(
                            onPressed: () async {
                              final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedFile != null) {
                                Navigator.pop(context, File(pickedFile.path));
                              }
                            },
                            child: const Text('Choose from gallery'),
                          ),
                        ],
                      );
                    },
                  );

                  if (pickedFile != null) {
                    setState(() {
                      _image = pickedFile;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0E1219),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                child: const Text('Upload Image', style: TextStyle(color: Colors.white)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0E1219),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                child: const Text('Submit', style: TextStyle(color: Colors.white),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_image != null) {
      final cloudinary =
          CloudinaryPublic('dfdrjhn9i', 'uikdpdqh', cache: false);
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_image!.path,
            resourceType: CloudinaryResourceType.Image),
      );
      _imageUrl = response.secureUrl;

      if (_imageUrl != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image uploaded to Cloudinary'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    final Map<String, dynamic> requestBody = {
      'query': '''mutation {
        createFeedback(
            name: "${_nameController.text}"
            email: "${_emailController.text}"
            feedback: "${_feedbackController.text}"
            imgUri: "${_imageUrl ?? ''}"
        ) {
          id,
          name,
          email,
          feedback,
          imgUri,
        }
      }''',
    };

    final response = await http.post(
      Uri.parse(
          'https://v3-server.vercel.app/graphql/feedback/?api_key=247da0f7b7f3bfcbea1b73a401cb426f'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Form submitted successfully');
    } else {
      print('Failed to submit form: ${response.body}');
    }
  }
}
