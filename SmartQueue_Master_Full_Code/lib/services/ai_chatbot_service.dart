// lib/services/ai_chatbot_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_catalog.dart';

class AiChatbotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> processQuery(String query, {String? userId, Map<String, dynamic>? activeToken}) async {
    final lower = query.toLowerCase().trim();

    // ── 1. ACTIVE TOKEN & TURN STATUS ────────────────────────────────────────
    if (lower.contains('turn') || lower.contains('time') || lower.contains('wait') || lower.contains('status') || lower.contains('queue')) {
      if (activeToken != null) {
        final tokenNumber = activeToken['tokenNumber'] ?? 'H01';
        final status = activeToken['status'] ?? 'waiting';
        final assignedCounter = activeToken['assignedCounterName'] ?? 'Counter 1';
        final category = activeToken['serviceCategory'] ?? 'Hospital';

        if (status == 'serving') {
          return "📢 IT'S YOUR TURN NOW! Your token $tokenNumber is currently being called at $assignedCounter ($category). Please proceed to the desk immediately!";
        } else if (status == 'completed') {
          return "✅ Your token $tokenNumber has been completed. Thank you for using SmartQueue! Please feel free to leave a 5-star rating.";
        } else {
          int peopleAhead = 3;
          try {
            final snap = await _firestore.collection('tokens')
                .where('status', isEqualTo: 'waiting')
                .get();
            peopleAhead = snap.docs.length;
          } catch (_) {}

          if (peopleAhead <= 3 && peopleAhead > 0) {
            return "🚨 GET READY! AFTER $peopleAhead MEMBERS IT'S YOUR TURN!\n\nYour Token: $tokenNumber\nAllocated Desk: $assignedCounter\nCategory: $category\nEstimated Wait: ~${peopleAhead * 2} mins\n\nPlease reach near $assignedCounter now with your documents/items!";
          } else {
            return "🎫 Your Live Token: $tokenNumber\nAllocated Desk: $assignedCounter\nCategory: $category\nMembers Ahead: $peopleAhead people\nEstimated Time: ~${peopleAhead * 2} minutes\n\nWe will alert you when you have 3 or fewer members ahead!";
          }
        }
      }
    }

    // ── 2. HOSPITAL & DOCTORS ────────────────────────────────────────────────
    if (lower.contains('cancer') || lower.contains('oncolog')) {
      return "🏥 Cancer Specialist (Oncology) Doctor:\n\n• Location: Counter 1 (Oncology & Cancer Care)\n• Services: Senior Oncologist consultation, Biopsy reviews, Chemotherapy guidance & Scan review.\n• Documents to bring: Previous biopsy/histology reports, PET-CT scans, Blood work & Prescription history.";
    }
    if (lower.contains('heart') || lower.contains('cardio')) {
      return "❤️ Heart Specialist (Cardiology) Doctor:\n\n• Location: Counter 1 (Cardiology & Heart Care)\n• Services: ECG review, 2D Echo, Blood Pressure check, Angiography consultation.\n• Documents to bring: Recent ECG strips, Lipid profile reports & current cardiac medicines.";
    }
    if (lower.contains('brain') || lower.contains('neuro')) {
      return "🧠 Brain & Nerve Specialist (Neurology):\n\n• Location: Counter 1 (Neurology & Spine Care)\n• Services: Migraine, Epilepsy/Seizures, Stroke rehab, Nerve conduction tests.";
    }
    if (lower.contains('bone') || lower.contains('ortho') || lower.contains('joint')) {
      return "🦴 Bone & Joint Specialist (Orthopedics):\n\n• Location: Counter 1 (Orthopedics & Joint Clinic)\n• Services: Knee arthritis, Fractures, Spine disc pain, Ligament tears.";
    }

    // ── 3. CITIZEN SERVICE CENTER ────────────────────────────────────────────
    if (lower.contains('aadhaar') || lower.contains('aadhar')) {
      return "🏢 Aadhaar Card Services:\n\n• Location: Counter 2 (Aadhaar & Biometrics Desk)\n• Updations Available: Mobile number link, Biometrics/Fingerprint update, Address change, Photo update.\n• Required Documents: Original Aadhaar letter, Proof of Address (Electricity bill/Voter ID), and active mobile phone for OTP.";
    }
    if (lower.contains('pan')) {
      return "💳 PAN Card Services:\n\n• Location: Counter 2 (PAN & Tax Documents)\n• Services: New PAN Application (Form 49A), Name/DOB correction, Physical card reprint.\n• Required Documents: Aadhaar card (e-KYC) and 2 passport-size photographs.";
    }
    if (lower.contains('passport') || lower.contains('visa')) {
      return "✈️ Passport & Visa Services:\n\n• Location: Counter 2 (Passport & Visa Verification)\n• Services: Fresh Passport submission, Tatkaal re-issue, Police clearance certificate (PCC).";
    }

    // ── 4. GENERAL STORE & PROVISIONS ────────────────────────────────────────
    if (lower.contains('maida') || lower.contains('sugar') || lower.contains('wheat') || lower.contains('rice') || lower.contains('grain')) {
      return "🛒 General Store Provisions (Grains & Flours):\n\n• Location: Counter 3 (Grains, Sugar & Provisions)\n• Items in Stock: Fresh Maida, Pure Cane Sugar, Sharbati Wheat Atta, Basmati Rice & Pulses.\n• Express checkout with live digital token!";
    }
    if (lower.contains('soap') || lower.contains('detergent') || lower.contains('shampoo')) {
      return "🧼 Personal Care & Soaps:\n\n• Location: Counter 3 (Personal Care & Soaps)\n• Items: Bath soaps, Washing powders, Handwashes, Shampoos & Floor cleaners.";
    }

    // ── 5. BANK & FINANCIAL SERVICES ─────────────────────────────────────────
    if (lower.contains('phone') && (lower.contains('bank') || lower.contains('account') || lower.contains('link'))) {
      return "🏦 Phone Number Link to Bank Account:\n\n• Location: Counter 4 (Phone & Mobile Banking Link)\n• Process: Fill mobile update mandate form, submit Aadhaar copy, and verify biometric OTP.\n• Activation: Activated within 24 hours for SMS & UPI alerts.";
    }
    if (lower.contains('account') && lower.contains('open')) {
      return "🏦 New Bank Account Opening:\n\n• Location: Counter 4 (New Account & Onboarding)\n• Options: Zero-Balance Digital Savings, Regular Savings, Current Account.\n• Required Documents: Aadhaar card, PAN card, and 2 passport photos.";
    }

    // ── DEFAULT AI BOT RESPONSE ──────────────────────────────────────────────
    return "🤖 SmartQueue AI Assistant:\n\nI can help you with:\n1. 🏥 Hospital: Cancer doctor, Heart doctor, Neurology, Orthopedics & OPD\n2. 🏢 Citizen Services: Aadhaar update, PAN changes, Passport & Certificates\n3. 🛒 General Store: Maida, Sugar, Wheat, Soaps, Snacks & Dairy\n4. 🏦 Bank: Account opening, Phone number link, KYC & Loans\n5. ⏱️ Turn Status: Ask 'How much time for my turn?'";
  }
}
