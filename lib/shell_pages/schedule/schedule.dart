import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class Schedule {
  Schedule(
      {String id,
      this.title,
      this.start,
      this.end,
      this.place,
      this.details,
      this.createdBy})
      : id = id ?? _uuid.v4();
  String id;
  String title;
  String place;
  DateTime start;
  DateTime end;
  String details;
  String createdBy;
}
