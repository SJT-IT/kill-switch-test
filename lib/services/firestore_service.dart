import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/command.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createCommand({
    required String deviceId,
    required String type,
    required bool value,
    required String issuedBy,
  }) async {
    final docRef = _db.collection("commands").doc();

    final command = Command(
      commandId: docRef.id,
      deviceId: deviceId,
      type: type,
      value: value,
      status: "pending",
      sentTimestamp: 0,
      receivedTimestamp: 0,
      issuedBy: issuedBy,
    );

    await docRef.set(command.toMap());

    return docRef.id;
  }
}
