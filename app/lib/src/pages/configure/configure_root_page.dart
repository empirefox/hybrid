import 'package:flutter/material.dart';

import '../../l10n.dart';
import '../../shared/presets.dart';

class ConfigureRootPage extends StatelessWidget {
  final _pbRoot = newConfigRoot();
  final _rootNode = configRootNode;

  final VoidCallback onRootBack;

  ConfigureRootPage({Key key, @required this.onRootBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _pbRoot.initContext(context);
    final _l10n = Field_configLocalizations.of(context);
    final list = _rootNode.children.map<Widget>((node) {
      return ListTile(
        // leading: Icon(Icons.map),
        title: Text(_l10n.$tagOf(_rootNode.pbtype, '${node.tag}')),
        // subtitle: Text('data'),
        onTap: () => _pbRoot.goto(node.tag),
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _l10n.$messageOf(_rootNode.pbtype) + _pbRoot.routeSuffixForDev),
        leading: ModalRoute.of(context).canPop
            ? const BackButton()
            : IconButton(icon: const BackButtonIcon(), onPressed: onRootBack),
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
