import '../global.dart';
import '../protos.dart';

import './nav_node.dart';
import './pb_root.dart';

var configRootNode = NavNode.root(defaultInstance: Config.getDefault());

class _ConfigRootHandler extends PbRootHandler<Config, List<ValidatorV9Error>> {
  @override
  Future<List<ValidatorV9Error>> save(Config root) =>
      AppHybrid.saveConfig(root);

  @override
  Config saved() => AppHybrid.lastSavedConfig.clone();
}

_ConfigRootHandler _pbConfigRootHandler = _ConfigRootHandler();
PbRoot<Config, List<ValidatorV9Error>> newConfigRoot() =>
    PbRoot<Config, List<ValidatorV9Error>>(_pbConfigRootHandler);
