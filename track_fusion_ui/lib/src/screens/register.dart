import 'package:flutter/material.dart';
import 'package:conduit_password_hash/conduit_password_hash.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  bool _isEmailValid = false;

  bool _isPasswordValid = false;

  bool _isConfirmPasswordValid = false;

  bool _hidePassword = true;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage('assets/images/TrackFusionLogo.png'),
                    width: 200,
                    height: 200,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                      errorText:
                          _isEmailValid ? null : 'Please enter a valid email',
                    ),
                    validator: validateEmail,
                    onChanged: (value) {
                      setState(() {
                        _isEmailValid =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value);
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _hidePassword,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: _hidePassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () => setState(() {
                          _hidePassword = !_hidePassword;
                        }),
                      ),
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                      errorText: _isPasswordValid
                          ? null
                          : 'Password must be at least 8 characters, contain a number, an uppercase and a lowercase letter, and a special character',
                    ),
                    validator: validatePassword,
                    onChanged: (value) {
                      setState(() {
                        _isPasswordValid = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                            .hasMatch(value);
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _hidePassword,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: _hidePassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () => setState(() {
                          _hidePassword =! _hidePassword;
                        }),
                      ),
                      hintText: 'Confirm Password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                      errorText: _isConfirmPasswordValid
                          ? null
                          : 'Passwords must match',
                    ),
                    validator: validateConfirmPassword,
                    onChanged: (value) {
                      setState(() {
                        _isConfirmPasswordValid = validateConfirmPassword(value) == null;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    style: validateForm() ? null : ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.grey),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    label: const Text('Submit'),
                    icon: validateForm() ? const Icon(Icons.send) : const Icon(Icons.error),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateForm() {
    return _isEmailValid && _isPasswordValid && _isConfirmPasswordValid;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    setState(() {
      _isEmailValid = true;
    });
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(value)) {
      return 'Password must be at least 8 characters, contain a number, an uppercase and a lowercase letter, and a special character';
    }
    setState(() {
      _isPasswordValid = true;
    });
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if ( confirmPasswordController.text == passwordController.text) {
      return null;
    } else {
      return 'Passwords do not match';
    }
  }

  String? saltAndHashPassword(String password) {
    var generator = PBKDF2();
    var salt = generateAsBase64String(32);
    var hash = generator.generateBase64Key(password, salt, 1000, 32);
    return hash;
  }
}
