import 'package:to_do_list/provider/to_do_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import './app_route.dart';
import '../pages/item_page.dart';
import '../pages/home_page.dart';

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ToDoListProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista de Tarefas',
        theme: ThemeData(
          colorSchemeSeed: const Color.fromRGBO(79, 111, 82, 1.0),
        ),
        initialRoute: AppRoute.home.route,
        routes: {
          AppRoute.home.route: (_) => const HomePage(),
          AppRoute.newItem.route: (_) => const ItemPage(item: null),
          AppRoute.editItem.route: (context) {
            final item = ModalRoute.of(context)?.settings.arguments;
            return ItemPage(
              item: item as Item?,
            );
          }
        },
      ),
    );
  }
}
