import 'package:flutter/cupertino.dart';

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

enum UserAuthorities {
  none,
  read,
  write,
  admin,
}

UserAuthorities convertToUserAuthorities(String data) {
  switch (data) {
    case 'none':
      return UserAuthorities.none;
    case 'read':
      return UserAuthorities.read;
    case 'write':
      return UserAuthorities.write;
    case 'admin':
      return UserAuthorities.admin;
    default:
      return UserAuthorities.read;
  }
}

class UserInfo {
  UserInfo(
      {@required this.id, @required this.name, @required this.userAuthorities});
  final String id;
  String name;
  UserAuthorities userAuthorities;
}
