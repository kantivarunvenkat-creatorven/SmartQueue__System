// lib/screens/user/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/service_catalog.dart';
import '../../theme/app_theme.dart';
import 'waiting_status_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  ServiceSector _selectedSector = ServiceCatalog.sectors.first;
  late ServiceItem _selectedService;
  final _customerNoteController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedService = _selectedSector.services.first;
  }

  Future<void> _generateToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      final tokenQuery = await FirebaseFirestore.instance.collection('tokens').get();
      final count = tokenQuery.docs.length + 1;
      final tokenNumber = '${_selectedService.tokenPrefix}${count.toString().padLeft(2, '0')}';

      final docRef = await FirebaseFirestore.instance.collection('tokens').add({
        'userId': user.uid,
        'userEmail': user.email ?? '',
        'tokenNumber': tokenNumber,
        'sector': _selectedSector.name,
        'serviceCategory': _selectedService.name,
        'assignedCounterName': _selectedService.defaultCounterName,
        'counterId': _selectedService.counterId,
        'reason': _customerNoteController.text.trim(),
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WaitingStatusScreen(tokenId: docRef.id)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating token: $e'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Live Queue')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('1. Select Service Sector', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            // Sector Selection Cards
            Row(
              children: ServiceCatalog.sectors.map((sec) {
                final isSelected = sec.id == _selectedSector.id;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSector = sec;
                        _selectedService = sec.services.first;
                      });
                    },
                    child: Card(
                      color: isSelected ? sec.color.withOpacity(0.12) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: isSelected ? sec.color : Colors.grey.shade300, width: isSelected ? 2 : 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Column(
                          children: [
                            Icon(sec.icon, color: sec.color, size: 28),
                            const SizedBox(height: 6),
                            Text(sec.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            const Text('2. Select Specific Service Desk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            // Sub-Services Dropdown/List
            ..._selectedSector.services.map((svc) {
              final isSelected = svc.id == _selectedService.id;
              return GestureDetector(
                onTap: () => setState(() => _selectedService = svc),
                child: Card(
                  color: isSelected ? AppTheme.primary.withOpacity(0.08) : Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: isSelected ? AppTheme.primary : Colors.grey.shade300, width: isSelected ? 2 : 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Icon(svc.icon, color: isSelected ? AppTheme.primary : AppTheme.textSecondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(svc.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(svc.description, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                                child: Text('Routes to: ${svc.defaultCounterName}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primaryDark)),
                              ),
                            ],
                          ),
                        ),
                        Radio<String>(
                          value: svc.id,
                          groupValue: _selectedService.id,
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedService = svc);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            const Text('3. Customer Description & Requirements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              controller: _customerNoteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: _selectedService.customerDetailsHint,
                hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _generateToken,
                icon: const Icon(Icons.qr_code_2_rounded),
                label: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Get Live Token (${_selectedService.tokenPrefix}##)', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
