import 'package:appwrite/appwrite.dart';
import 'package:yatrazen/screens/auth/api/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
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
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  bool loading = false;

  void signIn(BuildContext context) async {
    setState(() {
      loading = true;
    });

    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createEmailSession(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // Show a Snackbar upon successful login
      

      // Navigate to the home page
      Navigator.pushReplacementNamed(context, '/');
    } on AppwriteException catch (e) {
      // Show an alert dialog if login fails
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(e.message.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailTextController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordTextController,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                signIn(context);
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text("Sign in",  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0E1219),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Create Account',  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
            ),
            const SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.black,
            //         backgroundColor: Colors.white,
            //       ),
            //       child: SvgPicture.asset('assets/google_icon.svg', width: 12),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.black,
            //         backgroundColor: Colors.white,
            //       ),
            //       child: SvgPicture.asset('assets/apple_icon.svg', width: 12),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.black,
            //         backgroundColor: Colors.white,
            //       ),
            //       child: SvgPicture.asset('assets/github_icon.svg', width: 12),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.black,
            //         backgroundColor: Colors.white,
            //       ),
            //       child: SvgPicture.asset('assets/twitter_icon.svg', width: 12),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
