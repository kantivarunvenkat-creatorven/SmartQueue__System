// SmartQueue AI Assistant Engine
// Directly implements and extends lib/services/ai_chatbot_service.dart

class SmartQueueAiService {
  constructor() {
    this.activeTokenId = null;
  }

  setActiveToken(tokenId) {
    this.activeTokenId = tokenId;
  }

  processQuery(rawQuery) {
    const q = rawQuery.toLowerCase().trim();
    const tokens = queueStore.getTokens();
    const activeToken = this.activeTokenId 
      ? tokens.find(t => t.id === this.activeTokenId) 
      : tokens.find(t => t.status === 'waiting' || t.status === 'serving');

    // 1. ACTIVE TOKEN & TURN STATUS
    if (q.includes('turn') || q.includes('time') || q.includes('wait') || q.includes('status') || q.includes('queue') || q.includes('position')) {
      if (activeToken) {
        const { tokenNumber, status, assignedCounter, serviceName, counterId } = activeToken;

        if (status === 'serving') {
          return `📢 IT'S YOUR TURN NOW!\n\nYour token ${tokenNumber} is currently being called at ${assignedCounter}.\nPlease proceed to the desk immediately!`;
        } else if (status === 'completed') {
          return `✅ Your token ${tokenNumber} has been successfully completed.\nThank you for using SmartQueue! Have a pleasant day ahead.`;
        } else {
          const waitingTokens = tokens.filter(t => t.counterId === counterId && t.status === 'waiting');
          const myIndex = waitingTokens.findIndex(t => t.id === activeToken.id);
          const peopleAhead = myIndex >= 0 ? myIndex : waitingTokens.length;
          const estMinutes = Math.max(2, peopleAhead * 3);

          if (peopleAhead <= 2) {
            return `🚨 GET READY! Only ${peopleAhead === 0 ? 'the current person' : peopleAhead + ' person(s)'} ahead of you!\n\n• Token: ${tokenNumber}\n• Assigned Desk: ${assignedCounter}\n• Service: ${serviceName}\n• Estimated Wait: ~${estMinutes} minutes\n\nPlease stay near the counter with your documents ready!`;
          } else {
            return `🎫 Live Token Status:\n\n• Token: ${tokenNumber}\n• Allocated Desk: ${assignedCounter}\n• People Ahead: ${peopleAhead}\n• Estimated Wait: ~${estMinutes} minutes\n\nWe will chime and alert your device when only 2 people remain ahead of you!`;
          }
        }
      } else {
        return `ℹ️ You don't have an active token yet.\nYou can generate one in 10 seconds using the "Generate Token" section above!`;
      }
    }

    // 2. HOSPITAL & HEALTHCARE
    if (q.includes('cancer') || q.includes('oncolog')) {
      return `🏥 Cancer Specialist (Oncology) Doctor:\n\n• Location: Counter 1 (Medical & Clinical Care)\n• Services: Senior Oncologist consultation, Biopsy reviews, Chemotherapy guidance & Scan review.\n• Documents to bring: Previous biopsy/histology reports, PET-CT scans, Blood work & Prescription history.`;
    }
    if (q.includes('heart') || q.includes('cardio')) {
      return `❤️ Heart Specialist (Cardiology) Doctor:\n\n• Location: Counter 1 (Medical & Clinical Care)\n• Services: ECG review, 2D Echo, Blood Pressure check, Angiography consultation.\n• Documents to bring: Recent ECG strips, Lipid profile reports & current cardiac medicines.`;
    }
    if (q.includes('brain') || q.includes('neuro') || q.includes('headache')) {
      return `🧠 Brain & Nerve Specialist (Neurology):\n\n• Location: Counter 1 (Medical & Clinical Care)\n• Services: Migraine, Epilepsy/Seizures, Stroke rehab, Nerve conduction tests.\n• Documents to bring: MRI/CT brain scans and previous neurological prescriptions.`;
    }
    if (q.includes('bone') || q.includes('ortho') || q.includes('joint') || q.includes('fracture')) {
      return `🦴 Bone & Joint Specialist (Orthopedics):\n\n• Location: Counter 1 (Medical & Clinical Care)\n• Services: Knee arthritis, Fractures, Spine disc pain, Ligament tears.\n• Documents to bring: Recent X-Ray or MRI scans of the affected joint.`;
    }
    if (q.includes('child') || q.includes('pediatric') || q.includes('baby')) {
      return `👶 Pediatrician (Child Specialist):\n\n• Location: Counter 1 (Medical & Clinical Care)\n• Services: Newborn checkups, Immunization charts, Pediatric fevers & nutrition.`;
    }
    if (q.includes('dental') || q.includes('teeth') || q.includes('tooth')) {
      return `🦷 Dental & Oral Care:\n\n• Location: Counter 1 (Dental Clinic Desk)\n• Services: Cavity filling, Root Canal, Orthodontic braces, Teeth cleaning & extraction.`;
    }

    // 3. CITIZEN SERVICE CENTER
    if (q.includes('aadhaar') || q.includes('aadhar')) {
      return `🏢 Aadhaar Card Services:\n\n• Location: Counter 2 (Citizen E-Governance Desk)\n• Updations Available: Mobile number link, Biometrics/Fingerprint update, Address change, Photo update.\n• Required Documents: Original Aadhaar letter, Proof of Address (Electricity bill / Voter ID), and active mobile phone for OTP.`;
    }
    if (q.includes('pan')) {
      return `💳 PAN Card Services:\n\n• Location: Counter 2 (Citizen E-Governance Desk)\n• Services: New PAN Application (Form 49A), Name/DOB correction, Physical card reprint.\n• Required Documents: Aadhaar card (e-KYC) and 2 passport-size photographs.`;
    }
    if (q.includes('passport') || q.includes('visa')) {
      return `✈️ Passport & Visa Services:\n\n• Location: Counter 2 (Citizen E-Governance Desk)\n• Services: Fresh Passport submission, Tatkaal re-issue, Police clearance certificate (PCC).\n• Required Documents: Birth certificate/10th certificate, Aadhaar, PAN & current address proof.`;
    }
    if (q.includes('voter') || q.includes('license') || q.includes('driving')) {
      return `🚗 Transport & Voter Services:\n\n• Location: Counter 2 (Citizen E-Governance Desk)\n• Services: Voter ID enrollment (Form 6), Driving License renewal & slot booking.`;
    }
    if (q.includes('income') || q.includes('caste') || q.includes('certificate')) {
      return `📜 Revenue & State Certificates:\n\n• Location: Counter 2 (Citizen E-Governance Desk)\n• Services: Income Certificate, Caste Certificate, Residence Certificate (EWS).\n• Required Documents: Ration card copy, electricity bill, school leaving certificate & income proof.`;
    }

    // 4. GENERAL STORE & PROVISIONS
    if (q.includes('maida') || q.includes('sugar') || q.includes('wheat') || q.includes('flour') || q.includes('rice') || q.includes('grain')) {
      return `🛒 General Store Provisions (Grains & Flours):\n\n• Location: Counter 3 (Retail & Provisions Checkout)\n• Items in Stock: Fresh Maida, Pure Cane Sugar, Sharbati Wheat Atta, Basmati Rice & Pulses.\n• Express checkout with live digital token!`;
    }
    if (q.includes('soap') || q.includes('detergent') || q.includes('shampoo') || q.includes('clean')) {
      return `🧼 Personal Care & Soaps:\n\n• Location: Counter 3 (Retail & Provisions Checkout)\n• Items: Bath soaps, Washing powders, Handwashes, Shampoos & Floor cleaners.`;
    }
    if (q.includes('milk') || q.includes('bread') || q.includes('egg') || q.includes('dairy')) {
      return `🥛 Dairy & Bakery:\n\n• Location: Counter 3 (Dairy & Bakery Desk)\n• Items: Fresh milk pouches, brown bread, farm eggs, butter, cheese and fresh paneer.`;
    }

    // 5. BANK & FINANCIAL SERVICES
    if (q.includes('phone') && (q.includes('bank') || q.includes('account') || q.includes('link'))) {
      return `🏦 Phone Number Link to Bank Account:\n\n• Location: Counter 4 (Banking & Teller Desk)\n• Process: Fill mobile update mandate form, submit Aadhaar copy, and verify biometric OTP.\n• Activation: Activated within 24 hours for SMS & UPI alerts.`;
    }
    if (q.includes('account') && (q.includes('open') || q.includes('new') || q.includes('savings'))) {
      return `🏦 New Bank Account Opening:\n\n• Location: Counter 4 (Banking & Teller Desk)\n• Options: Zero-Balance Digital Savings, Regular Savings, Current Account.\n• Required Documents: Aadhaar card, PAN card, and 2 passport photos.`;
    }
    if (q.includes('cash') || q.includes('deposit') || q.includes('withdraw') || q.includes('cheque')) {
      return `💵 Cashier & Teller Desk:\n\n• Location: Counter 4 (Banking & Teller Desk)\n• Transactions: Cash deposit, Cash withdrawal, Cheque drop, Demand Drafts.`;
    }
    if (q.includes('loan') || q.includes('fd') || q.includes('deposit') || q.includes('interest')) {
      return `📑 Loans & Fixed Deposits:\n\n• Location: Counter 4 (Banking & Teller Desk)\n• Schemes: Home loan, Gold loan, Personal loan, 1-to-5 year Fixed Deposits (up to 7.8% p.a.).`;
    }

    // DEFAULT AI BOT GREETING / INSTRUCTIONS
    return `🤖 SmartQueue AI Assistant:\n\nI can assist you with any questions:\n• ⏱️ Turn Status: "How much time is left for my turn?"\n• 🏥 Hospital: "What to bring for heart checkup?" or "Cancer specialist docs"\n• 🏢 Citizen Services: "Documents for Aadhaar phone link" or "PAN card changes"\n• 🛒 General Store: "Are Maida and Sugar in stock?"\n• 🏦 Banking: "How to open zero balance account?"\n\nHow may I help you today?`;
  }
}

const aiService = new SmartQueueAiService();
