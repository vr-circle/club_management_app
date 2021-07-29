import 'package:flutter/cupertino.dart';

enum UserAuthorities {
  none,
  readonly,
  write,
  admin,
}

// UserAuthorities convertToUserAuthorities(String data) {
//   switch (data) {
//     case 'none':
//       return UserAuthorities.none;
//     case 'readonly':
//       return UserAuthorities.readonly;
//     case 'write':
//       return UserAuthorities.write;
//     case 'admin':
//       return UserAuthorities.admin;
//     default:
//       return UserAuthorities.readonly;
//   }
// }

class UserInfo {
  UserInfo(
      {@required this.id, @required this.name, @required this.userAuthorities});
  final String id;
  String name;
  UserAuthorities userAuthorities;
}
