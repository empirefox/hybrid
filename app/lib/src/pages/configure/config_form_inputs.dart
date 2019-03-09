import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../l10n/app.l10n.dart';
import '../../protos.dart';

abstract class ConfigFormInputs<T extends GeneratedMessage> {
  int get tagNumber;
  String title(BuildContext context);
  List<FormBuilderInput> buildControls(BuildContext context, T config);

  Map<String, dynamic> lastChanged = {};

  static final Map<Type, dynamic> _typeToInstances = <Type, dynamic>{
    Basic: BasicConfigFormInputs(),
  };
  static ConfigFormInputs<T> of<T extends GeneratedMessage>() =>
      _typeToInstances[T];
}

class BasicConfigFormInputs extends ConfigFormInputs<Basic> {
  static final RegExp ipv4RegExp = RegExp(
      r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");

  @override
  int get tagNumber => int.parse(ConfigFields.basic);

  @override
  String title(BuildContext context) =>
      AppLocalizations.of(context).configureBasicTitle;

  @override
  List<FormBuilderInput> buildControls(BuildContext context, Basic config) {
    final l10n = AppLocalizations.of(context);
    return <FormBuilderInput>[
      // dev
      FormBuilderInput.switchInput(
        attribute: BasicFields.dev,
        label: l10n.devModeLabel,
        value: config.dev,
      ),
      // bind
      FormBuilderInput.textField(
        attribute: BasicFields.bind,
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
        attribute: BasicFields.flush_interval_ms,
        label: l10n.configureBasicFlushIntervalLabel,
        value: config.flushIntervalMs,
        min: 0,
        max: 1 << 32 - 1,
      ),
      // token
      FormBuilderInput.textField(
        attribute: BasicFields.token,
        type: FormBuilderInput.TYPE_TEXT,
        label: l10n.configureBasicTokenLabel,
        value: config.token,
      ),
    ];
  }
}

class LogConfigFormInputs extends ConfigFormInputs<Log> {
  @override
  int get tagNumber => int.parse(ConfigFields.log);

  @override
  String title(BuildContext context) =>
      AppLocalizations.of(context).configureLogTitle;

  @override
  List<FormBuilderInput> buildControls(BuildContext context, Log config) {
    final l10n = AppLocalizations.of(context);
    return <FormBuilderInput>[
      // dev
      FormBuilderInput.switchInput(
        attribute: LogFields.dev,
        label: l10n.devModeLabel,
        value: config.dev,
      ),
      // level
      FormBuilderInput.dropdown(
        attribute: LogFields.level,
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
        attribute: LogFields.target,
        type: FormBuilderInput.TYPE_TEXT,
        label: l10n.configureLogTargetLabel,
        hint: l10n.configureLogTargetHint,
        value: config.target,
      ),
    ];
  }
}
