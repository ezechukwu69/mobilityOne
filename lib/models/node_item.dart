import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class NodeItem extends Equatable {
  dynamic value;
  String id;
  String name;
  NodeItem? parent;
  List<NodeItem>? children;
  NodeItem({required this.value, required this.name, required this.id, this.children, this.parent});

  NodeItem copyWith({
  dynamic value,
    String? id,
    String? name,
    NodeItem? parent,
    List<NodeItem>? children,
}) {
    return NodeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      parent: parent ?? this.parent,
      children: children ?? this.children,
      value: value ?? this.value
    );
}

  void addChild(NodeItem nodeItem) {
    nodeItem.parent = this;
    if (nodeItem.value.children.isNotEmpty) {
      for (var child in nodeItem.value.children) {
        nodeItem.addChild(NodeItem(value: child, name: child.name, id: child.id));
      }
    }

    children ??= [];

    children!.add(nodeItem);
  }

  @override
  List<Object?> get props => [id] ;
}