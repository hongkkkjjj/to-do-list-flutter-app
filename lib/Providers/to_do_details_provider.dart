import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/Model/to_do_details.dart';

class ToDoDetailsProvider extends ChangeNotifier {
  List<ToDoDetails> _toDoDetailsList = [
    ToDoDetails(id: 1,
      title: 'Automated Testing Script',
      startDate: '21 Oct 2019',
      endDate: '23 Oct 2019',
      status: 'Incomplete',
    )
  ];

  List<ToDoDetails> get toDoDetailsList => _toDoDetailsList;

  void updateTimeLeft() async {
    for (var record in _toDoDetailsList) {
      DateFormat formatter = DateFormat('dd MMM yyyy');
      DateTime now = DateTime.now();
      DateTime dueDate = formatter.parse(record.endDate);
      int dayDiff = 0;
      int hourDiff = 0;
      int minDiff = 0;
      if (now.isAfter(dueDate)) {
        dayDiff = now.difference(dueDate).inDays;
        hourDiff = now.difference(dueDate).inHours % 24;
        minDiff = now.difference(dueDate).inMinutes % 60;
        record.isExpired = true;
      } else {
        dayDiff = dueDate.difference(now).inDays;
        hourDiff = dueDate.difference(now).inHours % 24;
        minDiff = dueDate.difference(now).inMinutes % 60;
        record.isExpired = false;
      }

      String timeLeft = '';
      String varDay = (dayDiff > 1) ? 'days' : 'day';
      String varHour = (hourDiff > 1) ? 'hrs' : 'hr';
      String varMin = (minDiff > 1) ? 'mins' : 'min';
      if (dayDiff != 0) {
        timeLeft = '$dayDiff $varDay $hourDiff $varHour $minDiff $varMin';
      } else {
        if (hourDiff != 0) {
          timeLeft = '$hourDiff $varHour $minDiff $varMin';
        } else {
          timeLeft = '$minDiff $varMin';
        }
      }
      record.timeLeft = timeLeft;
    }

    notifyListeners();
  }

  Future<ToDoDetails> getSingleRecord(int id) async {
    ToDoDetails result = ToDoDetails(id: 0);

    for (var detail in _toDoDetailsList) {
      if (detail.id == id) {
        result = detail;
      }
    }

    return result;
  }

  Future<String> insertRecord(
      String title, String startDate, String endDate) async {

    String msg = '';

    DateFormat formatter = DateFormat('dd MMM yyyy');
    DateTime now = DateTime.now();
    DateTime dueDate = formatter.parse(endDate);

    ToDoDetails toDoDetail = ToDoDetails(
      id: _toDoDetailsList.length + 1,
      title: title,
      startDate: startDate,
      endDate: endDate,
      status: 'Incomplete',
      isExpired: (now.isAfter(dueDate)),
    );

    _toDoDetailsList.add(toDoDetail);
    _toDoDetailsList.sort((a, b) => b.status.compareTo(a.status));

    msg = 'ok';

    notifyListeners();

    return msg;
  }

  Future<String> updateRecord(
      int id, String title, String startDate, String endDate) async {
    String msg = '';

    DateFormat formatter = DateFormat('dd MMM yyyy');
    DateTime now = DateTime.now();
    DateTime dueDate = formatter.parse(endDate);

    for (var detail in _toDoDetailsList) {
      if (detail.id == id) {
        detail.title = title;
        detail.startDate = startDate;
        detail.endDate = endDate;
        detail.isExpired = (now.isAfter(dueDate));

        msg = 'ok';
      }
    }

    // sort the To-Do list
    _toDoDetailsList.sort((a, b) => b.status.compareTo(a.status));

    notifyListeners();

    return msg;
  }

  Future<String> updateStatus(int id, String status) async {
    String msg = '';

    for (var detail in _toDoDetailsList) {
      if (detail.id == id) {
        detail.status = status;

        msg = 'ok';
      }
    }

    // sort the To-Do list
    _toDoDetailsList.sort((a, b) => b.status.compareTo(a.status));

    notifyListeners();

    return msg;
  }
}
