import 'dart:convert';

typedef ItemMap = Map<String, dynamic>;

class Item {
  final String id;
  final String title;
  final String description;
  final String date;
  final String category;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
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
    String? category,
  }) =>
      Item(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
        category: category ?? this.category,
      );

  ItemMap toMap([bool excludeId = true]) {
    return {
      if (!excludeId) 'id': id,
      'title': title,
      'description': description,
      'date': date,
      'category': category,
    };
  }

  String toJson([bool excludeId = true]) => jsonEncode(toMap(excludeId));
}
