// lib/screens/user/user_home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../../models/service_catalog.dart';
import 'registration_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@').first ?? 'Customer';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $userName'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.primaryDark, AppTheme.primary]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('SmartQueue Hub', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                        SizedBox(height: 6),
                        Text('Instant QR tokens, live turn updates & smart counter allocation across 4 sectors.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.qr_code_scanner_rounded, size: 48, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Explore Service Sectors', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            // Sector Cards
            ...ServiceCatalog.sectors.map((sec) {
              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: sec.color.withOpacity(0.12), shape: BoxShape.circle),
                    child: Icon(sec.icon, color: sec.color, size: 26),
                  ),
                  title: Text(sec.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  subtitle: Text(sec.subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen()));
                  },
                ),
              );
            }),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen())),
                icon: const Icon(Icons.add_circle_outline_rounded),
                label: const Text('Get Live Queue Token Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
