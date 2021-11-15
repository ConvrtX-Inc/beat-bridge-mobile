/// Model for user
class UserModel {
  /// Constructor
  const UserModel(
      {this.id = '',
      this.token = '',
      this.username = '',
      this.email = '',
      this.phoneNumber = '',
      this.password = ''});

  /// Initialization
  final String id, token, username, email, phoneNumber, password;
}
