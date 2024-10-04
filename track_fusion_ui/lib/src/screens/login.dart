// import 'package:flutter_login/flutter_login.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import '../widgets/custom_app_bar.dart';
// import '../widgets/main_drawer.dart';

// class Login extends StatelessWidget {
//   static const routeName = '/login';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Login',
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: FlutterLogin(
//         onSignup: (data) {
//           print('Signup info');
//           print('Name: ${data.name}');
//           print('Email: ${data.name}');
//           print('Password: ${data.name}');
//           return Future.value(null);
//         },
//         onLogin: (data) {
//           print('Login info');
//           print('Name: ${data.name}');
//           print('Password: ${data.name}');
//           return Future.value(null);
//         },
//         onRecoverPassword: (data) {
//           print('Recover password info');
//           //print('Email: ${data.name}');
//           return Future.value(null);
//         },
//       ),
//       drawer: MainDrawer(),
//     );
//   }
// }