import 'dart:convert';

typedef ItemMap = Map<String, dynamic>;

class Item {
  final String id;
  final String title;
  final String description;
  final String date;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  String toString() {
    return title;
  }

  Item copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
  }) =>
      Item(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
      );

  ItemMap toMap([bool excludeId = true]) {
    return {
      if (!excludeId) 'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }

  String toJson([bool excludeId = true]) => jsonEncode(toMap(excludeId));
}
