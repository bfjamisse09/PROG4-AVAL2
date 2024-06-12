import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_route.dart';
import '../provider/to_do_list_provider.dart';
import '../widgets/to_do_list_tile.dart';

Widget icon = Container(
  decoration: const BoxDecoration(color: Colors.red),
  child: const Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.delete,
          size: 30.0,
        ),
      ],
    ),
  ),
);

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

    final provider = Provider.of<AgendaProvider>(context, listen: false);
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
    final contacts =
        Provider.of<AgendaProvider>(context, listen: true).contacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoute.newContact.route);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) => Dismissible(
                key: Key(contacts[index].id),
                background: icon,
                onDismissed: (direction) {},
                child: ContactTile(contacts[index]),
              ),
            ),
    );
  }
}
