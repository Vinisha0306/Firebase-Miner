class ChatModel {
  String msg, type, status;
  DateTime time;

  ChatModel(
    this.time,
    this.msg,
    this.type,
    this.status,
  );

  factory ChatModel.fromMap(Map data) => ChatModel(
        DateTime.fromMillisecondsSinceEpoch(
          int.parse(data['time'] ?? '123434535'),
        ),
        data['msg'] ?? '',
        data['type'] ?? '',
        data['status'] ?? '',
      );

  Map<String, dynamic> get toMap => {
        'time': time.millisecondsSinceEpoch.toString(),
        'msg': msg,
        'type': type,
        'status': status,
      };
}
