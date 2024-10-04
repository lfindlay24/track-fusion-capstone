import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class MainDrawer extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Track Fusion'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name != '/') {
                Navigator.pushNamed(context, '/');
              }
            },
          ),
          ListTile(
            title: Text('Garages'),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name != '/garages') {
                Navigator.pushNamed(context, '/garages');
              }
            },
          ),
          ListTile(
            title: Text('Login'),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name != '/login') {
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
          ListTile(
            title: Text('Login'),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name != '/login') {
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
          ListTile(
            title: Text('Race Mode'),
            trailing: kIsWeb ? Icon(Icons.lock) : Platform.isWindows ? Icon(Icons.lock) : null,
            onTap: () {
              debugPrint("Is web? $kIsWeb");
              if (!kIsWeb && !Platform.isWindows) {
                Navigator.pop(context);
                if (ModalRoute.of(context)!.settings.name != '/login') {
                  Navigator.pushNamed(context, '/login');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
