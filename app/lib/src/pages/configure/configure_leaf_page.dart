import 'dart:async';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../l10n.dart';
import '../../protos.dart';
import '../../shared/presets.dart';
import '../../widgets/error_retry.dart';
import '../../widgets/on_stay_or_will_pop.dart';

class ConfigureLeafPage<T extends GeneratedMessage> extends StatefulWidget {
  final ConfigFormInputs<T> inputs;

  ConfigureLeafPage({Key key, @required this.inputs}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConfigureLeafPageState<T>();
}

class ConfigureLeafPageState<T extends GeneratedMessage>
    extends State<ConfigureLeafPage<T>> with ConfigureLeafPageStateMixin<T> {
  ConfigFormInputs<T> get inputs => widget.inputs;
}

mixin ConfigureLeafPageStateMixin<T extends GeneratedMessage>
    on State<ConfigureLeafPage<T>> {
  ConfigFormInputs<T> get inputs;

  final _lastSavedRoot = newConfigRoot();
  final _pbRoot = newConfigRoot();

  Future<List<ValidatorV9Error>> _saveConfig;

  Map<String, dynamic> _lastChanged;
  bool _needNotSave() =>
      _lastChanged == null ||
      _pbRoot.newFrom(_lastChanged) == _lastSavedRoot.current;

  void _doSaveConfig() {
    setState(() => _saveConfig = _pbRoot.save().then((verrs) {
          if (verrs.isEmpty) {
            _lastSavedRoot.reset();
          }
          return verrs;
        }));
  }

  @override
  Widget build(BuildContext context) {
    _lastSavedRoot.initContext(context);
    _pbRoot.initContext(context);
    return WillPopScope(
      onWillPop: () => onStayOrWillPop(
            context: context,
            noNeedAsk: _needNotSave,
            onGoBack: () => Navigator.of(context).pop(),
          ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(inputs.title(context)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(15.0),
          child: FutureBuilder(
            future: _saveConfig,
            builder: (BuildContext context,
                AsyncSnapshot<List<ValidatorV9Error>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.none:
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return ErrorRetry(
                      err: snapshot.error,
                      onRetry: _doSaveConfig,
                    );
                  return Row(
                    children: <Widget>[
                      FormBuilder(
                        context,
                        autovalidate: true,
                        // readonly: true,
                        showResetButton: true,
                        // resetButtonContent: Text("Clear Form"),
                        onChanged: (formValue) => _lastChanged = formValue,
                        onSubmit: (formValue) {
                          if (formValue == null)
                            return debugPrint("Form invalid");
                          if (_needNotSave()) return;
                          _pbRoot.current = _pbRoot.newFrom(formValue);
                          _doSaveConfig();
                        },
                        controls:
                            inputs.buildControls(context, _pbRoot.current),
                      ),
                      _ValidatorErrors(verrs: snapshot.data),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _ValidatorErrors extends StatelessWidget {
  final List<ValidatorV9Error> verrs;

  const _ValidatorErrors({Key key, @required this.verrs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = verrs.map((err) => toListTile(context, err)).toList();
    return ListView(children: list);
  }

  Widget toListTile(BuildContext context, ValidatorV9Error err) {
    return ListTile(
      leading: Text(err.field_5),
      title: Text(err.tag),
    );
  }
}

abstract class ConfigFormInputs<T extends GeneratedMessage> {
  String title(BuildContext context);
  List<FormBuilderInput> buildControls(BuildContext context, T config);

  static final Map<Type, dynamic> _typeToInstances = <Type, dynamic>{
    Basic: BasicConfigFormInputs(),
    Log: LogConfigFormInputs(),
  };
  static ConfigFormInputs<T> of<T extends GeneratedMessage>(Type type) =>
      _typeToInstances[type];
}

class BasicConfigFormInputs extends ConfigFormInputs<Basic> {
  static final RegExp ipv4RegExp = RegExp(
      r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");

  @override
  String title(BuildContext context) =>
      Field_configLocalizations.of(context).basic_Config;

  @override
  List<FormBuilderInput> buildControls(BuildContext context, Basic config) {
    final l10n = AppLocalizations.of(context);
    final _l10n = Field_configLocalizations.of(context);
    return <FormBuilderInput>[
      // dev
      FormBuilderInput.switchInput(
        attribute: BasicFields.dev,
        label: _l10n.dev_Basic,
        value: config.dev,
      ),
      // bind
      FormBuilderInput.textField(
        attribute: BasicFields.bind,
        type: FormBuilderInput.TYPE_TEXT,
        label: _l10n.bind_Basic,
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
        attribute: BasicFields.flushIntervalMs,
        label: _l10n.flushIntervalMs_Basic,
        value: config.flushIntervalMs,
        min: 0,
        max: 1 << 32 - 1,
      ),
      // token
      FormBuilderInput.textField(
        attribute: BasicFields.token,
        type: FormBuilderInput.TYPE_TEXT,
        label: _l10n.token_Basic,
        value: config.token,
      ),
    ];
  }
}

class LogConfigFormInputs extends ConfigFormInputs<Log> {
  @override
  String title(BuildContext context) =>
      Field_configLocalizations.of(context).log_Config;

  @override
  List<FormBuilderInput> buildControls(BuildContext context, Log config) {
    final l10n = AppLocalizations.of(context);
    final _l10n = Field_configLocalizations.of(context);
    return <FormBuilderInput>[
      // dev
      FormBuilderInput.switchInput(
        attribute: LogFields.dev,
        label: _l10n.dev_Log,
        value: config.dev,
      ),
      // level
      FormBuilderInput.dropdown(
        attribute: LogFields.level,
        require: true,
        label: _l10n.level_Log,
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
        label: _l10n.target_Log,
        hint: l10n.configureLogTargetHint,
        value: config.target,
      ),
    ];
  }
}
