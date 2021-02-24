import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/Constant/const_text.dart';
import 'package:to_do_list_app/Layout/Color/CustomColor.dart';
import 'package:to_do_list_app/Layout/ReusableLayout/ReusableAppBar.dart';
import 'package:to_do_list_app/Layout/create_task_screen.dart';
import 'package:to_do_list_app/Model/to_do_details.dart';
import 'package:to_do_list_app/Providers/to_do_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/Utility/common_util.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Update time left before display
    _updateDetailTimeLeft();

    // Set 60sec timer to refresh time left section
    const timerPeriod = const Duration(seconds:60);
    Timer.periodic(timerPeriod, (timer) {
      setState(() {
        _updateDetailTimeLeft();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar('To-Do List'),
      backgroundColor: CustomColor.GrayBackgroundColor,
      body: _bodyWidget(),
      floatingActionButton: _floatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: _listView(),
    );
  }

  Widget _floatingButton() {
    return FloatingActionButton(
      backgroundColor: CustomColor.ButtonRed,
      onPressed: () {
        _goToCreateTaskScreen(true, 0);
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget _listView() {
    return Consumer<ToDoDetailsProvider>(builder: (context, model, child) {
      return ListView.builder(
        itemCount: model.toDoDetailsList.length,
        itemBuilder: (c, i) => _singleToDoList(model.toDoDetailsList[i]),
      );
    });
  }

  Widget _singleToDoList(ToDoDetails details) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [Util.commonBoxShadow()]),
      child: InkWell(
        onTap: () {
          _goToCreateTaskScreen(false, details.id);
        },
        child: _contentContainer(details),
      ),
    );
  }

  Widget _contentContainer(ToDoDetails details) {
    return Column(
      children: [
        _detailContentContainer(details),
        _bottomStatusContainer(details),
      ],
    );
  }

  Widget _detailContentContainer(ToDoDetails details) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              details.title,
              style: TextStyle(
                fontWeight: ConstantText.FONT_WEIGHT_BOLD,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(height: 15),
          Column(
            children: [
              Row(
                children: [
                  _titleText('Start Date'),
                  _titleText('End Date'),
                  _titleText((details.isExpired) ? 'Overdue time' : 'Time left'),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  _dateDetailText(details.startDate),
                  _dateDetailText(details.endDate),
                  _dateDetailText(details.timeLeft, details.isExpired),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _titleText(String text) {
    return Expanded(
      flex: 3,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
            fontWeight: ConstantText.FONT_WEIGHT_SEMI_BOLD,
          ),
        ),
      ),
    );
  }

  Widget _dateDetailText(String text, [bool isExpired = false]) {
    return Expanded(
      flex: 3,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 3,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: ConstantText.FONT_WEIGHT_SEMI_BOLD,
            color: (isExpired) ? Colors.redAccent : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _bottomStatusContainer(ToDoDetails details) {
    return Container(
      color: CustomColor.StatusContainerColor,
      padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            'Status',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 10),
          Text(
            details.status,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: ConstantText.FONT_WEIGHT_SEMI_BOLD,
            ),
          ),
          Spacer(),
          Text(
            'Tick if completed',
            style: TextStyle(
              fontWeight: ConstantText.FONT_WEIGHT_MEDIUM,
              fontSize: 14.0,
            ),
          ),
          Checkbox(
            value: (details.status == 'Complete'),
            onChanged: (newValue) {
              setState(() {
                if (newValue) {
                  _updateToDoStatus(details.id, 'Complete');
                } else {
                  _updateToDoStatus(details.id, 'Incomplete');
                }
              });
            },
          ),
        ],
      ),
    );
  }

  /// Function

  void _updateDetailTimeLeft() {
    Provider.of<ToDoDetailsProvider>(context, listen: false).updateTimeLeft();
  }

  void _goToCreateTaskScreen(bool createNewToDo, int toDoId) async {
    final result = await Util.pushTo(context, () => CreateTaskScreen(createNewToDo, toDoId), 'CreateTaskScreen');
    if (result == 'refresh') {
      setState(() {
        _updateDetailTimeLeft();
      });
    }
  }

  void _updateToDoStatus(int id, String status) {
    Provider.of<ToDoDetailsProvider>(context, listen: false).updateStatus(id, status).then((value) {
      if (value == 'ok') {
        setState(() {
          _updateDetailTimeLeft();
        });
      }
    });
  }
}
