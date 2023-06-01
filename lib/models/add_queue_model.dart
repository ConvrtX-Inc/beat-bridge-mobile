class AddQueueModel {
  String? id;
  String? userId;
  String? name;
  Null? platform;
  Null? queueData;
  String? image;
  String? createdDate;
  String? updatedDate;
  Null? deletedDate;
  String? sEntity;

  AddQueueModel(
      {this.id,
      this.userId,
      this.name,
      this.platform,
      this.queueData,
      this.image,
      this.createdDate,
      this.updatedDate,
      this.deletedDate,
      this.sEntity});

  AddQueueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    platform = json['platform'];
    queueData = json['queueData'];
    image = json['image'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    deletedDate = json['deleted_date'];
    sEntity = json['__entity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['platform'] = this.platform;
    data['queueData'] = this.queueData;
    
    data['image'] = this.image;

    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['deleted_date'] = this.deletedDate;
    data['__entity'] = this.sEntity;
    return data;
  }
}

class Image {
  String? type;
  List<int>? data;

  Image({this.type, this.data});

  Image.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['data'] = this.data;
    return data;
  }
}
