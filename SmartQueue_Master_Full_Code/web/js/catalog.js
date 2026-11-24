// SmartQueue Multi-Sector & Service Catalog Definition
// Matches lib/models/service_catalog.dart exactly

const SECTOR_CATALOG = [
  {
    id: 'hospital',
    name: 'Hospital & Healthcare',
    subtitle: 'Doctor Consultations, Oncology, Cardiology & OPD',
    icon: '🏥',
    color: '#e63946',
    prefix: 'H',
    defaultCounter: 'Counter 1 (Medical & Clinical Care)',
    counterId: 1,
    services: [
      {
        id: 'cancer_care',
        name: 'Cancer Specialist (Oncology)',
        description: 'Consultation with senior cancer oncologist, biopsy reviews & treatment planning',
        customerDetailsHint: 'Enter patient history, cancer stage or previous scan report details...',
        icon: '🎗️',
        avgServiceMinutes: 8
      },
      {
        id: 'heart_care',
        name: 'Heart Specialist (Cardiology)',
        description: 'ECG, heart rate checkup, blood pressure & cardiology doctor consultation',
        customerDetailsHint: 'Enter symptoms (chest pain, BP, palpitations) or pacemaker status...',
        icon: '❤️',
        avgServiceMinutes: 7
      },
      {
        id: 'brain_care',
        name: 'Brain & Nerve Specialist (Neurology)',
        description: 'Neurology consultation, headache, seizures, migraine & nerve treatments',
        customerDetailsHint: 'Enter neurological symptoms (headaches, nerve pain, seizures)...',
        icon: '🧠',
        avgServiceMinutes: 7
      },
      {
        id: 'ortho_care',
        name: 'Bone & Joint Specialist (Orthopedics)',
        description: 'Arthritis, joint pain, bone fracture treatment & orthopedic surgeon review',
        customerDetailsHint: 'Enter bone/joint area (knee pain, fracture, spine) or injury details...',
        icon: '🦴',
        avgServiceMinutes: 6
      },
      {
        id: 'general_med',
        name: 'General Medicine & Fevers',
        description: 'General doctor consultation for viral fevers, infection, cold, cough & health checkup',
        customerDetailsHint: 'Enter symptoms (fever days, cough, headache, body pain)...',
        icon: '🩺',
        avgServiceMinutes: 4
      },
      {
        id: 'pediatric',
        name: 'Pediatrician (Child Specialist)',
        description: 'Newborn & child health checkup, pediatric vaccination & child fever care',
        customerDetailsHint: 'Enter child age, vaccination required or sickness symptoms...',
        icon: '👶',
        avgServiceMinutes: 5
      },
      {
        id: 'dental_care',
        name: 'Dental & Oral Care',
        description: 'Teeth cleaning, root canal, cavity filling & oral doctor checkup',
        customerDetailsHint: 'Enter tooth issue (toothache, cleaning, extraction, braces)...',
        icon: '🦷',
        avgServiceMinutes: 6
      }
    ]
  },
  {
    id: 'citizen',
    name: 'Citizen Service Center',
    subtitle: 'Aadhaar, PAN, Passport & Govt Certificates',
    icon: '🏛️',
    color: '#0077b6',
    prefix: 'S',
    defaultCounter: 'Counter 2 (Citizen E-Governance Desk)',
    counterId: 2,
    services: [
      {
        id: 'aadhaar_update',
        name: 'Aadhaar Card Enrollment & Updation',
        description: 'Biometric update, mobile number linking, address change & new Aadhaar enrollment',
        customerDetailsHint: 'Enter update type (Phone link, Address change, Biometric, Photo)...',
        icon: '🆔',
        avgServiceMinutes: 5
      },
      {
        id: 'pan_changes',
        name: 'PAN Card Application & Changes',
        description: 'New PAN Card (Form 49A), name/date of birth correction & reprint physical card',
        customerDetailsHint: 'Enter requirement (New PAN, Name correction, Reprint card)...',
        icon: '💳',
        avgServiceMinutes: 4
      },
      {
        id: 'passport_services',
        name: 'Passport & Visa Services',
        description: 'Fresh passport application, reissue, police verification slot & visa assistance',
        customerDetailsHint: 'Enter requirement (Fresh passport, Tatkaal, Renewal, PCC)...',
        icon: '✈️',
        avgServiceMinutes: 6
      },
      {
        id: 'voter_license',
        name: 'Voter ID & Driving License',
        description: 'New voter card (Form 6), driving license renewal & address transfer',
        customerDetailsHint: 'Enter service (Learner license, DL Renewal, Voter ID update)...',
        icon: '🚗',
        avgServiceMinutes: 5
      },
      {
        id: 'income_caste_cert',
        name: 'Income, Caste & Residence Certificate',
        description: 'State government revenue certificates for education, scholarships & jobs',
        customerDetailsHint: 'Enter certificate type (Income, Caste, Residence, EWS)...',
        icon: '📜',
        avgServiceMinutes: 4
      },
      {
        id: 'ration_card',
        name: 'Ration Card & Welfare Services',
        description: 'Food security ration card member addition, surrender & subsidy registration',
        customerDetailsHint: 'Enter details (Add family member, Split card, Address change)...',
        icon: '🌾',
        avgServiceMinutes: 4
      }
    ]
  },
  {
    id: 'store',
    name: 'General Store & Supermarket',
    subtitle: 'Provisions, Flour, Sugar, Soaps & Snacks',
    icon: '🛒',
    color: '#e85d04',
    prefix: 'G',
    defaultCounter: 'Counter 3 (Retail & Provisions Checkout)',
    counterId: 3,
    services: [
      {
        id: 'grains_flour',
        name: 'Grains & Flours (Maida, Sugar, Wheat, Rice)',
        description: 'Bulk raw provisions: Maida (All-Purpose Flour), Sugar, Wheat Atta, Basmati Rice & Pulses',
        customerDetailsHint: 'Enter quantities needed (e.g. 5kg Maida, 2kg Sugar, 10kg Wheat, 25kg Rice)...',
        icon: '🌾',
        avgServiceMinutes: 4
      },
      {
        id: 'soaps_care',
        name: 'Personal Care & Soaps (Soaps, Detergents, Shampoos)',
        description: 'Bath soaps, laundry detergents, floor cleaners, dishwashing bars, shampoos & dental pastes',
        customerDetailsHint: 'List items (e.g. Bath soaps pack, Detergent powder, Handwash, Shampoo)...',
        icon: '🧼',
        avgServiceMinutes: 3
      },
      {
        id: 'snacks_beverages',
        name: 'Snacks & Beverages (Snacks, Biscuits, Tea, Drinks)',
        description: 'Packaged chips, cookies, instant noodles, tea powder, coffee, cold drinks & juices',
        customerDetailsHint: 'List items (e.g. Biscuits, Tea powder 500g, Chips, Soft drinks)...',
        icon: '🍿',
        avgServiceMinutes: 3
      },
      {
        id: 'dairy_bakery',
        name: 'Dairy & Bakery (Milk, Bread, Eggs, Butter)',
        description: 'Fresh milk pouches, sandwich bread, eggs tray, paneer, curd, cheese & butter',
        customerDetailsHint: 'List items (e.g. 2 Milk packets, Brown bread, 1 Dozen eggs, 200g Butter)...',
        icon: '🥛',
        avgServiceMinutes: 2
      },
      {
        id: 'spices_oils',
        name: 'Spices, Cooking Oils & Household Essentials',
        description: 'Sunflower oil, mustard, turmeric, chili powder, garam masala, salt & kitchen disposables',
        customerDetailsHint: 'List items (e.g. 1L Sunflower oil, Chili powder 200g, Salt 1kg)...',
        icon: '🧂',
        avgServiceMinutes: 3
      }
    ]
  },
  {
    id: 'bank',
    name: 'Bank & Financial Services',
    subtitle: 'Accounts, Phone/PAN Linking, Cash & Loans',
    icon: '🏦',
    color: '#2a9d8f',
    prefix: 'B',
    defaultCounter: 'Counter 4 (Banking & Teller Desk)',
    counterId: 4,
    services: [
      {
        id: 'account_creation',
        name: 'New Bank Account Opening',
        description: 'Savings account, current account, salary account & digital zero-balance opening',
        customerDetailsHint: 'Enter account type (Savings, Current, Student) & initial deposit plan...',
        icon: '👤',
        avgServiceMinutes: 6
      },
      {
        id: 'phone_link',
        name: 'Phone Number Link to Account',
        description: 'Update mobile number for OTPs, SMS transaction alerts & mobile banking activation',
        customerDetailsHint: 'Enter account number (last 4 digits) & new phone number to be linked...',
        icon: '📱',
        avgServiceMinutes: 4
      },
      {
        id: 'pan_link',
        name: 'PAN & Aadhaar KYC Link to Account',
        description: 'Biometric e-KYC compliance, PAN card seeding & annual account re-KYC',
        customerDetailsHint: 'Enter KYC request (Aadhaar link, PAN seed, Re-KYC verification)...',
        icon: '🛡️',
        avgServiceMinutes: 4
      },
      {
        id: 'cash_services',
        name: 'Cash Deposit & Withdrawal',
        description: 'Teller counter for cash deposit, high-value cash withdrawal & cheque clearance',
        customerDetailsHint: 'Enter transaction type (Deposit / Withdrawal amount or Cheque deposit)...',
        icon: '💵',
        avgServiceMinutes: 3
      },
      {
        id: 'loans_fd',
        name: 'Personal, Business & Home Loans / FD',
        description: 'Fixed deposit opening, recurring deposit, personal loan, gold loan & home loan consultation',
        customerDetailsHint: 'Enter loan type (Personal, Gold, Home, Business) or FD investment tenure...',
        icon: '📑',
        avgServiceMinutes: 7
      },
      {
        id: 'card_services',
        name: 'ATM & Debit / Credit Card Services',
        description: 'New ATM card request, PIN generation, green PIN, block lost card & credit limit upgrade',
        customerDetailsHint: 'Enter service (New Debit Card, Credit Card application, PIN generation)...',
        icon: '💳',
        avgServiceMinutes: 4
      }
    ]
  }
];

// Helper to look up service
function findServiceById(serviceId) {
  for (const sector of SECTOR_CATALOG) {
    const s = sector.services.find(item => item.id === serviceId);
    if (s) return { sector, service: s };
  }
  return null;
}
