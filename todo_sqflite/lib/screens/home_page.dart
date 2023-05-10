import 'package:flutter/material.dart';
import 'package:todo_sqflite/custom_widgets/todo_card.dart';
import '../models/todo_model.dart';
import '../providers/TODOprovider.dart';
import 'details_page.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late List<TODO> todoList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshingAllTODOs();
  }

  @override
  void dispose() {
    TODOProvider.instance.close();
    super.dispose();
  }

  Future refreshingAllTODOs() async {
    setState(() => isLoading = true);
    todoList = await TODOProvider.instance.readAllTODOs();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: const Text(
            'TODO',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.pink.shade900,
                ),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const EditPage()),
                  );
                  refreshingAllTODOs();
                },
                child: const Text('Add TODO'),
              ),
            ),
          ],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : todoList.isEmpty
              ? Padding(
                padding: const EdgeInsets.all(25.0),
                child: const Text(
            'No TODOS in the beginning...',
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
              )
              : buildingAllTODOs(),
        ),
      );

  Widget buildingAllTODOs() =>
      ListView.builder(
          shrinkWrap: true,
          itemCount: todoList.length,
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailPage(todoId: todoList[index].id!),
                ));
                refreshingAllTODOs();
              },
              child: TODOCard(todo: todoList[index], index: index),
            );
          });

}