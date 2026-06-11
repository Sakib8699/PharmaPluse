class ConsultationMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isVideo;

  ConsultationMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isVideo = false,
  });

  factory ConsultationMessage.fromJson(Map<String, dynamic> json) {
    return ConsultationMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isVideo: json['isVideo'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isVideo': isVideo,
    };
  }
}

class Consultation {
  final String id;
  final String customerId;
  final String customerName;
  final String? pharmacistId;
  final String? pharmacistName;
  final String topic;
  final String description;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String status; // pending, active, completed, cancelled
  final List<ConsultationMessage> messages;
  final String consultationType; // chat, video, phone

  Consultation({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.pharmacistId,
    this.pharmacistName,
    required this.topic,
    required this.description,
    required this.createdAt,
    this.startedAt,
    this.endedAt,
    this.status = 'pending',
    this.messages = const [],
    this.consultationType = 'chat',
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      pharmacistId: json['pharmacistId'] as String?,
      pharmacistName: json['pharmacistName'] as String?,
      topic: json['topic'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      status: json['status'] as String? ?? 'pending',
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map(
                (e) => ConsultationMessage.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      consultationType: json['consultationType'] as String? ?? 'chat',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'pharmacistId': pharmacistId,
      'pharmacistName': pharmacistName,
      'topic': topic,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'status': status,
      'messages': messages.map((e) => e.toJson()).toList(),
      'consultationType': consultationType,
    };
  }
}
