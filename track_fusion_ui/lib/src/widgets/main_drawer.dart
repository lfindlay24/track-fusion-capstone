import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
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
            title: Text('Item 2'),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name != '/garages') {
                Navigator.pushNamed(context, '/garages');
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