import 'dart:async';
import 'package:flutter/material.dart';

import '../../l10n/app.l10n.dart';

class ConfigureLeafPage extends StatelessWidget {
  final Widget title;
  final Widget formBuilder;

  const ConfigureLeafPage({
    Key key,
    @required this.title,
    @required this.formBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: formBuilder,
      ),
    );
  }

  AppBar appBar(BuildContext context) => AppBar(
        title: title,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.check),
        //     onPressed: _savePressed,
        //   ),
        // ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _backPressed(context),
        ),
      );

  Future<void> _backPressed(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.configureBackAlertTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(l10n.configureBackAlertContent),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(l10n.configureBackAlertStay),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            FlatButton(
              child: Text(l10n.configureBackAlertGoBack),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
