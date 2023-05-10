import 'package:flutter/material.dart';

import '../custom_widgets/todo_form.dart';
import '../models/todo_model.dart';
import '../providers/TODOprovider.dart';

class EditPage extends StatefulWidget {
  final TODO? todo;

  const EditPage({
    Key? key,
    this.todo,
  }) : super(key: key);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    title = widget.todo?.title ?? '';
    description = widget.todo?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: TODOForm(
        title: title,
        description: description,
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          onSurface: Colors.pink.shade900,
          shadowColor: Colors.grey.shade600,
          primary: isFormValid ? Colors.pink.shade900 : Colors.pink.shade900,
        ),
        onPressed: addOrUpdateTODO,
        child: const Text(
          'Add or Update',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  void addOrUpdateTODO() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.todo != null;

      if (isUpdating) {
        await updateTODO();
      } else {
        await addTODO();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateTODO() async {
    final todo = widget.todo!.copy(
      title: title,
      description: description,
    );

    await TODOProvider.instance.update(todo);
  }

  Future addTODO() async {
    final todo = TODO(
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );

    await TODOProvider.instance.create(todo);
  }
}