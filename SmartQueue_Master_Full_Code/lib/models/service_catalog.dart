// lib/models/service_catalog.dart
import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String name;
  final String description;
  final String customerDetailsHint;
  final IconData icon;
  final String sector;
  final String defaultCounterName;
  final int counterId;
  final String tokenPrefix;
  final int avgServiceMinutes;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.customerDetailsHint,
    required this.icon,
    required this.sector,
    required this.defaultCounterName,
    required this.counterId,
    required this.tokenPrefix,
    this.avgServiceMinutes = 5,
  });
}

class ServiceSector {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<ServiceItem> services;

  const ServiceSector({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.services,
  });
}

class ServiceCatalog {
  static const List<ServiceSector> sectors = [
    // ── 1. HOSPITAL ──────────────────────────────────────────────────────────
    ServiceSector(
      id: 'hospital',
      name: 'Hospital',
      subtitle: 'Doctor Consultations, Oncology, Cardiology & OPD',
      icon: Icons.local_hospital_rounded,
      color: Color(0xFFE63946),
      services: [
        ServiceItem(
          id: 'cancer_care',
          name: 'Cancer Specialist (Oncology)',
          description: 'Consultation with senior cancer oncologist, biopsy reviews & treatment planning',
          customerDetailsHint: 'Enter patient history, cancer stage or previous scan report details...',
          icon: Icons.healing_rounded,
          sector: 'Hospital',
          defaultCounterName: 'Counter 1 (Oncology & Cancer Care)',
          counterId: 1,
          tokenPrefix: 'H',
          avgServiceMinutes: 8,
        ),
        ServiceItem(
          id: 'heart_care',
          name: 'Heart Specialist (Cardiology)',
          description: 'ECG, heart rate checkup, blood pressure & cardiology doctor consultation',
          customerDetailsHint: 'Enter symptoms (chest pain, BP, palpitations) or pacemaker status...',
          icon: Icons.favorite_rounded,
          sector: 'Hospital',
          defaultCounterName: 'Counter 1 (Cardiology & Heart Care)',
          counterId: 1,
          tokenPrefix: 'H',
          avgServiceMinutes: 7,
        ),
        ServiceItem(
          id: 'brain_care',
          name: 'Brain & Nerve Specialist (Neurology)',
          description: 'Neurology consultation, headache, seizures, migraine & nerve treatments',
          customerDetailsHint: 'Enter neurological symptoms (headaches, nerve pain, seizures)...',
          icon: Icons.psychology_rounded,
          sector: 'Hospital',
          defaultCounterName: 'Counter 1 (Neurology & Spine Care)',
          counterId: 1,
          tokenPrefix: 'H',
          avgServiceMinutes: 7,
        ),
        ServiceItem(
          id: 'ortho_care',
          name: 'Bone & Joint Specialist (Orthopedics)',
          description: 'Arthritis, joint pain, bone fracture treatment & orthopedic surgeon review',
          customerDetailsHint: 'Enter bone/joint area (knee pain, fracture, spine) or injury details...',
          icon: Icons.accessibility_new_rounded,
          sector: 'Hospital',
          defaultCounterName: 'Counter 1 (Orthopedics & Joint Clinic)',
          counterId: 1,
          tokenPrefix: 'H',
          avgServiceMinutes: 6,
        ),
        ServiceItem(
          id: 'general_med',
          name: 'General Medicine & Fevers',
          description: 'General doctor consultation for viral fevers, infection, cold, cough & health checkup',
          customerDetailsHint: 'Enter symptoms (fever days, cough, headache, body pain)...',
          icon: Icons.medication_rounded,
          sector: 'Hospital',
          defaultCounterName: 'Counter 1 (General Medicine & OPD)',
          counterId: 1,
          tokenPrefix: 'H',
          avgServiceMinutes: 4,
        ),
        ServiceItem(
          id: 'pediatric',
          name: 'Pediatrician (Child Specialist)',
          description: 'Newborn & child health checkup, pediatric vaccination & child fever care',
          customerDetailsHint: 'Enter child age, vaccination required or sickness symptoms...',
          icon: Icons.child_care_rounded,
          sector: 'Hospital',
          defaultCounterName: 'Counter 1 (Pediatric & Child Care)',
          counterId: 1,
          tokenPrefix: 'H',
          avgServiceMinutes: 5,
        ),
        ServiceItem(
          id: 'dental_care',
          name: 'Dental & Oral Care',
          description: 'Teeth cleaning, root canal, cavity filling & oral doctor checkup',
          customerDetailsHint: 'Enter tooth issue (toothache, cleaning, extraction, braces)...',
          icon: Icons.clean_hands_rounded,
          sector: 'Hospital',
          defaultCounterName: 'Counter 1 (Dental & Oral Clinic)',
          counterId: 1,
          tokenPrefix: 'H',
          avgServiceMinutes: 6,
        ),
      ],
    ),

    // ── 2. CITIZEN SERVICE CENTER ────────────────────────────────────────────
    ServiceSector(
      id: 'service_center',
      name: 'Citizen Service Center',
      subtitle: 'Aadhaar, PAN, Passport & Govt Certificates',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF0077B6),
      services: [
        ServiceItem(
          id: 'aadhaar_update',
          name: 'Aadhaar Card Enrollment & Updation',
          description: 'Biometric update, mobile number linking, address change & new Aadhaar enrollment',
          customerDetailsHint: 'Enter update type (Phone link, Address change, Biometric, Photo)...',
          icon: Icons.fingerprint_rounded,
          sector: 'Citizen Service Center',
          defaultCounterName: 'Counter 2 (Aadhaar & Biometrics Desk)',
          counterId: 2,
          tokenPrefix: 'S',
          avgServiceMinutes: 5,
        ),
        ServiceItem(
          id: 'pan_changes',
          name: 'PAN Card Application & Changes',
          description: 'New PAN Card (Form 49A), name/date of birth correction & reprint physical card',
          customerDetailsHint: 'Enter requirement (New PAN, Name correction, Reprint card)...',
          icon: Icons.badge_rounded,
          sector: 'Citizen Service Center',
          defaultCounterName: 'Counter 2 (PAN & Tax Documents)',
          counterId: 2,
          tokenPrefix: 'S',
          avgServiceMinutes: 4,
        ),
        ServiceItem(
          id: 'passport_services',
          name: 'Passport & Visa Services',
          description: 'Fresh passport application, reissue, police verification slot & visa assistance',
          customerDetailsHint: 'Enter requirement (Fresh passport, Tatkaal, Renewal, PCC)...',
          icon: Icons.flight_takeoff_rounded,
          sector: 'Citizen Service Center',
          defaultCounterName: 'Counter 2 (Passport & Visa Verification)',
          counterId: 2,
          tokenPrefix: 'S',
          avgServiceMinutes: 6,
        ),
        ServiceItem(
          id: 'voter_license',
          name: 'Voter ID & Driving License',
          description: 'New voter card (Form 6), driving license renewal & address transfer',
          customerDetailsHint: 'Enter service (Learner license, DL Renewal, Voter ID update)...',
          icon: Icons.drive_eta_rounded,
          sector: 'Citizen Service Center',
          defaultCounterName: 'Counter 2 (Transport & Voter Services)',
          counterId: 2,
          tokenPrefix: 'S',
          avgServiceMinutes: 5,
        ),
        ServiceItem(
          id: 'income_caste_cert',
          name: 'Income, Caste & Residence Certificate',
          description: 'State government revenue certificates for education, scholarships & jobs',
          customerDetailsHint: 'Enter certificate type (Income, Caste, Residence, EWS)...',
          icon: Icons.description_rounded,
          sector: 'Citizen Service Center',
          defaultCounterName: 'Counter 2 (Revenue & State Certificates)',
          counterId: 2,
          tokenPrefix: 'S',
          avgServiceMinutes: 4,
        ),
        ServiceItem(
          id: 'ration_card',
          name: 'Ration Card & Welfare Services',
          description: 'Food security ration card member addition, surrender & subsidy registration',
          customerDetailsHint: 'Enter details (Add family member, Split card, Address change)...',
          icon: Icons.rice_bowl_rounded,
          sector: 'Citizen Service Center',
          defaultCounterName: 'Counter 2 (Food Security & Welfare Desk)',
          counterId: 2,
          tokenPrefix: 'S',
          avgServiceMinutes: 4,
        ),
      ],
    ),

