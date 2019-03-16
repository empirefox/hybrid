import 'package:flutter/material.dart';

import '../../l10n.dart';
import '../../shared/presets.dart';

class ConfigureRootPage extends StatelessWidget {
  final _pbRoot = newConfigRoot();
  final _rootNode = configRootNode;

  @override
  Widget build(BuildContext context) {
    _pbRoot.initContext(context);
    final _l10n = Field_configLocalizations.of(context);
    final list = _rootNode.children.map<Widget>((node) {
      return ListTile(
        // leading: Icon(Icons.map),
        title: Text(_l10n.$tagOf(node.pbtype, '${node.tag}')),
        // subtitle: Text('data'),
        onTap: () => _pbRoot.goto(node.tag),
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(_l10n.$messageOf(_rootNode.pbtype)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: ListView(
          children: list,
        ),
      ),
    );
  }
}
