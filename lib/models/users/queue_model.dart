import 'dart:convert';

import 'package:beatbridge/models/users/user_model.dart';

/// Model for user
class QueueModel {
  /// Constructor
  const QueueModel({
    this.id = '',
    this.userId = '',
    this.name = '',
    this.createdDate = '',
    this.updatedDate = '',
    this.deletedDate = '',
    this.entity = '',
    this.creator = const UserModel(),
  });

  /// Initialization
  final String id, userId, name, createdDate, updatedDate, deletedDate, entity;

  ///creator details
  final UserModel creator;

  /// A good thing.
  static QueueModel fromJson(Map<String, dynamic> json) {
    return QueueModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
      deletedDate: json['deleted_date'] ?? '',
      entity: json['__entity'],
      creator: UserModel.fromJson(json),
    );
  }
}

/// Model for user
class QueueCreator {
  /// Constructor
  const QueueCreator({
    this.id = '',
    this.username = '',
    this.email = '',
  });

  /// Initialization
  final String id, username, email;

  /// A good thing.
  static QueueCreator fromJson(Map<dynamic, dynamic> json) {
    print(json);
    return QueueCreator(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
