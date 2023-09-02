import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../business_logic/cubit/cubit.dart';
import '../styles/colors.dart';
import '../widgets/default_text.dart';
import 'edit_task_title_dialog.dart';

class CompletedTaskItem extends StatelessWidget {
  CompletedTaskItem({Key? key, required this.model}) : super(key: key);

  Map model;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model['id'].toString()),
      child: InkWell(
        splashColor: darkBlue,
        highlightColor: darkBlue,
        onTap: (){
          Fluttertoast.showToast(
              msg: "Long touch for Title editing, Swipe left or right to delete",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: black,
              textColor: lightBlue,
              fontSize: 14.sp
          );
        },
        onLongPress: (){
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return EditTaskTitleDialog(model: model,);
            },
          );
        },
        child: Padding(

          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: 25.w,
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
                decoration: const BoxDecoration(
                  color: darkBlue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DefaultText(
                      text: '${model['date']}',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: lightBlue,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(

                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(start: 2.w),
                        child: DefaultText(
                          text: '${model['title']}',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          maxLines: 3,
                        ),
                      ),
                    ),

                    Flexible(
                      child: DefaultText(
                        text: 'Starts at: ${model['startTime']}',
                        fontSize: 12.sp,
                        color: gray!,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Flexible(
                      child: DefaultText(
                        text: 'Ends at: ${model['endTime']}',
                        fontSize: 12.sp,
                        color: gray!,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.alarm, color: Colors.red,),
                      DefaultText(
                        text: '${model['reminder']}',
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){

                        AppCubit.get(context).changeStatus(

                          status: 'uncompleted',

                          id: model['id'],

                        );},

                        icon: const Icon(

                          Icons.close_outlined,

                          color: darkBlue,

                        ),

                      ),

                      IconButton(
                        onPressed: (){

                        AppCubit.get(context).changeStatus(

                          status: 'favorite',

                          id: model['id'],

                        );},

                        icon: const Icon(

                          Icons.favorite,

                          color: Colors.red,

                        ),

                      ),
                    ],
                  ),
                ],
              ),

            ],

          ),

        ),
      ),
      onDismissed: (direction){
        AppCubit.get(context).deleteData(id: model['id'],);
        Fluttertoast.showToast(
            msg: "Task deleted successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: darkBlue,
            fontSize: 14.sp
        );
      },
    );
  }
}
