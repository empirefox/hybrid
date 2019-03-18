import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

import '../../l10n.dart';
import '../../protos.dart';
import '../../shared/presets.dart';
import '../../widgets/error_retry.dart';
import '../../widgets/on_stay_or_will_pop.dart';

class ConfigureListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConfigureListPageState();
}

class ConfigureListPageState extends State<ConfigureListPage> {
  final _lastSavedRoot = newConfigRoot();
  final _pbRoot = newConfigRoot();
  final _rootNode = configRootNode;

  List<GeneratedMessage> get pbList => _pbRoot.current;
  List<Key> _keys;

  bool _reorder = false;
  Future<List<ValidatorV9Error>> _saveConfig;

  ConfigureListPageState();

  Key _keyOf(int size, int i) {
    if (_keys == null) _keys = List<Key>.generate(size, (_) => UniqueKey());
    return _keys[i];
  }

  bool _noNeedAsk() => pbList == _lastSavedRoot.current;

  @override
  Widget build(BuildContext context) {
    _lastSavedRoot.initContext(context);
    _pbRoot.initContext(context);
    assert(_pbRoot.tags.length == 1);
    final l10n = AppLocalizations.of(context);
    final _l10n = Field_configLocalizations.of(context);
    final length = pbList.length;
    final list = List<Widget>(length);
    final node = _rootNode.findFromTags(_pbRoot.tags);
    for (var i = 0; i < length; i++) {
      list[i] = ListTile(
        key: _keyOf(length, i),
        // leading: Icon(Icons.map),
        title: Text(pbList[i].getField(node.nameField)),
        // subtitle: Text('data'),
        onTap: () => _pbRoot.goto(i),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_l10n.$messageOf(node.pbtype) + _pbRoot.routeSuffixForDev),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WillPopScope(
        onWillPop: () => onStayOrWillPop(
            context: context,
            noNeedAsk: _noNeedAsk,
            onGoBack: () => Navigator.of(context).pop()),
        child: Container(
          margin: const EdgeInsets.all(15.0),
          child: _reorder
              ? Column(
                  children: <Widget>[
                    ReorderableListView(
                      children: list,
                      onReorder: _handleReorder,
                    ),
                    ButtonBar(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.replay),
                          onPressed: () => setState(_pbRoot.reset),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            if (_noNeedAsk())
                              _doResetAndToReorded();
                            else
                              onStayOrWillPop(
                                context: context,
                                noNeedAsk: () => false,
                                onGoBack: _doResetAndToReorded,
                              );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.done),
                          onPressed: _doSaveConfig,
                        ),
                      ],
                    ),
                  ],
                )
              : FutureBuilder(
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
                        return Column(
                          children: <Widget>[
                            ListView(
                              children: list,
                            ),
                            ButtonBar(
                              children: <Widget>[
                                RaisedButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: Text(l10n.addNewOne),
                                  onPressed: () => _pbRoot.goto(-1),
                                ),
                                RaisedButton.icon(
                                  icon: const Icon(Icons.edit),
                                  label: Text(l10n.reorder),
                                  onPressed: () =>
                                      setState(() => _reorder = true),
                                ),
                              ],
                            ),
                          ],
                        );
                    }
                  },
                ),
        ),
      ),
    );
  }

  void _doResetAndToReorded() => setState(() {
        _pbRoot.reset();
        _reorder = false;
      });

  void _doSaveConfig() => setState(() {
        _saveConfig = _pbRoot.save().then((verrs) {
          if (verrs.isEmpty) {
            _lastSavedRoot.reset();
          }
          return verrs;
        });
        _reorder = false;
      });

  void _handleReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }
    final element = pbList.removeAt(oldIndex);
    pbList.insert(newIndex, element);
  }
}
