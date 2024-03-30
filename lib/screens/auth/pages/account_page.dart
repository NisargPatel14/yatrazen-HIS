import 'package:flutter/material.dart';
import 'package:yatrazen/screens/auth/api/auth_api.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late String? email;
  late String? username;
  TextEditingController bioTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
  TextEditingController genderTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();
  TextEditingController interestsTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final AuthAPI appwrite = context.read<AuthAPI>();
    email = appwrite.email;
    username = appwrite.username;
    appwrite.getUserPreferences().then((value) {
      if (value.data.isNotEmpty) {
        setState(() {
          bioTextController.text = value.data['bio'];
          ageTextController.text = value.data['age'];
          genderTextController.text = value.data['gender'];
          locationTextController.text = value.data['location'];
          interestsTextController.text = value.data['interests'];
          imageTextController.text = value.data['image'];
        });
      }
    });
  }

  savePreferences() {
    final AuthAPI appwrite = context.read<AuthAPI>();
    appwrite.updatePreferences(
      bio: bioTextController.text,
      age: ageTextController.text,
      image: imageTextController.text,
      gender: genderTextController.text,
      location: locationTextController.text,
      interests: interestsTextController.text,
    );
    const snackbar = SnackBar(
        content: Text('Preferences updated!',
            style: TextStyle(color: Colors.white)));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  signOut() {
    final AuthAPI appwrite = context.read<AuthAPI>();
    appwrite.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        backgroundColor: const Color(0xff0E1219),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              signOut();
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageTextController.text
                  .isNotEmpty) // Only show the image if the URL is not empty
                CircleAvatar(
                  radius: 50,
                  backgroundImage: imageTextController.text.isNotEmpty
                      ? NetworkImage(imageTextController.text)
                      : null,
                  child: imageTextController.text.isEmpty
                      ? const CircularProgressIndicator() // Show loading indicator while image is loading
                      : null,
                ),
              const SizedBox(height: 14),
              Text(
                'Welcome back, $username!',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '$email',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 40),
              TextField(
                style: (const TextStyle(color: Colors.white)),
                controller: bioTextController,
                decoration: const InputDecoration(
                  labelText: 'Your Bio',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white), // Add this line
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                style: (const TextStyle(color: Colors.white)),
                controller: ageTextController,
                decoration: const InputDecoration(
                  labelText: 'Your Age',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white), // Add this line
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                style: (const TextStyle(color: Colors.white)),
                controller: genderTextController,
                decoration: const InputDecoration(
                  labelText: 'Your Gender',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white), // Add this line
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                style: (const TextStyle(color: Colors.white)),
                controller: locationTextController,
                decoration: const InputDecoration(
                  labelText: 'Your Location',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white), // Add this line
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                style: (const TextStyle(color: Colors.white)),
                controller: interestsTextController,
                decoration: const InputDecoration(
                  labelText: 'Your Interests',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white), // Add this line
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                style: (const TextStyle(color: Colors.white)),
                controller: imageTextController,
                decoration: const InputDecoration(
                  labelText: 'Your Image URL',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white), // Add this line
                  hintStyle: TextStyle(color: Colors.white), // Add this line
                  // Add any additional styles you want to modify here
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => savePreferences(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0E1219),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                child: const Text(
                  'Save Preferences',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
