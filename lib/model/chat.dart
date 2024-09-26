class Chat {
  final String? userId;
  final String? idStaff;
  final String? room;
  final String? message;
  final String? date;
  final String? time;

  Chat({
    this.userId,
    this.idStaff,
    this.message,
    this.room,
    this.date,
    this.time,
  });

  factory Chat.fromRawJson(Map<String, dynamic> jsonData) {
    return Chat(
        userId: jsonData['uid'],
        idStaff: jsonData['idstaff'],
        message: jsonData['message'],
        room: jsonData['room'],
        date: jsonData['date'],
        time: jsonData['time']);
  }
  Map<String, dynamic> toJson() {
    return {
      "uid": userId,
      "idstaff": idStaff,
      "message": message,
      "room": room,
      "date": date,
      "time": time,
    };
  }
}
