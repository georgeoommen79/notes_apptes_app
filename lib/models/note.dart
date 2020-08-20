class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get id => this._id;
  String get title => this._title;
  String get description => this._description;
  String get date => this._date;
  int get priority => this._priority;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set priority(int newPriority) {
    this._priority = newPriority;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}
