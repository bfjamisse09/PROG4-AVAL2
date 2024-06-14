import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../provider/to_do_list_provider.dart';

class ItemPage extends StatefulWidget {
  final Item? item;

  const ItemPage({
    super.key,
    this.item,
  });

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    final item = widget.item;

    super.initState();

    _titleController.text = item?.title ?? '';
    _descriptionController.text = item?.description ?? '';
    _dateController.text = item?.date ?? '';
  }

  void _formSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final item = Item(
      id: widget.item?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      date: _dateController.text.trim(),
    );

    final provider = Provider.of<ToDoListProvider>(
      context,
      listen: false,
    );
    final nav = Navigator.of(context);

    setState(() => _isLoading = true);
    try {
      await provider.save(item);
      nav.pop();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _titleValidator(String? text) {
    if ((text == null) || text.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  String? _descriptionValidator(String? text) {
    final error = _titleValidator(text);
    if (error != null) {
      return error;
    }
    if ((text == null) || text.isEmpty) {
      return 'Este campo é obrigatório';
    }

    return null;
  }

  String? _dateValidator(String? text) {
    final error = _titleValidator(text);
    if (error != null) {
      return error;
    }
    if (int.tryParse(text!) == null) {
      return 'Data Inválida';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Item'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _formSubmit(context),
        child: const Icon(Icons.save),
      ),
      body: !_isLoading
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Título',
                          ),
                          controller: _titleController,
                          validator: _titleValidator,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                          ),
                          controller: _descriptionController,
                          validator: _descriptionValidator,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Data',
                          ),
                          controller: _dateController,
                          validator: _dateValidator,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
