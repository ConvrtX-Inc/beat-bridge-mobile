import 'package:beatbridge/models/users/user_model.dart';

/// Model for user
class QueueMemberModel {
  /// Constructor
  QueueMemberModel({
    this.id = '',
    this.userQueueId = '',
    this.userId = '',
    this.isAdmin = false,
    this.createdDate = '',
    this.updatedDate = '',
    this.entity = '',
    this.user = const UserModelTwo(),
  });

  ///user details
  final UserModelTwo user;

  /// Initialization
  final String id;

  /// Initialization
  final String userQueueId;

  /// Initialization
  final String userId;

  /// Initialization
  bool isAdmin;

  /// Initialization
  final String createdDate;

  /// Initialization
  final String updatedDate;

  /// Initialization
  final String entity;

  /// A good thing.
  static QueueMemberModel fromJson(Map<String, dynamic> json) =>
      QueueMemberModel(
        id: json['id'] ?? 0,
        userQueueId: json['user_queue_id'] ?? 0,
        userId: json['user_id'] ?? 0,
        isAdmin: json['is_admin'],
        createdDate: json['created_date'],
        updatedDate: json['updated_date'] ?? '',
        entity: json['__entity'],
        user: UserModelTwo.fromJson(json),
      );
}
