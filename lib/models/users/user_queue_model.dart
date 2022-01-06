/// Model for user
class UserQueueModel {
  /// Constructor
  const UserQueueModel({
    this.id = '',
    this.userId = '',
    this.name = '',
    this.createdDate = '',
    this.updatedDate = '',
    this.deletedDate = '',
    this.entity = '',
  });

  /// Initialization
  final String id, userId, name, createdDate, updatedDate, deletedDate, entity;

  /// A good thing.
  static UserQueueModel fromJson(Map<String, dynamic> json) => UserQueueModel(
        id: json['id'],
        userId: json['user_id'],
        name: json['name'],
        createdDate: json['created_date'],
        updatedDate: json['updated_date'],
        deletedDate: json['deleted_date'] ?? '',
        entity: json['__entity'],
      );
}
