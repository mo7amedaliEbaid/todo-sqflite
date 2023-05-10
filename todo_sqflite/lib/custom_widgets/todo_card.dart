import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqflite/models/todo_model.dart';

final shadeOfColors = [
  Colors.blue.shade900,
  Colors.deepPurple.shade900,
  Colors.pink.shade900,
  Colors.orange.shade900,
  Colors.brown,
];

class TODOCard extends StatelessWidget {
  const TODOCard({
    Key? key,
    required this.todo,
    required this.index,
  }) : super(key: key);

  final TODO todo;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = shadeOfColors[index % shadeOfColors.length];
    final time = DateFormat.yMMMd().format(todo.createdTime);

    return Card(
      color: color,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              todo.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              todo.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

}