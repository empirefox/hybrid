import 'dart:async';
import 'package:flutter/material.dart';

import '../l10n.dart';

typedef NoNeedAskCallback = bool Function();

Future<bool> onStayOrWillPop(
    {@required BuildContext context,
    @required NoNeedAskCallback noNeedAsk,
    @required VoidCallback onGoBack}) {
  print('onWillPop called');
  if (noNeedAsk()) {
    return Future.value(true);
  }

  final l10n = AppLocalizations.of(context);
  showDialog<void>(
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
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onGoBack();
            },
          ),
        ],
      );
    },
  );
  return Future.value(false);
}