    // ── 3. GENERAL STORE / SUPERMARKET ───────────────────────────────────────
    ServiceSector(
      id: 'general_store',
      name: 'General Store',
      subtitle: 'Provisions, Flour, Sugar, Soaps & Snacks',
      icon: Icons.storefront_rounded,
      color: Color(0xFFE85D04),
      services: [
        ServiceItem(
          id: 'grains_flour',
          name: 'Grains & Flours (Maida, Sugar, Wheat, Rice)',
          description: 'Bulk raw provisions: Maida (All-Purpose Flour), Sugar, Wheat Atta, Basmati Rice & Pulses',
          customerDetailsHint: 'Enter quantities needed (e.g. 5kg Maida, 2kg Sugar, 10kg Wheat, 25kg Rice)...',
          icon: Icons.grain_rounded,
          sector: 'General Store',
          defaultCounterName: 'Counter 3 (Grains, Sugar & Provisions)',
          counterId: 3,
          tokenPrefix: 'G',
          avgServiceMinutes: 4,
        ),
        ServiceItem(
          id: 'soaps_care',
          name: 'Personal Care & Soaps (Soaps, Detergents, Shampoos)',
          description: 'Bath soaps, laundry detergents, floor cleaners, dishwashing bars, shampoos & dental pastes',
          customerDetailsHint: 'List items (e.g. Bath soaps pack, Detergent powder, Handwash, Shampoo)...',
          icon: Icons.soap_rounded,
          sector: 'General Store',
          defaultCounterName: 'Counter 3 (Personal Care & Soaps)',
          counterId: 3,
          tokenPrefix: 'G',
          avgServiceMinutes: 3,
        ),
        ServiceItem(
          id: 'snacks_beverages',
          name: 'Snacks & Beverages (Snacks, Biscuits, Tea, Drinks)',
          description: 'Packaged chips, cookies, instant noodles, tea powder, coffee, cold drinks & juices',
          customerDetailsHint: 'List items (e.g. Biscuits, Tea powder 500g, Chips, Soft drinks)...',
          icon: Icons.fastfood_rounded,
          sector: 'General Store',
          defaultCounterName: 'Counter 3 (Snacks & Packaged Food)',
          counterId: 3,
          tokenPrefix: 'G',
          avgServiceMinutes: 3,
        ),
        ServiceItem(
          id: 'dairy_bakery',
          name: 'Dairy & Bakery (Milk, Bread, Eggs, Butter)',
          description: 'Fresh milk pouches, sandwich bread, eggs tray, paneer, curd, cheese & butter',
          customerDetailsHint: 'List items (e.g. 2 Milk packets, Brown bread, 1 Dozen eggs, 200g Butter)...',
          icon: Icons.egg_rounded,
          sector: 'General Store',
          defaultCounterName: 'Counter 3 (Dairy & Fresh Bakery)',
          counterId: 3,
          tokenPrefix: 'G',
          avgServiceMinutes: 2,
        ),
        ServiceItem(
          id: 'spices_oils',
          name: 'Spices, Cooking Oils & Household Essentials',
          description: 'Sunflower oil, mustard, turmeric, chili powder, garam masala, salt & kitchen disposables',
          customerDetailsHint: 'List items (e.g. 1L Sunflower oil, Chili powder 200g, Salt 1kg)...',
          icon: Icons.kitchen_rounded,
          sector: 'General Store',
          defaultCounterName: 'Counter 3 (Spices & Cooking Essentials)',
          counterId: 3,
          tokenPrefix: 'G',
          avgServiceMinutes: 3,
        ),
      ],
    ),

