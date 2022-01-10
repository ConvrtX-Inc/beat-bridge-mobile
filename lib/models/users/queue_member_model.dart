/// Model for user
class QueueMemberModel {
  /// Constructor
  const QueueMemberModel({
    this.id = '',
    this.userQueueId = '',
    this.userId = '',
    this.isAdmin = false,
    this.createdDate = '',
    this.updatedDate = '',
    this.entity = '',
  });

  /// Initialization
  final String id;

  /// Initialization
  final String userQueueId;

  /// Initialization
  final String userId;

  /// Initialization
  final bool isAdmin;

  /// Initialization
  final String createdDate;

  /// Initialization
  final String updatedDate;

  /// Initialization
  final String entity;

  /// A good thing.
  static QueueMemberModel fromJson(Map<String, dynamic> json) =>
      QueueMemberModel(
        id: json['id'],
        userQueueId: json['user_queue_id'],
        userId: json['user_id'],
        isAdmin: json['is_admin'],
        createdDate: json['created_date'],
        updatedDate: json['updated_date'] ?? '',
        entity: json['__entity'],
      );
}
