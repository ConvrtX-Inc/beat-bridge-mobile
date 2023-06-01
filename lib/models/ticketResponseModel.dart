class TicketResponseModel {
  String? id;
  String? userId;
  String? message;
  String? title;
  String? status;
  String? createdDate;
  String? updatedDate;
  String? sEntity;

  TicketResponseModel(
      {this.id,
        this.userId,
        this.message,
        this.title,
        this.status,
        this.createdDate,
        this.updatedDate,
        this.sEntity});

  TicketResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    message = json['message'];
    title = json['title'];
    status = json['status'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    sEntity = json['__entity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['message'] = this.message;
    data['title'] = this.title;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['__entity'] = this.sEntity;
    return data;
  }
}
