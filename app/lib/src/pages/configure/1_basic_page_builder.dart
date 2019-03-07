import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../l10n/app.l10n.dart';
import '../../protos.dart';

class ConfigBasicPageBuilder extends StatelessWidget {
  static final RegExp ipv4RegExp = RegExp(
      r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");

  final Config config;

  const ConfigBasicPageBuilder({Key key, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FormBuilder(
      context,
      autovalidate: true,
      // readonly: true,
      showResetButton: true,
      // resetButtonContent: Text("Clear Form"),
      onChanged: (formValue) {
        print(formValue);
      },
      onSubmit: (formValue) {
        if (formValue != null) {
          config
            ..dev = formValue[l10n.devModeLabel]
            ..bind = formValue[l10n.configureBasicBindLabel]
            ..flushIntervalMs = formValue[l10n.configureBasicFlushIntervalLabel]
            ..token = formValue[l10n.configureBasicTokenLabel];
          print(config);
        } else {
          print("Form invalid");
        }
      },
      controls: <FormBuilderInput>[
        // dev
        FormBuilderInput.switchInput(
          attribute: l10n.devModeLabel,
          label: l10n.devModeLabel,
          value: config.dev,
        ),
        // bind
        FormBuilderInput.textField(
          attribute: l10n.configureBasicBindLabel,
          type: FormBuilderInput.TYPE_TEXT,
          label: l10n.configureBasicBindLabel,
          hint: l10n.configureBasicBindHint,
          value: config.bind,
          validator: (value) {
            if (value == null || value.isEmpty || ipv4RegExp.hasMatch(value))
              return null;
            return l10n.configureBasicBindBadTcpAddr;
          },
        ),
        // flushIntervalMs
        FormBuilderInput.number(
          attribute: l10n.configureBasicFlushIntervalLabel,
          label: l10n.configureBasicFlushIntervalLabel,
          value: config.flushIntervalMs,
          min: 0,
          max: 1 << 32 - 1,
        ),
        // token
        FormBuilderInput.textField(
          attribute: l10n.configureBasicTokenLabel,
          type: FormBuilderInput.TYPE_TEXT,
          label: l10n.configureBasicTokenLabel,
          value: config.token,
        ),
      ],
    );
  }
}
