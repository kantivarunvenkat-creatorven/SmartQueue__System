// lib/screens/user/waiting_status_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../services/ai_chatbot_service.dart';
import '../../models/service_catalog.dart';

class WaitingStatusScreen extends StatefulWidget {
  final String tokenId;
  const WaitingStatusScreen({super.key, required this.tokenId});

  @override
  State<WaitingStatusScreen> createState() => _WaitingStatusScreenState();
}

class _WaitingStatusScreenState extends State<WaitingStatusScreen> {
  final _aiService = AiChatbotService();
  final _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendAiQuery(Map<String, dynamic> tokenData) async {
    final q = _chatController.text.trim();
    if (q.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': q});
      _chatController.clear();
    });

    final reply = await _aiService.processQuery(q, activeToken: tokenData);
    setState(() {
      _messages.add({'sender': 'ai', 'text': reply});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Queue Pass')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('tokens').doc(widget.tokenId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final token = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final tokenNumber = token['tokenNumber'] ?? 'H01';
          final status = token['status'] ?? 'waiting';
          final assignedCounter = token['assignedCounterName'] ?? 'Counter 1 (Hospital)';
          final category = token['serviceCategory'] ?? 'Hospital';
          final customerReason = token['reason'] as String? ?? '';
          final resolvedService = ServiceCatalog.resolveCounterForCategory(category);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Token Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryDark, AppTheme.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    children: [
                      const Text('Your Live Token', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 10),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30, width: 2),
                        ),
                        child: Center(
                          child: Text(tokenNumber, style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                        child: Text('Status: ${status[0].toUpperCase()}${status.substring(1)}',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 🚨 "AFTER 3 AHEAD" TURN ARRIVAL ALERT
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFE85D04), Color(0xFFDC2F02)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      const Text('🚨', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("AFTER 3 MEMBERS IT'S YOUR TURN!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text("Please reach allocated $assignedCounter now with your documents!", style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Counter Allocation & Customer Details Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.room_service_rounded, color: AppTheme.primary),
                            const SizedBox(width: 8),
                            const Text('Service & Desk Allocation', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          ],
                        ),
                        const Divider(height: 20),
                        Text('Category: $category', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('Desk: $assignedCounter', style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.w700, fontSize: 13)),
                        if (customerReason.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Customer Note: "$customerReason"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // AI Chatbot Assistant Widget
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.smart_toy_rounded, color: AppTheme.primaryLight),
                            SizedBox(width: 8),
                            Text('AI Virtual Assistant', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ..._messages.map((m) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: m['sender'] == 'user' ? Colors.grey.shade100 : AppTheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(m['text'] ?? '', style: const TextStyle(fontSize: 12)),
                            )),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _chatController,
                                decoration: const InputDecoration(
                                  hintText: 'Ask AI (e.g. How much time?)',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _sendAiQuery(token),
                              icon: const Icon(Icons.send_rounded, color: AppTheme.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
