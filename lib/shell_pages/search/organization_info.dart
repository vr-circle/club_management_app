import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/user_settings/user_info.dart';

class OrganizationInfo {
  OrganizationInfo({
    this.id,
    @required this.name,
    @required this.introduction,
    @required this.tagList,
    @required this.members,
  });
  String id;
  String name;
  String introduction;
  List<UserInfo> members;
  List<String> tagList;
}
