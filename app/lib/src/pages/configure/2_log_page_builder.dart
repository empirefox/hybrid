import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../l10n/app.l10n.dart';
import '../../protos.dart';

class ConfigLogPageBuilder extends StatelessWidget {
  final Log configLog;

  const ConfigLogPageBuilder({Key key, this.configLog}) : super(key: key);

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
          configLog
            ..dev = formValue[l10n.devModeLabel]
            ..level = formValue[l10n.configureLogLevelLabel]
            ..target = formValue[l10n.configureLogTargetLabel];
          print(configLog);
        } else {
          print("Form invalid");
        }
      },
      controls: <FormBuilderInput>[
        // dev
        FormBuilderInput.switchInput(
          attribute: l10n.devModeLabel,
          label: l10n.devModeLabel,
          value: configLog.dev,
        ),
        // level
        FormBuilderInput.dropdown(
          attribute: l10n.configureLogLevelLabel,
          require: true,
          label: l10n.configureLogLevelLabel,
          options: [
            FormBuilderInputOption(value: "debug"),
            FormBuilderInputOption(value: "info"),
            FormBuilderInputOption(value: "warn"),
            FormBuilderInputOption(value: "error"),
            FormBuilderInputOption(value: "dpanic"),
            FormBuilderInputOption(value: "panic"),
            FormBuilderInputOption(value: "fatal"),
          ],
        ),
        // target
        FormBuilderInput.textField(
          attribute: l10n.configureLogTargetLabel,
          type: FormBuilderInput.TYPE_TEXT,
          label: l10n.configureLogTargetLabel,
          hint: l10n.configureLogTargetHint,
          value: configLog.target,
        ),
      ],
    );
  }
}
