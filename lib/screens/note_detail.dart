import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low'];
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String appBarTitle;
  Note note;
  NoteDetailState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.caption;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(appBarTitle),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      moveToLastScreen();
                    })),
            body: Padding(
                padding: EdgeInsets.only(
                    top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: DropdownButton(
                          items: _priorities.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem));
                          }).toList(),
                          style: textStyle,
                          value: updatePriorityAsString(note.priority),
                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              debugPrint('User Selected $valueSelectedByUser');
                              updatePriorityAsInt(valueSelectedByUser);
                            });
                          }),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextField(
                          controller: titleController,
                          style: textStyle,
                          onChanged: (value) {
                            debugPrint(
                                'Something has happened in the Title Textfield');
                            updateTitle();
                          },
                          decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextField(
                          controller: descriptionController,
                          style: textStyle,
                          onChanged: (value) {
                            debugPrint(
                                'Something has happened in the Description Textfield');
                            updateDescription();
                          },
                          decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text('Save', textScaleFactor: 1.5),
                              onPressed: () {
                                setState(() {
                                  debugPrint('Save Button is pressed');
                                  _save();
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                          Expanded(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text('Delete', textScaleFactor: 1.5),
                              onPressed: () {
                                setState(() {
                                  debugPrint('Delete Button is pressed');
                                  _delete();
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ))));
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;

      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String updatePriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;

      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Note not saved');
    }
  }

  void _delete() async {
    moveToLastScreen();
    int result;
    if (note.id != null) {
      result = await helper.deleteNote(note.id);
    }

    if (result != null) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(message));

    showDialog(context: context, builder: (_) => alertDialog);
  }
}
