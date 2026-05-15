class Command {
  final String commandId;
  final String deviceId;
  final String type;
  final bool value;

  final String status;

  final int sentTimestamp;
  final int receivedTimestamp;

  final String issuedBy;

  Command({
    required this.commandId,
    required this.deviceId,
    required this.type,
    required this.value,
    required this.status,
    required this.sentTimestamp,
    required this.receivedTimestamp,
    required this.issuedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      "commandId": commandId,
      "deviceId": deviceId,
      "type": type,
      "value": value,
      "status": status,
      "senttimestamp": sentTimestamp,
      "receivedtimestamp": receivedTimestamp,
      "issuedBy": issuedBy,
    };
  }
}
