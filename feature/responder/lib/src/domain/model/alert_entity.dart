import 'package:equatable/equatable.dart';
import 'package:responder/src/domain/model/responder_action.dart';

class Alert extends Equatable {
  final String uid;
  final DateTime sentAt;
  final AlertType alertType;
  final AlertStatus status;
  final String address;
  final String senderName;
  final List<ResponderAction> availableActions;

  const Alert({
    required this.uid,
    required this.sentAt,
    required this.alertType,
    required this.status,
    required this.address,
    required this.senderName,
    required this.availableActions,
  });

  factory Alert.empty() => Alert(
    uid: '',
    sentAt: DateTime.fromMillisecondsSinceEpoch(0),
    alertType: AlertType.unknown,
    address: '',
    senderName: '',
    status: AlertStatus.idle,
    availableActions: const [],
  );

  Alert copyWith({
    String? uid,
    DateTime? sentAt,
    AlertType? alertType,
    AlertStatus? status,
    String? address,
    String? senderName,
    List<ResponderAction>? availableActions,
  }) {
    return Alert(
      uid: uid ?? this.uid,
      sentAt: sentAt ?? this.sentAt,
      alertType: alertType ?? this.alertType,
      address: address ?? this.address,
      senderName: senderName ?? this.senderName,
      status: status ?? this.status,
      availableActions: availableActions ?? this.availableActions,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    sentAt,
    alertType,
    status,
    address,
    senderName,
    availableActions,
  ];
}

enum AlertType {
  pendantActivation('SOS pendant activation'),
  fire('Fire detected'),
  waterLeak('Water leak detected'),
  unknown('unknown');

  const AlertType(this.label);
  final String label;
  static AlertType fromString(String? value) => AlertType.values.firstWhere(
    (e) => e.label == value,
    orElse: () => AlertType.unknown,
  );
}

enum AlertStatus { idle, active, resolved }
