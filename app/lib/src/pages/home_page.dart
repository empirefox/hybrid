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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[AppPopupMenuButton(choices: widget.choices)],
      ),
      body: FutureBuilder(
        future: AppHybrid.appDocPath,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: const CircularProgressIndicator());
            case ConnectionState.none:
              return Text('Bug: initOnce()=null!\nIt should not happen here!');
            case ConnectionState.done:
              if (snapshot.hasError)
                return Text(
                  'Bug: initOnce() failed!\n${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              return Text('appDoc: ${snapshot.data}');
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
