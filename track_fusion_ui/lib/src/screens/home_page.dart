import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/main_drawer.dart';

class HomePage extends StatelessWidget {

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home Page',
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(onPressed: () {
            Navigator.pushNamed(context, '/login');
          }, icon: Icon(Icons.login_rounded))
        ],
      ),
      body: Center(
        child: Text('Home Page'),
      ),
      drawer: MainDrawer(),
    );
  }
}