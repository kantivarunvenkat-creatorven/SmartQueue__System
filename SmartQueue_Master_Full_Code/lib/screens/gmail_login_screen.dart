// lib/screens/gmail_login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import 'user/user_home_screen.dart';
import 'admin/admin_dashboard_screen.dart';

class GmailLoginScreen extends StatefulWidget {
  const GmailLoginScreen({super.key});

  @override
  State<GmailLoginScreen> createState() => _GmailLoginScreenState();
}

class _GmailLoginScreenState extends State<GmailLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isAdmin = false;
  bool _isSignUp = false;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || pass.isEmpty || (_isSignUp && name.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isSignUp) {
        final cred = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
        final uid = cred.user!.uid;

        if (_isAdmin) {
          await _firestore.collection('admins').doc(uid).set({
            'name': name,
            'email': email,
            'role': 'admin',
            'createdAt': FieldValue.serverTimestamp(),
          });
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
          }
        } else {
          await _firestore.collection('users').doc(uid).set({
            'name': name,
            'email': email,
            'role': 'customer',
            'createdAt': FieldValue.serverTimestamp(),
          });
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserHomeScreen()));
          }
        }
      } else {
        final cred = await _auth.signInWithEmailAndPassword(email: email, password: pass);
        final uid = cred.user!.uid;

        if (_isAdmin) {
          final doc = await _firestore.collection('admins').doc(uid).get();
          if (!doc.exists) {
            await _firestore.collection('admins').doc(uid).set({
              'email': email,
              'role': 'admin',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
          }
        } else {
          final doc = await _firestore.collection('users').doc(uid).get();
          if (!doc.exists) {
            await _firestore.collection('users').doc(uid).set({
              'email': email,
              'role': 'customer',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserHomeScreen()));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication error: ${e.toString()}'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryDark, AppTheme.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flash_on_rounded, size: 38, color: AppTheme.primary),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isAdmin ? 'Admin Portal' : 'SmartQueue',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.primaryDark),
                      ),
                      Text(
                        _isAdmin ? 'Realtime Queue Command System' : 'Intelligent Multi-Sector Queue Management',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 20),

                      // Role Switcher Tab
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isAdmin = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: !_isAdmin ? AppTheme.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text('Customer',
                                        style: TextStyle(
                                            color: !_isAdmin ? Colors.white : AppTheme.textSecondary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isAdmin = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _isAdmin ? AppTheme.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text('Admin',
                                        style: TextStyle(
                                            color: _isAdmin ? Colors.white : AppTheme.textSecondary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_isSignUp) ...[
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : Text(_isSignUp ? 'Create Account' : 'Sign In', style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      TextButton(
                        onPressed: () => setState(() => _isSignUp = !_isSignUp),
                        child: Text(
                          _isSignUp ? 'Already have an account? Sign In' : "Don't have an account? Sign Up",
                          style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
