import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/main_drawer.dart';
import 'package:track_fusion_ui/globals.dart' as globals;
import 'package:conduit_password_hash/conduit_password_hash.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Login',
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 400,
          height: 500,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('assets/images/TrackFusionLogo.png'),
                  width: 200,
                  height: 200,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle login logic
                    registerUser(context);
                  },
                  child: Text('Login'),
                ),
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('Register'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: Text('Forgot Password'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
      drawer: MainDrawer(),
    );
  }

  void registerUser(BuildContext context) async {
    var email = emailController.text;
    var password = passwordController.text;
    var hashedPassword = globals.saltAndHashPassword(password);
    var apiBasePath = globals.apiBasePath;

    var postBody = {"email": email, "password": hashedPassword};

    final response = await http.post(
      Uri.parse('$apiBasePath/login'),
      body: json.encode(postBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    debugPrint('Error: ${response.body}');
    debugPrint('Request Body: ${json.encode(postBody)}');
    globals.userId = email;
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging in user'),
        ),
      );
    }
  }
}
