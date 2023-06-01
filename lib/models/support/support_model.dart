class SupportListModel {
  String? id;
  String? userId;
  String? adminId;
  String? subject;
  String? description;
  String? status;
  String? createdDate;
  String? updatedDate;
  String? sEntity;

  SupportListModel(
      {this.id,
      this.userId,
      this.adminId,
      this.subject,
      this.description,
      this.status,
      this.createdDate,
      this.updatedDate,
      this.sEntity});

  SupportListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    adminId = json['admin_id'];
    subject = json['title'];
    description = json['message'];
    status = json['status'] ?? "";
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    sEntity = json['__entity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['admin_id'] = this.adminId;
    data['title'] = this.subject;
    data['message'] = this.description;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['__entity'] = this.sEntity;
    return data;
  }
}
