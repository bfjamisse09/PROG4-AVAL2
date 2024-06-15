import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_route.dart';
import '../provider/to_do_list_provider.dart';
import '../widgets/item_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<ToDoListProvider>(context, listen: false);
    provider.load().then(
      (_) {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items =
        Provider.of<ToDoListProvider>(context, listen: true).listItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoute.newItem.route);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => Dismissible(
                key: GlobalKey(),
                confirmDismiss: (_) {
                  return showDialog<bool>(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Confirmação'),
                        content: const Text('Confirmar a remoção do item?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop<bool>(context, true);
                            },
                            child: const Text('Sim'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop<bool>(context, false);
                            },
                            child: const Text('Não'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (_) {
                  final provider =
                      Provider.of<ToDoListProvider>(context, listen: false);
                  provider.delete(items[index]);
                },
                child: ItemTile(items[index]),
              ),
            ),
    );
  }
}
