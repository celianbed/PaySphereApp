
class Notification {

  final int id;
  final String clientId;
  final String typeNotification;
  final int message;
  final String date;


  Notification({
    required this.id,
    required this.clientId,
    required this.typeNotification,
    required this.message,
    required this.date,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      clientId: json['client_id'],
      typeNotification: json['type_notification'],
      message: json['message'],
      date: json['date_envoi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'type_notification': typeNotification,
      'message': message,
      'date_envoi': date,
    };
  }

}
