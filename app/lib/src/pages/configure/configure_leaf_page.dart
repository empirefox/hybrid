import 'dart:async';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../global.dart';
import '../../l10n/app.l10n.dart';

import './config_form_inputs.dart';

class ConfigureLeafPage<T extends GeneratedMessage> extends StatelessWidget
    with ConfigureLeafPageMixin<T> {
  final ConfigFormInputs<T> inputs;
  ConfigureLeafPage({Key key, @required this.inputs}) : super(key: key);
}

mixin ConfigureLeafPageMixin<T extends GeneratedMessage> {
  ConfigFormInputs<T> get inputs;

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: appBar(context),
        body: Container(
          margin: EdgeInsets.all(15.0),
          child: FormBuilder(
            context,
            autovalidate: true,
            // readonly: true,
            showResetButton: true,
            // resetButtonContent: Text("Clear Form"),
            onChanged: (formValue) => inputs.lastChanged = formValue,
            onSubmit: (formValue) {
              // TODO think deeply?
              if (formValue != null) {
                final config = toConfig(formValue);
                setConfig(config);
                print(config);
                Navigator.of(context).pop();
              } else {
                print("Form invalid");
              }
            },
            controls: inputs.buildControls(context, getConfig()),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) => AppBar(
        title: Text(inputs.title(context)),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.check),
        //     onPressed: _savePressed,
        //   ),
        // ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      );

  Future<bool> _onWillPop(BuildContext context) {
    print('onWillPop called');
    if (toConfig(inputs.lastChanged) == getConfig()) {
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
    return Future.value(false);
  }

  T getConfig() => AppHybrid.unsavedConfig.getField(inputs.tagNumber);
  void setConfig(T c) => AppHybrid.unsavedConfig.setField(inputs.tagNumber, c);

  T createEmptyConfigInstance() => getConfig().createEmptyInstance();

  T toConfig(Map<String, dynamic> formValue) =>
      createEmptyConfigInstance()..mergeFromJsonMap(formValue);
}
