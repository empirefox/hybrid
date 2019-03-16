import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../l10n.dart';

class AboutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: const CircularProgressIndicator());
          case ConnectionState.none:
            return Text('Bug in AboutTile!');
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text('AboutTile Error: ${snapshot.error}');
        }
        return AboutListTile(
          applicationIcon: FlutterLogo(
            colors: Colors.yellow,
          ),
          icon: FlutterLogo(
            colors: Colors.yellow,
          ),
          aboutBoxChildren: <Widget>[
            SizedBox(height: 10.0),
            Text(l10n.appDesc),
          ],
          applicationName: l10n.appName,
          applicationVersion:
              '${snapshot.data.version}+${snapshot.data.buildNumber}',
        );
      },
    );
  }
}
