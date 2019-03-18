import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:path_provider/path_provider.dart';

import '../env.dart';
import '../protos.dart';

import './app_go.dart';

class AppHybrid {
  static final bool _isLoadConfig = false;
  static Config _lastSavedConfig;
  static Config get lastSavedConfig => _lastSavedConfig;
  static HybridClient _client;
  static ClientChannel _clientChannel;

  static Directory _appDocPath;
  static StartRequest _defaultStartRequest;
  static ConfigTree _configTree;

  static HybridClient get client {
    if (_client == null) {
      _clientChannel = AppGo.grpcDial(appEnv.hybridPort);
      _client = HybridClient(_clientChannel);
    }
    return _client;
  }

  static Future<StartRequest> get defaultStartRequest async {
    if (_defaultStartRequest != null) return _defaultStartRequest;
    final root = await appDocPath;
    if (_defaultStartRequest != null) return _defaultStartRequest;
    _defaultStartRequest = StartRequest()
      ..root = '${root.path}/${appEnv.hybridDirName}'
      ..freeze();
    return _defaultStartRequest;
  }

  static Future<Directory> get appDocPath async {
    if (_appDocPath != null) return _appDocPath;
    final directory = await getApplicationDocumentsDirectory();
    if (_appDocPath != null) return _appDocPath;
    return _appDocPath = directory.parent;
  }

  static void dispose() {
    _clientChannel.terminate();
  }

  // API
  static Future<Version> get version async =>
      await client.getVersion(Empty.getDefault());

  static Future<ConfigTree> get configTree async {
    if (_configTree != null) return _configTree;
    final tree = await client.getConfigTree(await defaultStartRequest);
    if (_configTree != null) return _configTree;
    return _configTree = tree;
  }

  static Future<Config> getConfig() async {
    if (_lastSavedConfig != null) return _lastSavedConfig;
    final tree = await configTree;
    if (_lastSavedConfig != null) return _lastSavedConfig;
    final request = GetConfigRequest()
      ..root = tree.rootPath
      ..load = _isLoadConfig;
    return _lastSavedConfig = await client.getConfig(request);
  }

  static Future<List<ValidatorV9Error>> saveConfig(Config config) async {
    final tree = await configTree;
    final request = SaveConfigRequest()
      ..root = tree.rootPath
      ..config = config;
    final reply = await client.saveConfig(request);
    final verrs = reply.errors ?? [];
    if (verrs.isEmpty) _lastSavedConfig = config.clone();
    return verrs;
  }

  static Future<void> start() async {
    await client.start(await defaultStartRequest);
  }

  static Future<void> stop() async {
    await client.stop(Empty.getDefault());
    await client.waitUntilStopped(Empty.getDefault());
  }

  static Future<void> bindConfigProxy() async {
    await client.bindConfigProxy(Empty.getDefault());
  }

  static Future<void> unBindConfigProxy() async {
    await client.unbindConfigProxy(Empty.getDefault());
  }
}
