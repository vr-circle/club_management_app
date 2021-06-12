enum AuthFlowStatus { login, signUp, verification, session }

enum Role { Member, Anonymous }

class UserState {
  AuthFlowStatus authFlowStatus;
  Role role;
  String username;
}
