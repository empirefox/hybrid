// DO NOT EDIT. This is code generated via protoc-gen-dart-ext.
// Supported parameters: dart_ext=defaults+field_names+field_l10n.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './config.pb.dart' as pb;

// This file was generated in two steps, using the Dart intl tools. With the
// app's root directory (the one that contains pubspec.yaml) as the current
// directory:
//
// flutter pub get
// flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/src/l10n lib/src/l10n/config.field.l10n.dart
// flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/src/l10n --no-use-deferred-loading lib/src/l10n/config.field.l10n.dart lib/src/l10n/intl_*.arb
//
// The second command generates intl_messages.arb and the third generates
// messages_all.dart. There's more about this process in
// https://pub.dartlang.org/packages/intl.
import './messages_all.dart';

class Field_configLocalizations {
  static Future<Field_configLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return Field_configLocalizations();
    });
  }

  static Field_configLocalizations of(BuildContext context) {
    return Localizations.of<Field_configLocalizations>(
        context, Field_configLocalizations);
  }

  // ConfigTree
  String get ConfigTree => Intl.message('ConfigTree', name: 'ConfigTree');
  String get version_ConfigTree =>
      Intl.message('version', name: 'version_ConfigTree');
  String get rootName_ConfigTree =>
      Intl.message('rootName', name: 'rootName_ConfigTree');
  String get rootPath_ConfigTree =>
      Intl.message('rootPath', name: 'rootPath_ConfigTree');
  String get configName_ConfigTree =>
      Intl.message('configName', name: 'configName_ConfigTree');
  String get configPath_ConfigTree =>
      Intl.message('configPath', name: 'configPath_ConfigTree');
  String get ipfsName_ConfigTree =>
      Intl.message('ipfsName', name: 'ipfsName_ConfigTree');
  String get ipfsPath_ConfigTree =>
      Intl.message('ipfsPath', name: 'ipfsPath_ConfigTree');
  String get storeName_ConfigTree =>
      Intl.message('storeName', name: 'storeName_ConfigTree');
  String get storePath_ConfigTree =>
      Intl.message('storePath', name: 'storePath_ConfigTree');
  String get filesRootName_ConfigTree =>
      Intl.message('filesRootName', name: 'filesRootName_ConfigTree');
  String get filesRootPath_ConfigTree =>
      Intl.message('filesRootPath', name: 'filesRootPath_ConfigTree');
  String get rulesRootName_ConfigTree =>
      Intl.message('rulesRootName', name: 'rulesRootName_ConfigTree');
  String get rulesRootPath_ConfigTree =>
      Intl.message('rulesRootPath', name: 'rulesRootPath_ConfigTree');

  // Basic
  String get Basic => Intl.message('Basic', name: 'Basic');
  String get version_Basic => Intl.message('version', name: 'version_Basic');
  String get dev_Basic => Intl.message('dev', name: 'dev_Basic');
  String get bind_Basic => Intl.message('bind', name: 'bind_Basic');
  String get flushIntervalMs_Basic =>
      Intl.message('flushIntervalMs', name: 'flushIntervalMs_Basic');
  String get token_Basic => Intl.message('token', name: 'token_Basic');

  // Log
  String get Log => Intl.message('Log', name: 'Log');
  String get dev_Log => Intl.message('dev', name: 'dev_Log');
  String get level_Log => Intl.message('level', name: 'level_Log');
  String get target_Log => Intl.message('target', name: 'target_Log');

  // Ipfs
  String get Ipfs => Intl.message('Ipfs', name: 'Ipfs');
  String get fakeApiListenAddr_Ipfs =>
      Intl.message('fakeApiListenAddr', name: 'fakeApiListenAddr_Ipfs');
  String get gatewayServerName_Ipfs =>
      Intl.message('gatewayServerName', name: 'gatewayServerName_Ipfs');
  String get apiServerName_Ipfs =>
      Intl.message('apiServerName', name: 'apiServerName_Ipfs');
  String get profile_Ipfs => Intl.message('profile', name: 'profile_Ipfs');
  String get autoMigrate_Ipfs =>
      Intl.message('autoMigrate', name: 'autoMigrate_Ipfs');
  String get enableIpnsPubSub_Ipfs =>
      Intl.message('enableIpnsPubSub', name: 'enableIpnsPubSub_Ipfs');
  String get enablePubSub_Ipfs =>
      Intl.message('enablePubSub', name: 'enablePubSub_Ipfs');
  String get enableMultiplex_Ipfs =>
      Intl.message('enableMultiplex', name: 'enableMultiplex_Ipfs');
  String get token_Ipfs => Intl.message('token', name: 'token_Ipfs');

  // IpfsServer
  String get IpfsServer => Intl.message('IpfsServer', name: 'IpfsServer');
  String get name_IpfsServer => Intl.message('name', name: 'name_IpfsServer');
  String get peer_IpfsServer => Intl.message('peer', name: 'peer_IpfsServer');
  String get token_IpfsServer =>
      Intl.message('token', name: 'token_IpfsServer');

  // FileServer
  String get FileServer => Intl.message('FileServer', name: 'FileServer');
  String get name_FileServer => Intl.message('name', name: 'name_FileServer');
  String get zip_FileServer => Intl.message('zip', name: 'zip_FileServer');
  String get redirect_FileServer =>
      Intl.message('redirect', name: 'redirect_FileServer');
  String get dev_FileServer => Intl.message('dev', name: 'dev_FileServer');

  // HttpProxyServer
  String get HttpProxyServer =>
      Intl.message('HttpProxyServer', name: 'HttpProxyServer');
  String get name_HttpProxyServer =>
      Intl.message('name', name: 'name_HttpProxyServer');
  String get host_HttpProxyServer =>
      Intl.message('host', name: 'host_HttpProxyServer');
  String get keepAlive_HttpProxyServer =>
      Intl.message('keepAlive', name: 'keepAlive_HttpProxyServer');

  // AdpRouter
  String get AdpRouter => Intl.message('AdpRouter', name: 'AdpRouter');
  String get rulesDirName_AdpRouter =>
      Intl.message('rulesDirName', name: 'rulesDirName_AdpRouter');
  String get blocked_AdpRouter =>
      Intl.message('blocked', name: 'blocked_AdpRouter');
  String get unblocked_AdpRouter =>
      Intl.message('unblocked', name: 'unblocked_AdpRouter');
  String get etcHostsIpAsBlocked_AdpRouter =>
      Intl.message('etcHostsIpAsBlocked',
          name: 'etcHostsIpAsBlocked_AdpRouter');
  String get dev_AdpRouter => Intl.message('dev', name: 'dev_AdpRouter');

  // IPNetRouter
  String get IPNetRouter => Intl.message('IPNetRouter', name: 'IPNetRouter');
  String get ip_IPNetRouter => Intl.message('ip', name: 'ip_IPNetRouter');
  String get net_IPNetRouter => Intl.message('net', name: 'net_IPNetRouter');
  String get matched_IPNetRouter =>
      Intl.message('matched', name: 'matched_IPNetRouter');
  String get unmatched_IPNetRouter =>
      Intl.message('unmatched', name: 'unmatched_IPNetRouter');
  String get fileTest_IPNetRouter =>
      Intl.message('fileTest', name: 'fileTest_IPNetRouter');

  // RouterItem
  String get RouterItem => Intl.message('RouterItem', name: 'RouterItem');
  String get name_RouterItem => Intl.message('name', name: 'name_RouterItem');
  String get adp_RouterItem => Intl.message('adp', name: 'adp_RouterItem');
  String get ipnet_RouterItem =>
      Intl.message('ipnet', name: 'ipnet_RouterItem');

  // Config
  String get Config => Intl.message('Config', name: 'Config');
  String get basic_Config => Intl.message('basic', name: 'basic_Config');
  String get log_Config => Intl.message('log', name: 'log_Config');
  String get ipfs_Config => Intl.message('ipfs', name: 'ipfs_Config');
  String get ipfsServers_Config =>
      Intl.message('ipfsServers', name: 'ipfsServers_Config');
  String get fileServers_Config =>
      Intl.message('fileServers', name: 'fileServers_Config');
  String get httpProxyServers_Config =>
      Intl.message('httpProxyServers', name: 'httpProxyServers_Config');
  String get routers_Config => Intl.message('routers', name: 'routers_Config');

  String $messageOf(Type type) {
    switch (type) {
      case pb.ConfigTree:
        return ConfigTree;
      case pb.Basic:
        return Basic;
      case pb.Log:
        return Log;
      case pb.Ipfs:
        return Ipfs;
      case pb.IpfsServer:
        return IpfsServer;
      case pb.FileServer:
        return FileServer;
      case pb.HttpProxyServer:
        return HttpProxyServer;
      case pb.AdpRouter:
        return AdpRouter;
      case pb.IPNetRouter:
        return IPNetRouter;
      case pb.RouterItem:
        return RouterItem;
      case pb.Config:
        return Config;
      default:
        // type not found
        return '@${type}';
    }
  }

  String $tagOf(Type type, String tag) {
    switch (type) {
      case pb.ConfigTree:
        switch (tag) {
          case '1':
            return version_ConfigTree;
          case '2':
            return rootName_ConfigTree;
          case '3':
            return rootPath_ConfigTree;
          case '4':
            return configName_ConfigTree;
          case '5':
            return configPath_ConfigTree;
          case '6':
            return ipfsName_ConfigTree;
          case '7':
            return ipfsPath_ConfigTree;
          case '8':
            return storeName_ConfigTree;
          case '9':
            return storePath_ConfigTree;
          case '10':
            return filesRootName_ConfigTree;
          case '11':
            return filesRootPath_ConfigTree;
          case '12':
            return rulesRootName_ConfigTree;
          case '13':
            return rulesRootPath_ConfigTree;
        }
        break;

      case pb.Basic:
        switch (tag) {
          case '1':
            return version_Basic;
          case '2':
            return dev_Basic;
          case '3':
            return bind_Basic;
          case '4':
            return flushIntervalMs_Basic;
          case '5':
            return token_Basic;
        }
        break;

      case pb.Log:
        switch (tag) {
          case '1':
            return dev_Log;
          case '2':
            return level_Log;
          case '3':
            return target_Log;
        }
        break;

      case pb.Ipfs:
        switch (tag) {
          case '1':
            return fakeApiListenAddr_Ipfs;
          case '2':
            return gatewayServerName_Ipfs;
          case '3':
            return apiServerName_Ipfs;
          case '4':
            return profile_Ipfs;
          case '5':
            return autoMigrate_Ipfs;
          case '6':
            return enableIpnsPubSub_Ipfs;
          case '7':
            return enablePubSub_Ipfs;
          case '8':
            return enableMultiplex_Ipfs;
          case '9':
            return token_Ipfs;
        }
        break;

      case pb.IpfsServer:
        switch (tag) {
          case '1':
            return name_IpfsServer;
          case '2':
            return peer_IpfsServer;
          case '3':
            return token_IpfsServer;
        }
        break;

      case pb.FileServer:
        switch (tag) {
          case '1':
            return name_FileServer;
          case '2':
            return zip_FileServer;
          case '3':
            return redirect_FileServer;
          case '4':
            return dev_FileServer;
        }
        break;

      case pb.HttpProxyServer:
        switch (tag) {
          case '1':
            return name_HttpProxyServer;
          case '2':
            return host_HttpProxyServer;
          case '3':
            return keepAlive_HttpProxyServer;
        }
        break;

      case pb.AdpRouter:
        switch (tag) {
          case '1':
            return rulesDirName_AdpRouter;
          case '2':
            return blocked_AdpRouter;
          case '3':
            return unblocked_AdpRouter;
          case '4':
            return etcHostsIpAsBlocked_AdpRouter;
          case '5':
            return dev_AdpRouter;
        }
        break;

      case pb.IPNetRouter:
        switch (tag) {
          case '1':
            return ip_IPNetRouter;
          case '2':
            return net_IPNetRouter;
          case '3':
            return matched_IPNetRouter;
          case '4':
            return unmatched_IPNetRouter;
          case '5':
            return fileTest_IPNetRouter;
        }
        break;

      case pb.RouterItem:
        switch (tag) {
          case '1':
            return name_RouterItem;
          case '2':
            return adp_RouterItem;
          case '3':
            return ipnet_RouterItem;
        }
        break;

      case pb.Config:
        switch (tag) {
          case '1':
            return basic_Config;
          case '2':
            return log_Config;
          case '3':
            return ipfs_Config;
          case '4':
            return ipfsServers_Config;
          case '5':
            return fileServers_Config;
          case '6':
            return httpProxyServers_Config;
          case '7':
            return routers_Config;
        }
        break;

      default:
        // type not found
        return '${tag}.@${type}';
    }
    // tag not found
    return '@${tag}.${type}';
  }
}

class Field_configLocalizationsDelegate
    extends LocalizationsDelegate<Field_configLocalizations> {
  final List<String> langs;
  const Field_configLocalizationsDelegate(this.langs);

  @override
  bool isSupported(Locale locale) => langs.contains(locale.languageCode);

  @override
  Future<Field_configLocalizations> load(Locale locale) =>
      Field_configLocalizations.load(locale);

  @override
  bool shouldReload(Field_configLocalizationsDelegate old) => false;
}
