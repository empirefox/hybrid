import 'dart:io';

import 'package:flutter/material.dart';

import '../global.dart';
import '../widgets/choice.dart';
import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.choices}) : super(key: key);

  final String title;
  final List<Choice> choices;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _stat() async {
    final root = await AppHybrid.appDocPath;
    final target = '${root.path}/.hybrid';
    final stat = await FileStat.stat(target);
    return '${target}\n  ${stat.modeString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[AppPopupMenuButton(choices: widget.choices)],
      ),
      body: FutureBuilder(
        future: _stat(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: const CircularProgressIndicator());
            case ConnectionState.none:
              return Text('Bug!\nIt should not happen here!');
            case ConnectionState.done:
              if (snapshot.hasError)
                return Text(
                  'Bug: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              return Text('stat: ${snapshot.data}');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Usage',
        child: Icon(Icons.wifi_tethering),
      ),
    );
  }
}
