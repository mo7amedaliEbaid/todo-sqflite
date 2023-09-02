import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../business_logic/cubit/cubit.dart';
import '../../../business_logic/cubit/states.dart';
import '../../styles/colors.dart';
import '../../widgets/default_form_field.dart';
import '../../widgets/default_text.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  var dateController = TextEditingController();
  TimeOfDay initialStartTime = TimeOfDay.now();
  TimeOfDay initialEndTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 1)));
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertTaskState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {

          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            backgroundColor: lightBlue,
            extendBody: true,
            key: scaffoldKey,
            appBar: AppBar(
                backgroundColor: darkBlue,
                title: Center(
                  child: DefaultText(
                    text: cubit.titles[cubit.currentIndex],
                    color: lightBlue,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                )
            ),
            body: Builder(
             // condition: state is! AppGetDBLoadingState,
              builder: (BuildContext context) => state is! AppGetDBLoadingState?cubit.screens[cubit.currentIndex]:const Center(child: CircularProgressIndicator()),
             // fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: darkBlue,
              onPressed: (){
                if(cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      startTime: startTimeController.text,
                      endTime: endTimeController.text,
                      date: dateController.text,
                      reminder: cubit.dropDownValue,
                    );
                    cubit.setReminder(
                        titleController.text, selectedDate!, selectedStartTime!, cubit.dropDownValue);
                  }
                  } else {
                    scaffoldKey.currentState!.showBottomSheet((context) =>
                        Wrap(
                          children: [
                            Container(
                              color: darkBlue,
                              padding: EdgeInsets.symmetric(vertical: 2.h,
                                  horizontal: 3.w),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DefaultFormField(
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Title must not be empty';
                                        }
                                        return null;
                                      },
                                      labelText: 'Task Title',
                                      textColor: white,
                                      prefixIcon: const Icon(
                                        Icons.title_outlined, color: lightBlue,),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.h),
                                      child: DefaultFormField(
                                        controller: dateController,
                                        keyboardType: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.parse('2024-01-07'),
                                          ).then((value) {
                                            selectedDate = value;
                                            dateController.text = DateFormat.yMMMd()
                                                .format(value!)
                                                .toString();
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Date must not be empty';
                                          }
                                          return null;
                                        },
                                        labelText: 'Task Date',
                                        textColor: white,
                                        prefixIcon: const Icon(
                                          Icons.date_range_outlined,
                                          color: lightBlue,),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                end: 2.w),
                                            child: DefaultFormField(
                                              controller: startTimeController,
                                              onTap: () {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: initialStartTime,
                                                ).then((value) {
                                                  selectedStartTime = value;
                                                  startTimeController.text =
                                                      selectedStartTime!.format(
                                                          context).toString();
                                                });
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Start Time must not be empty';
                                                }
                                                return null;
                                              },
                                              labelText: 'Start Time',
                                              textColor: white,
                                              prefixIcon: const Icon(
                                                Icons.timer, color: lightBlue,),
                                              keyboardType: TextInputType.datetime,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: DefaultFormField(
                                            controller: endTimeController,
                                            onTap: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime: initialEndTime,
                                              ).then((value) {
                                                if (value!.hour.toDouble() >
                                                    selectedStartTime!.hour
                                                        .toDouble()) {
                                                  selectedEndTime = value;
                                                  endTimeController.text =
                                                      selectedEndTime!.format(
                                                          context).toString();
                                                } else if (value.hour.toDouble() ==
                                                    selectedStartTime!.hour
                                                        .toDouble()
                                                    && value.minute.toDouble() >=
                                                        selectedStartTime!.minute
                                                            .toDouble()) {
                                                  selectedEndTime = value;
                                                  endTimeController.text =
                                                      selectedEndTime!.format(
                                                          context).toString();
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: "End Time can't be before Start Time",
                                                      toastLength: Toast
                                                          .LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.red,
                                                      textColor: darkBlue,
                                                      fontSize: 16.0
                                                  );
                                                }
                                              });
                                            },
                                            labelText: 'End Time',
                                            textColor: white,
                                            prefixIcon: const Icon(
                                              Icons.timer_off_outlined,
                                              color: lightBlue,),
                                            keyboardType: TextInputType.datetime,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.h),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: darkBlue,
                                          border: Border.all(color: black, width: 0.3),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: BlocBuilder<AppCubit, AppStates>(
                                          builder: (BuildContext context, state) {
                                            return DropdownButton(
                                                isExpanded: true,
                                                dropdownColor: darkBlue,
                                                icon: Padding(
                                                  padding: EdgeInsetsDirectional.only(end: 3.w),
                                                  child: const Icon(Icons.keyboard_arrow_down, color: lightBlue,),
                                                ),
                                                value: cubit.dropDownValue,
                                                items: cubit.dropDownListItems.map((String items) {
                                                  return DropdownMenuItem(
                                                      value: items,
                                                      child: Padding(
                                                        padding: EdgeInsetsDirectional.only(start: 3.w),
                                                        child: DefaultText(text: items, color: lightBlue,),
                                                      )
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) => cubit.changeDropDownListValue(newValue!)
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ).closed.then((value) {
                      cubit.changeBSState(isShow: false, icon: Icons.edit,);
                    });
                    cubit.changeBSState(isShow: true, icon: Icons.add,);
                  }
              },
              child: Icon(cubit.fabIcon, color: lightBlue,),
              elevation: 20,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: darkBlue,
              elevation: 0,
              shape: const CircularNotchedRectangle(),
              notchMargin: 4,
              child: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                elevation: 0,
                backgroundColor: Colors.transparent,
                onTap: (index){
                  cubit.changeIndex(index);
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: blue,
                unselectedItemColor: lightBlue,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'All',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.close_outlined,
                    ),
                    label: 'Uncompleted',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Completed',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.favorite,
                    ),
                    label: 'Favourite',
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}
