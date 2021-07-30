class UserAuthUtils {
  static String name(value) {
    var sp = value?.toString()?.split('.');
    if (sp == null || sp.length != 2) {
      return null;
    }
    return sp[1];
  }

  static T valueOf<T>(List<T> values, String value) {
    if (value == null || values == null) {
      return null;
    }
    return values.firstWhere((element) => UserAuthUtils.name(element) == value,
        orElse: () => null);
  }

  static UserAuthorities fromString(String target) {
    switch (target) {
      case 'admin':
        return UserAuthorities.admin;
      case 'write':
        return UserAuthorities.write;
      case 'readonly':
        return UserAuthorities.readonly;
      default:
        return UserAuthorities.readonly;
    }
  }
}

enum UserAuthorities {
  readonly,
  write,
  admin,
}

class MemberInfo {
  MemberInfo({this.name, this.id, this.userAuthorities});
  String name;
  String id;
  UserAuthorities userAuthorities;
}
