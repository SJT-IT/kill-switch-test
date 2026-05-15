import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommandCard extends StatelessWidget {
  final List<MapEntry<dynamic, dynamic>> commands;
  final VoidCallback onToggle;

  const CommandCard({
    super.key,
    required this.commands,
    required this.onToggle,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;

      case "sent":
        return Colors.blue;

      case "received":
        return Colors.green;

      case "failed":
        return Colors.red;

      case "timeout":
        return Colors.deepOrange;

      default:
        return Colors.grey;
    }
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null || timestamp == 0) {
      return "--";
    }

    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp as int);

      return DateFormat('hh:mm:ss a').format(date);
    } catch (e) {
      return "--";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (commands.isEmpty) {
      return const Center(child: Text("No Commands Found"));
    }

    /// =========================
    /// LATEST COMMAND
    /// =========================

    final latest = commands.first.value as Map;

    final status = latest['status'] ?? "unknown";

    final bool isActive = latest['value'] ?? false;

    final sentTime = formatTimestamp(latest['senttimestamp']);

    final receivedTime = formatTimestamp(latest['receivedtimestamp']);

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),

      color: const Color(0xFF1E1E1E),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// =========================
            /// HEADER
            /// =========================
            Row(
              children: const [
                Icon(
                  Icons.power_settings_new,
                  color: Colors.redAccent,
                  size: 28,
                ),

                SizedBox(width: 10),

                Text(
                  "KILL SWITCH",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// =========================
            /// DEVICE INFO
            /// =========================
            Text(
              "Device: ${latest['deviceId']}",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            ),

            const SizedBox(height: 20),

            /// =========================
            /// STATUS CHIP
            /// =========================
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: getStatusColor(status).withAlpha(38),

                  borderRadius: BorderRadius.circular(30),

                  border: Border.all(color: getStatusColor(status), width: 1.5),
                ),

                child: Text(
                  status.toUpperCase(),

                  style: TextStyle(
                    color: getStatusColor(status),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            /// =========================
            /// TIMESTAMPS
            /// =========================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Sent",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      sentTime,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      "ACK",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      receivedTime,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// =========================
            /// ACTION BUTTON
            /// =========================
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: status == "pending" ? null : onToggle,

                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? Colors.redAccent : Colors.green,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: Text(
                  isActive ? "DISABLE" : "ACTIVATE",

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Divider(color: Colors.grey.shade800),

            const SizedBox(height: 14),

            /// =========================
            /// RECENT COMMANDS HEADER
            /// =========================
            const Text(
              "Recent Commands",

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            /// =========================
            /// RECENT COMMAND FEED
            /// =========================
            ...commands.take(4).map((entry) {
              final item = entry.value as Map;

              final itemStatus = item['status'] ?? "unknown";

              final itemTime = formatTimestamp(item['senttimestamp']);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),

                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: getStatusColor(itemStatus),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        itemStatus.toUpperCase(),

                        style: TextStyle(
                          color: getStatusColor(itemStatus),

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Text(
                      itemTime,

                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
