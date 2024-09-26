class Activity {
  dynamic id;
  dynamic usersId;
  dynamic type;
  dynamic date;
  dynamic time;
  dynamic status;
  dynamic roomId;
  dynamic idRoomForChat;
  dynamic createdAt;
  dynamic updatedAt;

  Activity(
      {this.id,
      this.usersId,
      this.type,
      this.date,
      this.time,
      this.status,
      this.roomId,
      this.idRoomForChat,
      this.createdAt,
      this.updatedAt});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['id_staff'];
    type = json['type'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    roomId = json['room_id'];
    idRoomForChat = json['idroom_for_chat'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users_id'] = this.usersId;
    data['type'] = this.type;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['room_id'] = this.roomId;
    data['idroom_for_chat'] = this.idRoomForChat;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
