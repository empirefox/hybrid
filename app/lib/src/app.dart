import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dataview/dataview.dart';
import 'package:bloc/bloc.dart';

import './const/routes.dart';
import './env.dart';
import './global.dart';
import './l10n/app.l10n.dart';
import './l10n/config.field.l10n.dart';

import './pages/configure/configure_page.dart';
import './pages/home_page.dart';

const kSupportedLanguages = ['en'];

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    initOnce();
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appName,
      localizationsDelegates: [
        const AppLocalizationsDelegate(kSupportedLanguages),
        const Field_configLocalizationsDelegate(kSupportedLanguages),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        title: 'Home',
      ),
      routes: {
        AppRoutes.configure: pageWrap((context) => ConfigurePage()),
        AppRoutes.dataview: (context) => DataviewPage(
              "/",
              uploadTo: "http://10.0.2.2:8082/upload",
            ),
      },
    );
  }

  WidgetBuilder pageWrap(WidgetBuilder builder) {
    return (context) => FutureBuilder(
          future: initOnce(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: const CircularProgressIndicator());
              case ConnectionState.none:
                return Text(
                    'Bug: initOnce()=null!\nIt should not happen here!');
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text(
                    'Bug: initOnce() failed!\n${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                return builder(context);
            }
          },
        );
  }

  // Init

  bool _inited = false;
  Future<void> _initing;

  Future<void> initOnce() {
    if (_inited) return Future.value();
    if (_initing != null) return _initing;
    return _initing = _initOnce();
  }

  Future<void> _initOnce() async {
    await AppGo.initOnce(
      channelId: appEnv.channelId,
      importance: appEnv.importance,
      notificationId: appEnv.notificationId,
      androidIcon: appEnv.androidIcon,
      onSelectNotification: onSelectNotification,
    );
    await AppHybrid.getConfig();
    _inited = true;
    _initing = null;
  }

  Future<Null> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.pushNamed(context, AppRoutes.home);
  }
}
