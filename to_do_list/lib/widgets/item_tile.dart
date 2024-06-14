import 'package:flutter/material.dart';

import '../app/app_route.dart';
import '../models/item.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  const ItemTile(
    this.item, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoute.editItem.route,
          arguments: item,
        );
      },
      title: Text(item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          )),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.description),
          Text(item.date),
        ],
      ),
    );
  }
}
