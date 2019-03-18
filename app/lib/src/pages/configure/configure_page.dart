import 'package:flutter/material.dart';
import 'package:path/path.dart' show posix;

import '../../const/routes.dart';
import '../../shared/nav_node.dart';
import '../../shared/presets.dart';

import './configure_leaf_page.dart';
import './configure_list_page.dart';
import './configure_root_page.dart';

class ConfigurePage extends StatelessWidget {
  final _initialRoute = AppRoutes.configure.substring(1);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: _initialRoute,
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        if (settings.name == _initialRoute) {
          builder = (_) => ConfigureRootPage(
                onRootBack: () => Navigator.of(context).pop(),
              );
        } else {
          final tags = posix
              .split(posix.relative(settings.name, from: _initialRoute))
              .map((s) => int.parse(s))
              .toList();
          final node = configRootNode.findFromTags(tags);
          if (node.nodeType == NodeType.list && !node.isInList(tags))
            builder = (_) => ConfigureListPage();
          else {
            final inputs = ConfigFormInputs.of(node.pbtype);
            if (inputs == null)
              throw Exception(
                  'Invalid route: ${settings.name}, inputs of pbtype not found ${node.pbtype}');
            builder = (_) => ConfigureLeafPage(inputs: inputs);
          }
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