    // ── 4. BANK & FINANCIAL SERVICES ─────────────────────────────────────────
    ServiceSector(
      id: 'bank',
      name: 'Bank',
      subtitle: 'Accounts, Phone/PAN Linking, Cash & Loans',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF2A9D8F),
      services: [
        ServiceItem(
          id: 'account_creation',
          name: 'New Bank Account Opening',
          description: 'Savings account, current account, salary account & digital zero-balance opening',
          customerDetailsHint: 'Enter account type (Savings, Current, Student) & initial deposit plan...',
          icon: Icons.person_add_rounded,
          sector: 'Bank',
          defaultCounterName: 'Counter 4 (New Account & Onboarding)',
          counterId: 4,
          tokenPrefix: 'B',
          avgServiceMinutes: 6,
        ),
        ServiceItem(
          id: 'phone_link',
          name: 'Phone Number Link to Account',
          description: 'Update mobile number for OTPs, SMS transaction alerts & mobile banking activation',
          customerDetailsHint: 'Enter account number (last 4 digits) & new phone number to be linked...',
          icon: Icons.phone_android_rounded,
          sector: 'Bank',
          defaultCounterName: 'Counter 4 (Phone & Mobile Banking Link)',
          counterId: 4,
          tokenPrefix: 'B',
          avgServiceMinutes: 4,
        ),
        ServiceItem(
          id: 'pan_link',
          name: 'PAN & Aadhaar KYC Link to Account',
          description: 'Biometric e-KYC compliance, PAN card seeding & annual account re-KYC',
          customerDetailsHint: 'Enter KYC request (Aadhaar link, PAN seed, Re-KYC verification)...',
          icon: Icons.verified_user_rounded,
          sector: 'Bank',
          defaultCounterName: 'Counter 4 (KYC & Document Verification)',
          counterId: 4,
          tokenPrefix: 'B',
          avgServiceMinutes: 4,
        ),
        ServiceItem(
          id: 'cash_services',
          name: 'Cash Deposit & Withdrawal',
          description: 'Teller counter for cash deposit, high-value cash withdrawal & cheque clearance',
          customerDetailsHint: 'Enter transaction type (Deposit / Withdrawal amount or Cheque deposit)...',
          icon: Icons.payments_rounded,
          sector: 'Bank',
          defaultCounterName: 'Counter 4 (Cashier & Teller Desk)',
          counterId: 4,
          tokenPrefix: 'B',
          avgServiceMinutes: 3,
        ),
        ServiceItem(
          id: 'loans_fd',
          name: 'Personal, Business & Home Loans / FD',
          description: 'Fixed deposit opening, recurring deposit, personal loan, gold loan & home loan consultation',
          customerDetailsHint: 'Enter loan type (Personal, Gold, Home, Business) or FD investment tenure...',
          icon: Icons.real_estate_agent_rounded,
          sector: 'Bank',
          defaultCounterName: 'Counter 4 (Loans & Fixed Deposits)',
          counterId: 4,
          tokenPrefix: 'B',
          avgServiceMinutes: 7,
        ),
        ServiceItem(
          id: 'card_services',
          name: 'ATM & Debit / Credit Card Services',
          description: 'New ATM card request, PIN generation, green PIN, block lost card & credit limit upgrade',
          customerDetailsHint: 'Enter service (New Debit Card, Credit Card application, PIN generation)...',
          icon: Icons.credit_card_rounded,
          sector: 'Bank',
          defaultCounterName: 'Counter 4 (Cards & Digital Services)',
          counterId: 4,
          tokenPrefix: 'B',
          avgServiceMinutes: 4,
        ),
      ],
    ),
  ];

  static List<String> get allServiceNames {
    final list = <String>[];
    for (final sector in sectors) {
      for (final s in sector.services) {
        list.add(s.name);
      }
    }
    return list;
  }

  static ServiceItem? findService(String name) {
    for (final sector in sectors) {
      for (final s in sector.services) {
        if (s.name.toLowerCase() == name.toLowerCase() ||
            s.id.toLowerCase() == name.toLowerCase() ||
            name.toLowerCase().contains(s.name.toLowerCase())) {
          return s;
        }
      }
    }
    return null;
  }

  static ServiceItem resolveCounterForCategory(String category) {
    final found = findService(category);
    if (found != null) return found;

    final lower = category.toLowerCase();
    if (lower.contains('cancer') || lower.contains('heart') || lower.contains('doctor') ||
        lower.contains('hospital') || lower.contains('pediatric') || lower.contains('dental') ||
        lower.contains('medicine') || lower.contains('ortho') || lower.contains('brain')) {
      return sectors[0].services.first;
    } else if (lower.contains('aadhaar') || lower.contains('passport') || lower.contains('service center') ||
        lower.contains('pan') || lower.contains('voter') || lower.contains('license') || lower.contains('certificate')) {
      return sectors[1].services.first;
    } else if (lower.contains('general store') || lower.contains('maida') || lower.contains('sugar') ||
        lower.contains('wheat') || lower.contains('soap') || lower.contains('snack') || lower.contains('dairy')) {
      return sectors[2].services.first;
    } else {
      return sectors[3].services.first;
    }
  }
}
