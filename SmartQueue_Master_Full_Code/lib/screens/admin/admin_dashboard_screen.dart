// lib/screens/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Command Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tokens').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          final waitingTokens = docs.where((d) => (d.data() as Map)['status'] == 'waiting').toList();
          final servingTokens = docs.where((d) => (d.data() as Map)['status'] == 'serving').toList();
          final completedTokens = docs.where((d) => (d.data() as Map)['status'] == 'completed').toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI Metric Cards
                Row(
                  children: [
                    _buildKpiCard('Waiting', waitingTokens.length.toString(), Colors.orange, Icons.hourglass_top_rounded),
                    const SizedBox(width: 12),
                    _buildKpiCard('Serving', servingTokens.length.toString(), AppTheme.primary, Icons.play_circle_fill_rounded),
                    const SizedBox(width: 12),
                    _buildKpiCard('Completed', completedTokens.length.toString(), AppTheme.success, Icons.check_circle_rounded),
                  ],
                ),
                const SizedBox(height: 24),

                const Text('Live Active Queue Desk Streams', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),

                if (waitingTokens.isEmpty && servingTokens.isEmpty)
                  const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('No active queue tokens right now.'))),

                ...docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final tokenNumber = data['tokenNumber'] ?? 'H01';
                  final status = data['status'] ?? 'waiting';
                  final assignedCounter = data['assignedCounterName'] ?? 'Counter 1';
                  final category = data['serviceCategory'] ?? 'Hospital';
                  final reason = data['reason'] as String? ?? '';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.between,
                            children: [
                              Text(tokenNumber, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primaryDark)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: status == 'serving' ? Colors.blue.shade100 : (status == 'completed' ? Colors.green.shade100 : Colors.orange.shade100),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(status.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Category: $category', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text('Station: $assignedCounter', style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                          if (reason.isNotEmpty)
                            Text('Customer Note: "$reason"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.textSecondary)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              if (status == 'waiting')
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                                    onPressed: () => doc.reference.update({'status': 'serving'}),
                                    child: const Text('Call / Serve Now', style: TextStyle(fontSize: 12)),
                                  ),
                                ),
                              if (status == 'serving')
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                                    onPressed: () => doc.reference.update({'status': 'completed'}),
                                    child: const Text('Complete Service', style: TextStyle(fontSize: 12)),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
