import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'widgets/command_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMS Command Lab',
      debugShowCheckedModeBanner: false,

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),

      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// =========================
  /// RTDB REFERENCE
  /// =========================

  final DatabaseReference ref = FirebaseDatabase.instance.ref(
    "devices/device_001/commands",
  );

  /// =========================
  /// SEND COMMAND
  /// =========================

  Future<void> sendCommand(bool value) async {
    final newRef = ref.push();

    await newRef.set({
      "deviceId": "device_001",

      "type": "kill",

      "value": value,

      "status": "pending",

      "senttimestamp": DateTime.now().millisecondsSinceEpoch,

      "receivedtimestamp": 0,

      "issuedBy": "user_123",
    });

    debugPrint("🚀 Command sent: ${newRef.key}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kill Switch Monitor"),

        centerTitle: true,
      ),

      body: StreamBuilder<DatabaseEvent>(
        stream: ref.onValue,

        builder: (context, snapshot) {
          /// =========================
          /// EMPTY STATE
          /// =========================

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No Commands Yet"));
          }

          final raw = snapshot.data!.snapshot.value;

          if (raw is! Map) {
            return const Center(child: Text("Invalid Data Format"));
          }

          /// =========================
          /// SORT LATEST FIRST
          /// =========================

          final entries = raw.entries.toList();

          entries.sort((a, b) {
            final aTime = a.value['senttimestamp'] ?? 0;

            final bTime = b.value['senttimestamp'] ?? 0;

            return bTime.compareTo(aTime);
          });

          /// =========================
          /// LATEST COMMAND
          /// =========================

          final latest = entries.first.value as Map;

          final bool currentValue = latest['value'] ?? false;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),

              child: CommandCard(
                commands: entries,

                onToggle: () async {
                  /// INVERSE CURRENT STATE

                  await sendCommand(!currentValue);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
