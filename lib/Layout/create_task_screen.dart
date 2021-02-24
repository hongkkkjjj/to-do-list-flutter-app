import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/Constant/const_text.dart';
import 'package:to_do_list_app/Layout/ReusableLayout/ReusableAppBar.dart';
import 'package:to_do_list_app/Model/to_do_details.dart';
import 'package:to_do_list_app/Providers/to_do_details_provider.dart';
import 'package:to_do_list_app/Utility/common_util.dart';

class CreateTaskScreen extends StatefulWidget {
  final bool createTodo;
  final int toDoId;

  CreateTaskScreen(this.createTodo, this.toDoId);

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  TextEditingController _toDoTitle = new TextEditingController();
  String _startDate = '';
  String _endDate = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _getRecord());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar('Add new To-Do List'),
      backgroundColor: Colors.white,
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        child: Column(
          children: [
            _titleText('To-Do Title'),
            _reminderTextField(),
            _titleText('Start Date'),
            _dateDropDown(_startDate, 1),
            _titleText('Estimated End Date'),
            _dateDropDown(_endDate, 2),
          ],
        ),
      ),
    );
  }

  Widget _titleText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: ConstantText.FONT_WEIGHT_MEDIUM,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _reminderTextField() {
    return Container(
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black26,
        ),
      ),
      child: TextField(
        controller: _toDoTitle,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        textInputAction: TextInputAction.done,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: ConstantText.FONT_WEIGHT_REGULAR,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Please key in your To-Do title here',
            hintStyle: TextStyle(
              color: Colors.black12,
              fontWeight: ConstantText.FONT_WEIGHT_REGULAR,
              fontSize: 16.0,
            )),
      ),
    );
  }

  Widget _dateDropDown(String text, int type) {
    /// type 1 is start date, 2 is end date
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black26,
        ),
      ),
      child: ListTile(
        title: Text(
          (text.isEmpty) ? 'Select a date' : text,
          style: _dateTextStyle(text),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          size: 20,
          color: Colors.black54,
        ),
        onTap: () {
          _openDatePicker(context, text, type);
        },
      ),
    );
  }

  TextStyle _dateTextStyle(String text) {
    return TextStyle(
      color: (text.isEmpty) ? Colors.black12 : Colors.black,
      fontWeight: ConstantText.FONT_WEIGHT_REGULAR,
      fontSize: 16.0,
    );
  }

  Widget _bottomNavigationBar() {
    return Container(
      height: 80,
      color: Colors.black,
      child: InkWell(
        onTap: () {
          _validateInput();
        },
        child: Center(
          child: Text(
            (widget.createTodo) ? 'Create Now' : 'Update Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: ConstantText.FONT_WEIGHT_MEDIUM,
            ),
          ),
        ),
      ),
    );
  }

  /// Function
  Future<void> _openDatePicker(
      BuildContext context, String dateStr, int type) async {
    /// type 1 is start date, 2 is end date
    DateFormat formatter = DateFormat('dd MMM yyyy');
    final DateTime initialDate =
        (dateStr.isEmpty) ? DateTime.now() : formatter.parse(dateStr);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && formatter.format(picked) != dateStr)
      setState(() {
        if (type == 1) {
          _startDate = formatter.format(picked);
        } else {
          _endDate = formatter.format(picked);
        }
      });
  }

  void _validateInput() {
    // check empty title
    if (_toDoTitle.text.isEmpty) {
      _showDialog(msg: 'To-Do title cannot be empty.');
      return;
    }

    // check empty date
    if ((_startDate.isEmpty) || (_endDate.isEmpty)) {
      _showDialog(msg: 'Date cannot be empty.');
      return;
    }

    DateFormat formatter = DateFormat('dd MMM yyyy');
    if (formatter.parse(_startDate).isAfter(formatter.parse(_endDate))) {
      _showDialog(msg: 'Start date must be after end date.');
    } else {
      if (widget.createTodo) {
        _insertData();
      } else {
        _updateData();
      }
    }
  }

  void _showDialog({String msg, int type = 0}) {
    var okButton = CupertinoButton(
        child: Text(
          'OK',
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
        onPressed: () {
          // pop alert dialog
          Navigator.of(context).pop();
          if (type != 0) {
            // pop back to home screen
            Navigator.of(context).pop('refresh');
          }
        });
    Util.showCustomDialog(context, msg, [okButton], '');
  }

  void _insertData() {
    Provider.of<ToDoDetailsProvider>(context, listen: false)
        .insertRecord(_toDoTitle.text, _startDate, _endDate)
        .then((value) {
      if (value == 'ok') {
        _showDialog(msg: 'New To-Do list has created.', type: 1);
      } else {
        _showDialog(msg: 'Failed to create new To-Do list.');
      }
    });
  }

  void _updateData() {
    Provider.of<ToDoDetailsProvider>(context, listen: false)
        .updateRecord(widget.toDoId, _toDoTitle.text, _startDate, _endDate)
        .then((value) {
      if (value == 'ok') {
        _showDialog(msg: 'To-Do list has updated.', type: 1);
      } else {
        _showDialog(msg: 'Failed to update To-Do list.');
      }
    });
  }

  void _getRecord() {
    if (!widget.createTodo) {
      Provider.of<ToDoDetailsProvider>(context, listen: false)
          .getSingleRecord(widget.toDoId)
          .then((value) {
        setState(() {
          _toDoTitle.text = value.title;
          _startDate = value.startDate;
          _endDate = value.endDate;
        });
      });
    }
  }
}
