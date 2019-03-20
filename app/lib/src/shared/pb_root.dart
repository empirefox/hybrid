import 'package:flutter/material.dart';
import 'package:path/path.dart' show posix;
import 'package:protobuf/protobuf.dart'
    show CreateBuilderFunc, MakeDefaultFunc, GeneratedMessage;

import '../env.dart';

abstract class PbRootHandler<R extends GeneratedMessage, E> {
  R saved();
  Future<E> save(R root);
}

class PbGetSetter {
  GeneratedMessage _one;
  List _list;
  bool _isList;
  final List<int> tags;
  int _n;
  bool _isCreate;
  bool _created = false;
  CreateBuilderFunc _subBuilder;
  MakeDefaultFunc _makeDefault;
  PbGetSetter({@required root, @required this.tags}) : _one = root {
    bool baseIsList = false;
    bool nextIsList;
    for (var i = 0; i < tags.length - 1; i++) {
      final tag = tags[i];
      final next = baseIsList ? _list[tag] : _one.getField(tag);
      // the first
      if (nextIsList == null) nextIsList = root.info_.fieldInfo[tag].isRepeated;
      if (baseIsList = nextIsList) {
        _list = next;
        // no list of list
        nextIsList = false;
      } else {
        _one = next;
        final nextTag = tags[i + 1];
        nextIsList = _one.info_.fieldInfo[nextTag].isRepeated;
      }
    }

    final length = tags.length;
    final fromTag = length == 1
        ? tags[0]
        : (baseIsList ? tags[length - 2] : tags[length - 1]);
    final fromFieldInfo = _one.info_.fieldInfo[fromTag];

    _isList = baseIsList;
    _n = tags.last;
    _isCreate = _isList && _n < 0;
    _subBuilder = fromFieldInfo.subBuilder;
    _makeDefault = fromFieldInfo.makeDefault;
    _list = _list ?? [];
    if (_isCreate) _n = _list.length;
  }

  get current {
    if (_isList) {
      return _isCreate && !_created ? newEmpty() : _list[_n];
    } else
      return _one.getField(_n);
  }

  void set current(curr) {
    if (_isList) {
      if (_isCreate && !_created) {
        _list.add(curr);
        _created = true;
      } else
        _list[_n] = curr;
    } else
      _one.setField(_n, curr);
  }

  bool get isCreate => _isCreate;
  bool get isInList => _isList;

  GeneratedMessage newEmpty() =>
      _isList ? _subBuilder() : _makeDefault().createEmptyInstance();
}

class PbRoot<R extends GeneratedMessage, E> {
  final PbRootHandler<R, E> handler;

  BuildContext _context;
  BuildContext get context => _context;
  void initContext(BuildContext c) {
    if (c != _context) {
      _context = c;
      _route = null;
    }
  }

  R _root;
  R get root {
    if (_root == null) reset();
    return _root;
  }

  void set root(R root) {
    if (root != _root) {
      _root = root;
      _route = null;
    }
  }

  // null value will compute _gs
  String _route;
  PbGetSetter _gs;
  String get route => _route ?? routePath(context);

  String get routeSuffixForDev => appEnv.dev ? '-${route}' : '';

  PbRoot(this.handler);

  static String routePath(BuildContext context) =>
      ModalRoute.of(context).settings.name;

  void reset() => root = handler.saved().clone();
  Future<E> save() => handler.save(root);

  Future<T> goto<T>(int tag, {Object arguments}) =>
      Navigator.pushNamed<T>(context, posix.join(routePath(context), '${tag}'),
          arguments: arguments);

  GeneratedMessage newFrom(Map<String, dynamic> m) =>
      newEmpty()..mergeFromJsonMap(m);
  GeneratedMessage newEmpty() => _getSetter().newEmpty();

  // current data of root
  get current => _getSetter().current;
  void set current(c) => _getSetter().current = c;

  bool get isInList => _getSetter().isInList;
  List<int> get tags => _getSetter().tags;

  PbGetSetter _getSetter() {
    if (_route != null) return _gs;
    _route = routePath(context);

    final tags = posix
        .split(posix.relative(_route,
            from: Navigator.of(context).widget.initialRoute))
        .map((s) => int.parse(s))
        .toList();
    return _gs = PbGetSetter(root: root, tags: tags);
  }
}
