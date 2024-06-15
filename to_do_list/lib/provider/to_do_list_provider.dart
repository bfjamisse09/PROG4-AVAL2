import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/item.dart';

typedef ItemMap = Map<String, dynamic>;

class ToDoListProvider with ChangeNotifier {
  final _baseUrl = 'https://todolist-7ff7f-default-rtdb.firebaseio.com';

  final List<Item> _listItems = [];
  final List<String> _categoryList = ["Afazeres Domésticos", "Trabalho", "Escola", "Outros"];

  List<Item> get listItems => _listItems;
  List<String> get categoryItems => _categoryList;

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
        category: value['category'],
      );
      _listItems.add(item);
    });
    notifyListeners();
  }

  Future<void> save(Item item) {
    if (item.id == '') {
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
    _debugPrintListItems();
    notifyListeners();
  }

  Future<void> update(Item item) async {
    await http.put(
      Uri.parse('$_baseUrl/listItem/${item.id}.json'),
      body: item.toJson(),
    );

    final index = _listItems.indexWhere((elem) => elem.id == item.id);
    if (index >= 0) {
      _listItems[index] = item;
      notifyListeners();
    }
  }

  Future<void> delete(Item item) async {
    final url = Uri.parse('$_baseUrl/listItem/${item.id}.json');
    print('Deleting item with URL: $url'); // Log the URL

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Response: ${response.body}'); // Log the response body
        // Successfully deleted from Firebase, now remove from local list
        _listItems.removeWhere((listItem) => listItem.id == item.id);
        _debugPrintListItems();
        notifyListeners();
      } else {
        // Handle errors, log the response for debugging
        print('Failed to delete item: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error deleting item: $error'); // Log any errors
    }
  }

  void _debugPrintListItems() {
    for (var listItem in _listItems) {
      debugPrint(listItem.toString());
    }
    debugPrint("-----");
  }
}
