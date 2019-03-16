import 'package:protobuf/protobuf.dart' show BuilderInfo, GeneratedMessage;
import 'package:meta/meta.dart' show required;

enum NodeType {
  root,
  leaf,
  list,
  // no map support! we want to use tagNumber as path segment.
  // map,
}

// nav tree with only `leaf` or `list of leaf`. `leaf` node can
// have `oneof`s, but child `leaf` node of `oneof` must not next
// level `oneof`.
class NavNode {
  final Type pbtype;
  final GeneratedMessage defaultInstance;
  final BuilderInfo info;
  final NavNode parent;
  final int tag;
  final NodeType nodeType;
  final List<NavNode> children;

  int nameField;

  NavNode.root({@required this.defaultInstance})
      : assert(defaultInstance.info_.byIndex.isNotEmpty),
        assert(defaultInstance.info_.oneofs.isEmpty),
        pbtype = defaultInstance.runtimeType,
        info = defaultInstance.info_,
        parent = null,
        tag = null,
        nodeType = NodeType.root,
        children = [] {
    info.byIndex.forEach((fi) {
      assert(fi.isRepeated || fi.isGroupOrMessage);
      if (fi.isRepeated) {
        children.add(NavNode._list(
          defaultInstance: fi.subBuilder()..freeze(),
          parent: this,
          tag: fi.tagNumber,
        ));
      } else if (fi.isGroupOrMessage) {
        children.add(NavNode._leaf(
          defaultInstance: fi.makeDefault(),
          parent: this,
          tag: fi.tagNumber,
        ));
      }
    });
  }

  NavNode._list({
    @required this.defaultInstance,
    @required this.parent,
    @required this.tag,
  })  : assert(_checkValidLeafOneof(defaultInstance.info_)),
        assert(_nameField(defaultInstance.info_) != null),
        pbtype = defaultInstance.runtimeType,
        info = defaultInstance.info_,
        nodeType = NodeType.list,
        children = null,
        nameField = _nameField(defaultInstance.info_);

  NavNode._leaf({
    @required this.defaultInstance,
    @required this.parent,
    @required this.tag,
  })  : assert(_checkValidLeafOneof(defaultInstance.info_)),
        pbtype = defaultInstance.runtimeType,
        info = defaultInstance.info_,
        nodeType = NodeType.leaf,
        children = null,
        nameField = _nameField(defaultInstance.info_);

  NavNode findFromTags(List<int> tags) {
    assert(tags.length == 1 || tags.length == 2);
    assert(children != null);
    for (var child in children) {
      if (child.tag == tags[0]) return child;
    }
    throw Exception('Invalid route tags: ${tags}');
  }

  bool isInList(List<int> tags) => tags.length == 2;

  static int _nameField(BuilderInfo info) => info.byName['name']?.tagNumber;

  static bool _checkValidLeafOneof(BuilderInfo info) {
    if (info.oneofs.isNotEmpty) {
      info.oneofs.keys.forEach((tag) {
        final fi = info.fieldInfo[tag];
        if (!fi.isGroupOrMessage) return false;
        final BuilderInfo bi = fi.makeDefault().info_;
        bi.byIndex.forEach((field) {
          // must be simple type or Enum
          if (!field.isMapField && !field.isRepeated && !field.isGroupOrMessage)
            return false;
        });
      });
    }
    return true;
  }
}
