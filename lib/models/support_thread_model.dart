///Support thread model
class SupportThreadModel {
  ///Constructor
  SupportThreadModel(
      {this.name = '',
      this.message = '',
      this.createdDate = '',
      this.fromAdmin = false});

  ///Initialization for id
  String name;

  ///Initialization for message
  String message;

  ///Initialization for createdDate
  String createdDate;

  ///Initialization for fromAdmin
  bool fromAdmin;
}
