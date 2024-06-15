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
  final _categoryController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    final item = widget.item;

    super.initState();

    _titleController.text = item?.title ?? '';
    _descriptionController.text = item?.description ?? '';
    _dateController.text = item?.date ?? '';
    _categoryController.text = item?.category ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Initial date to display
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2100), // Maximum date
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0]; // Format the date
      });
    }
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
      category: _categoryController.text.trim(),
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
    if (text == null || text.isEmpty) {
      return 'Por favor, insira uma data.';
    }

    final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!datePattern.hasMatch(text)) {
      return 'Formato de data inválido. Use yyyy-mm-dd';
    }

    final parts = text.split('-');
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) {
      return 'Data inválida.';
    }

    if (month < 1 || month > 12 || day < 1 || day > 31) {
      return 'Data inválida.';
    }

    // Aqui você pode adicionar validações adicionais, como verificar se o ano é bissexto

    return null;
  }

  String? _categoryValidator(String? text) {
    final error = _titleValidator(text);
    if (error != null) {
      return error;
    }
    if ((text == null) || text.isEmpty) {
      return 'Este campo é obrigatório';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<ToDoListProvider>(context, listen: true).categoryItems;
    String dropdownValue = categories.last;
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
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Data',
                            ),
                            child: Text(
                              _dateController.text.isEmpty
                                  ? 'Selecione uma data'
                                  : _dateController.text,
                            ),
                          ),
                        ),
                        if (_dateController.text.isEmpty)
                          const Text(
                            'Por favor, insira uma data.',
                            style: TextStyle(color: Colors.red),
                          ),
                        DropdownButton(
                          value: dropdownValue,
                          items: categories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
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
