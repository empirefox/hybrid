import 'package:flutter/material.dart';

import '../const/routes.dart';
import '../l10n.dart';

import './about_tile.dart';

class AppDrawer extends StatelessWidget {
  @override
  Drawer build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final _l10n = Field_configLocalizations.of(context);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    l10n.appName,
                    textScaleFactor: 2.0,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(l10n.appDesc)
              ],
            ),
          ),
          ListTile(
            title: Text(l10n.home),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.home);
            },
          ),
          ListTile(
            title: Text(_l10n.Config),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.configure,
                  ModalRoute.withName(AppRoutes.home));
            },
          ),
          ListTile(
            title: Text(l10n.dataview),
            leading: Icon(Icons.folder),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dataview,
                  ModalRoute.withName(AppRoutes.home));
            },
          ),
          Divider(),
          AboutTile(),
        ],
      ),
    );
  }
}
