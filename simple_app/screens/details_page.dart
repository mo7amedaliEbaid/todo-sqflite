import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_model.dart';
import '../providers/TODOprovider.dart';
import 'edit_page.dart';


class DetailPage extends StatefulWidget {
  final int todoId;

  const DetailPage({
    Key? key,
    required this.todoId,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TODO todo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshTODO();
  }

  Future refreshTODO() async {
    setState(() => isLoading = true);

    todo = await TODOProvider.instance.readTODO(widget.todoId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [
        editButton(),
        deleteButton(),
      ],
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          TextButton(
            onPressed: () async {
              if (isLoading) return;

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditPage(todo: todo),
                ),
              );

              refreshTODO();
            },
            child:  Text(
              'Edit',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.transparent,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            todo.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat.yMMMd().format(todo.createdTime),
            style: const TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 10),
          Text(
            todo.description,
            style:
            const TextStyle(color: Colors.white70, fontSize: 18),
          )
        ],
      ),
    ),
  );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditPage(todo: todo),
        ));

        refreshTODO();
      });

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete),
    onPressed: () async {
      await TODOProvider.instance.delete(widget.todoId);

      Navigator.of(context).pop();
    },
  );
}