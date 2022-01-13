/// Play List Class
// ignore_for_file: public_member_api_docs, sort_constructors_first

class PlayList {
  bool? collaborative;
  String? description;
  String? href;
  String? id;
  String? name;
  Owner? owner;
  bool? public;
  String? snapshotId;
  Tracks? tracks;
  String? type;
  String? uri;

  PlayList(
      {this.collaborative,
      this.description,
      this.href,
      this.id,
      this.name,
      this.owner,
      this.public,
      this.snapshotId,
      this.tracks,
      this.type,
      this.uri});

  PlayList.fromJson(Map<String, dynamic> json) {
    collaborative = json['collaborative'];
    description = json['description'];
    href = json['href'];
    id = json['id'];
    name = json['name'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    public = json['public'];
    snapshotId = json['snapshot_id'];
    tracks =
        json['tracks'] != null ? new Tracks.fromJson(json['tracks']) : null;
    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collaborative'] = this.collaborative;
    data['description'] = this.description;
    data['href'] = this.href;
    data['id'] = this.id;

    data['name'] = this.name;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    data['public'] = this.public;
    data['snapshot_id'] = this.snapshotId;
    if (this.tracks != null) {
      data['tracks'] = this.tracks!.toJson();
    }
    data['type'] = this.type;
    data['uri'] = this.uri;
    return data;
  }
}

class Owner {
  String? displayName;
  String? href;
  String? id;
  String? type;
  String? uri;

  Owner({this.displayName, this.href, this.id, this.type, this.uri});

  Owner.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    href = json['href'];
    id = json['id'];
    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    data['href'] = this.href;
    data['id'] = this.id;
    data['type'] = this.type;
    data['uri'] = this.uri;
    return data;
  }
}

class Tracks {
  String? href;
  int? total;

  Tracks({this.href, this.total});

  Tracks.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    data['total'] = this.total;
    return data;
  }
}
