enum UserAuthorities {
  none,
  readonly,
  write,
  admin,
}

UserAuthorities convertToUserAuthorities(String data) {
  switch (data) {
    case 'none':
      return UserAuthorities.none;
    case 'readonly':
      return UserAuthorities.readonly;
    case 'write':
      return UserAuthorities.write;
    case 'admin':
      return UserAuthorities.admin;
    default:
      return UserAuthorities.readonly;
  }
}

class MemberInfo {
  MemberInfo({this.name, this.id, this.userAuthorities});
  String name;
  String id;
  UserAuthorities userAuthorities;
}
