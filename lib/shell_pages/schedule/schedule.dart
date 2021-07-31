import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

Uuid _uuid = Uuid();

class Schedule {
  Schedule({
    String id,
    @required this.title,
    @required this.start,
    @required this.end,
    @required this.place,
    @required this.details,
    @required this.createdBy,
    @required this.isPublic,
  }) : id = id ?? _uuid.v4();
  String id;
  String title;
  DateTime start;
  DateTime end;
  String place;
  String details;
  String createdBy;
  bool isPublic;
}
