import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../styles/colors.dart';
import '../widgets/default_text.dart';
import 'completed_task_item.dart';
import 'favorite_task_item.dart';
import 'uncompleted_task_item.dart';
import 'all_task_item.dart';

class TaskBuilder extends StatelessWidget {
  TaskBuilder({Key? key, required this.taskType, required this.noTasks, required this.tasks}) : super(key: key);

  List<Map> tasks;
  String noTasks;
  String taskType;


  @override
  Widget build(BuildContext context) {
    return Container(
    //  condition: tasks.isNotEmpty,

      child:tasks.isNotEmpty? ListView.separated(
        itemBuilder: (context, index) {
          if(taskType == 'uncompleted') {
            return DoneTaskItem(model: tasks[index],);
          }else if(taskType == 'completed') {
            return CompletedTaskItem(model: tasks[index],);
          }else if(taskType == 'favourite') {
            return FavoriteTaskItem(model: tasks[index],);
          }else {
            return AllTaskItem(model: tasks[index]);
          }
        },
        separatorBuilder: (context, index) => Row(
          children: [
            Expanded(child: Divider(height: 1.h, color: Colors.black45)),
          ],
        ),
        itemCount: tasks.length,
      ):
       Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu,
              size: 75.0,
              color: darkBlue,
            ),
            Flexible(
              child: DefaultText(
                text: noTasks,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: darkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
