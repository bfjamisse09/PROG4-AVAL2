import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/item.dart';

typedef ItemMap = Map<String, dynamic>;

class ToDoListProvider with ChangeNotifier {
  final _baseUrl = 'https://todolist-prog4-default-rtdb.firebaseio.com';

  final List<Item> _listItems = [];

  List<Item> get listItems => _listItems;

  Future<void> load() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/listItem.json'),
    );
    final data = jsonDecode(response.body);
    data.forEach((key, value) {
      final item = Item(
        id: key,
        title: value['title'],
        description: value['description'],
        date: value['date'],
      );
      _listItems.add(item);
    });
    notifyListeners();
  }

  Future<void> save(Item item) {
    if (item.id.isEmpty) {
      return insert(item);
    } else {
      return update(item);
    }
  }

  Future<void> insert(Item item) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/listItem.json'),
      body: item.toJson(),
    );

    final body = jsonDecode(response.body);

    _listItems.add(item.copyWith(
      id: body['title'],
    ));
    notifyListeners();
  }

  Future<void> update(Item item) async {
    await http.put(
      Uri.parse('$_baseUrl/listItem/${item.id}'),
      body: item.toJson(),
    );

    final index = _listItems.indexWhere((elem) => elem.id == item.id);
    if (index >= 0) {
      _listItems[index] = item;
      notifyListeners();
    }
  }

  Future<void> delete(Item item) async {
    await http.delete(Uri.parse('$_baseUrl/listItem/$item'));
  }
}
