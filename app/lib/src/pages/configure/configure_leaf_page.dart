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
      _pbRoot.newFrom(_lastChanged) ==
          inputs.cloneWithDefault(_lastSavedRoot.current);

  void _doSaveConfig(BuildContext context) {
    setState(() {
      _saveConfig = _pbRoot.save().then((verrs) {
        if (verrs.isEmpty) {
          _lastChanged = null;
          Navigator.of(context).pop();
        }
        return verrs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _lastSavedRoot.initContext(context);
    _pbRoot.initContext(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(inputs.title(context) + _pbRoot.routeSuffixForDev),
        leading: BackButton(),
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
                    onRetry: () => _doSaveConfig(context),
                  );
                return Column(
                  children: <Widget>[
                    FormBuilder(
                      context,
                      autovalidate: true,
                      // readonly: true,
                      showResetButton: true,
                      // resetButtonContent: Text("Clear Form"),
                      onChanged: (formValue) => _lastChanged = formValue,
                      onWillPop: () => onStayOrWillPop(
                            context: context,
                            noNeedAsk: _needNotSave,
                            onGoBack: () => Navigator.of(context).pop(),
                          ),
                      onSubmit: (formValue) {
                        if (formValue == null)
                          return debugPrint("Form invalid");
                        if (_needNotSave()) return;
                        _pbRoot.current = _pbRoot.newFrom(formValue);
                        _doSaveConfig(context);
                      },
                      controls: inputs.buildControls(context, _pbRoot.current),
                    ),
                    _ValidatorErrors(verrs: snapshot.data),
                  ],
                );
            }
          },
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
    if (verrs == null || verrs.isEmpty) return Container();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: verrs.length,
      itemBuilder: _toListTile,
    );
  }

  Widget _toListTile(BuildContext context, int i) {
    return ListTile(
      leading: Text(verrs[i].field_5),
      title: Text(verrs[i].tag),
    );
  }
}

abstract class ConfigFormInputs<T extends GeneratedMessage> {
  String title(BuildContext context);
  List<FormBuilderInput> buildControls(BuildContext context, T config);

  T cloneWithDefault(T input) {
    input = input.clone();
    final Map<int, bool> oneofs = <int, bool>{};
    input.info_.oneofs.forEach((tag, oneof) {
      oneofs[tag] = input.$_whichOneof(oneof) == tag;
    });
    input.info_.byIndex.forEach((fi) {
      final selected = oneofs[fi.tagNumber];
      if (selected == null || selected)
        input.setField(fi.tagNumber, input.getField(fi.tagNumber));
    });
    return input;
  }

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
  Basic cloneWithDefault(Basic input) {
    return super.cloneWithDefault(input)..clearVersion();
  }

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
