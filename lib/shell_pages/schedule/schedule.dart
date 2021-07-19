class Schedule {
  Schedule({
    this.id,
    this.title,
    this.start,
    this.end,
    this.place,
    this.details,
  });
  String id;
  String title;
  DateTime start;
  DateTime end;
  String place;
  String details;
}

class PersonalSchedule extends Schedule {}

class OrganizationSchedule extends Schedule {
  OrganizationSchedule({
    this.isPublic,
    this.createdBy,
  });
  bool isPublic;
  String createdBy;
}
