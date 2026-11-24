// SmartQueue Reactive State Store, Sound Synthesizer & Cross-Tab Synchronizer

class QueueStore {
  constructor() {
    this.storageKey = 'smartqueue_tokens_v2';
    this.voiceEnabled = true;
    this.channel = typeof BroadcastChannel !== 'undefined' ? new BroadcastChannel('smartqueue_sync') : null;
    this.listeners = [];

    // Initialize initial sample tokens if empty
    if (!localStorage.getItem(this.storageKey)) {
      this.initDefaultTokens();
    }

    if (this.channel) {
      this.channel.onmessage = (event) => {
        if (event.data && event.data.type === 'QUEUE_UPDATED') {
          this.notify();
        }
      };
    }
  }

  initDefaultTokens() {
    const defaultTokens = [
      {
        id: 'tok_h01',
        tokenNumber: 'H01',
        sectorId: 'hospital',
        sectorName: 'Hospital & Healthcare',
        serviceId: 'heart_care',
        serviceName: 'Heart Specialist (Cardiology)',
        assignedCounter: 'Counter 1 (Medical & Clinical Care)',
        counterId: 1,
        userName: 'Priya Sharma',
        userPhone: '+91 98765 43210',
        note: 'ECG and BP checkup referral',
        status: 'serving',
        createdAt: Date.now() - 1000 * 60 * 12,
        servedAt: Date.now() - 1000 * 60 * 4,
      },
      {
        id: 'tok_s01',
        tokenNumber: 'S01',
        sectorId: 'citizen',
        sectorName: 'Citizen Service Center',
        serviceId: 'aadhaar_update',
        serviceName: 'Aadhaar Card Enrollment & Updation',
        assignedCounter: 'Counter 2 (Citizen E-Governance Desk)',
        counterId: 2,
        userName: 'Rahul Verma',
        userPhone: '+91 94321 09876',
        note: 'Biometric update & address change',
        status: 'serving',
        createdAt: Date.now() - 1000 * 60 * 15,
        servedAt: Date.now() - 1000 * 60 * 2,
      },
      {
        id: 'tok_g01',
        tokenNumber: 'G01',
        sectorId: 'store',
        sectorName: 'General Store & Supermarket',
        serviceId: 'grains_flour',
        serviceName: 'Grains & Flours (Maida, Sugar, Wheat, Rice)',
        assignedCounter: 'Counter 3 (Retail & Provisions Checkout)',
        counterId: 3,
        userName: 'Anita Rao',
        userPhone: '+91 91234 56789',
        note: '5kg Maida, 2kg Sugar, 10kg Wheat Atta',
        status: 'serving',
        createdAt: Date.now() - 1000 * 60 * 8,
        servedAt: Date.now() - 1000 * 60 * 1,
      },
      {
        id: 'tok_b01',
        tokenNumber: 'B01',
        sectorId: 'bank',
        sectorName: 'Bank & Financial Services',
        serviceId: 'account_creation',
        serviceName: 'New Bank Account Opening',
        assignedCounter: 'Counter 4 (Banking & Teller Desk)',
        counterId: 4,
        userName: 'Vikram Patel',
        userPhone: '+91 97890 12345',
        note: 'Zero-balance digital salary account',
        status: 'serving',
        createdAt: Date.now() - 1000 * 60 * 10,
        servedAt: Date.now() - 1000 * 60 * 3,
      },
      {
        id: 'tok_h02',
        tokenNumber: 'H02',
        sectorId: 'hospital',
        sectorName: 'Hospital & Healthcare',
        serviceId: 'cancer_care',
        serviceName: 'Cancer Specialist (Oncology)',
        assignedCounter: 'Counter 1 (Medical & Clinical Care)',
        counterId: 1,
        userName: 'Sunita Reddy',
        userPhone: '+91 98888 77777',
        note: 'Second opinion biopsy report',
        status: 'waiting',
        createdAt: Date.now() - 1000 * 60 * 6,
      },
      {
        id: 'tok_s02',
        tokenNumber: 'S02',
        sectorId: 'citizen',
        sectorName: 'Citizen Service Center',
        serviceId: 'pan_changes',
        serviceName: 'PAN Card Application & Changes',
        assignedCounter: 'Counter 2 (Citizen E-Governance Desk)',
        counterId: 2,
        userName: 'Karthik N',
        userPhone: '+91 95555 44444',
        note: 'DOB correction in physical card',
        status: 'waiting',
        createdAt: Date.now() - 1000 * 60 * 5,
      },
      {
        id: 'tok_g02',
        tokenNumber: 'G02',
        sectorId: 'store',
        sectorName: 'General Store & Supermarket',
        serviceId: 'snacks_beverages',
        serviceName: 'Snacks & Beverages (Snacks, Biscuits, Tea, Drinks)',
        assignedCounter: 'Counter 3 (Retail & Provisions Checkout)',
        counterId: 3,
        userName: 'Deepak Joshi',
        userPhone: '+91 93333 22222',
        note: 'Tea powder 500g and biscuits',
        status: 'waiting',
        createdAt: Date.now() - 1000 * 60 * 3,
      },
      {
        id: 'tok_b02',
        tokenNumber: 'B02',
        sectorId: 'bank',
        sectorName: 'Bank & Financial Services',
        serviceId: 'phone_link',
        serviceName: 'Phone Number Link to Account',
        assignedCounter: 'Counter 4 (Banking & Teller Desk)',
        counterId: 4,
        userName: 'Meera Sen',
        userPhone: '+91 91111 00000',
        note: 'Link new SIM card for SMS & UPI alerts',
        status: 'waiting',
        createdAt: Date.now() - 1000 * 60 * 2,
      },
    ];
    this.saveTokens(defaultTokens);
  }

  getTokens() {
    try {
      const data = localStorage.getItem(this.storageKey);
      return data ? JSON.parse(data) : [];
    } catch (e) {
      console.error('Failed to parse tokens from localStorage', e);
      return [];
    }
  }

  saveTokens(tokens) {
    localStorage.setItem(this.storageKey, JSON.stringify(tokens));
    if (this.channel) {
      this.channel.postMessage({ type: 'QUEUE_UPDATED', timestamp: Date.now() });
    }
    this.notify();
  }

  subscribe(callback) {
    this.listeners.push(callback);
    return () => {
      this.listeners = this.listeners.filter(cb => cb !== callback);
    };
  }

  notify() {
    const tokens = this.getTokens();
    this.listeners.forEach(cb => {
      try { cb(tokens); } catch (e) { console.error(e); }
    });
  }

  // Token Generation
  generateToken({ sectorId, serviceId, userName, userPhone, note }) {
    const sector = SECTOR_CATALOG.find(s => s.id === sectorId);
    if (!sector) throw new Error('Invalid sector');
    const service = sector.services.find(s => s.id === serviceId) || sector.services[0];

    const tokens = this.getTokens();
    const sectorTokens = tokens.filter(t => t.sectorId === sectorId);
    const count = sectorTokens.length + 1;
    const tokenNumber = `${sector.prefix}${count.toString().padLeft ? count.toString().padLeft(2, '0') : (count < 10 ? '0' + count : count)}`;

    const newToken = {
      id: 'tok_' + Date.now() + '_' + Math.random().toString(36).substr(2, 4),
      tokenNumber,
      sectorId: sector.id,
      sectorName: sector.name,
      serviceId: service.id,
      serviceName: service.name,
      assignedCounter: sector.defaultCounter,
      counterId: sector.counterId,
      userName: userName || 'Visitor',
      userPhone: userPhone || '',
      note: note || '',
      status: 'waiting',
      createdAt: Date.now(),
      avgMinutes: service.avgServiceMinutes || 5
    };

    tokens.push(newToken);
    this.saveTokens(tokens);
    this.playChime('kiosk');
    return newToken;
  }

  // Operator Actions
  callToken(tokenId) {
    const tokens = this.getTokens();
    const target = tokens.find(t => t.id === tokenId);
    if (!target) return;

    // Previous serving tokens at this counter become completed
    tokens.forEach(t => {
      if (t.counterId === target.counterId && t.status === 'serving' && t.id !== tokenId) {
        t.status = 'completed';
        t.completedAt = Date.now();
      }
    });

    target.status = 'serving';
    target.servedAt = Date.now();
    this.saveTokens(tokens);

    // Audio chime + Speech Announcer
    this.playChime('chime');
    this.announceVoice(target.tokenNumber, target.counterId, target.sectorName);
  }

  completeToken(tokenId) {
    const tokens = this.getTokens();
    const target = tokens.find(t => t.id === tokenId);
    if (!target) return;
    target.status = 'completed';
    target.completedAt = Date.now();
    this.saveTokens(tokens);
  }

  recallToken(tokenId) {
    const tokens = this.getTokens();
    const target = tokens.find(t => t.id === tokenId);
    if (!target) return;
    this.playChime('chime');
    this.announceVoice(target.tokenNumber, target.counterId, target.sectorName);
  }

  // Metrics helper
  getMetrics() {
    const tokens = this.getTokens();
    const waiting = tokens.filter(t => t.status === 'waiting');
    const serving = tokens.filter(t => t.status === 'serving');
    const completed = tokens.filter(t => t.status === 'completed');

    return {
      total: tokens.length,
      waitingCount: waiting.length,
      servingCount: serving.length,
      completedCount: completed.length,
      avgWaitMins: waiting.length > 0 ? (waiting.length * 2.8).toFixed(1) : '3.2',
    };
  }

  // Audio Synthesizer (Realistic Hospital/Airport Chime using Web Audio API)
  playChime(type = 'chime') {
    if (!this.voiceEnabled) return;
    try {
      const AudioContext = window.AudioContext || window.webkitAudioContext;
      if (!AudioContext) return;
      const ctx = new AudioContext();

      if (type === 'chime') {
        // Two-tone bell: High tone then low tone (Ding-Dong)
        const osc1 = ctx.createOscillator();
        const osc2 = ctx.createOscillator();
        const gain = ctx.createGain();

        osc1.type = 'sine';
        osc2.type = 'sine';

        // Frequency 660Hz -> 523Hz
        osc1.frequency.setValueAtTime(660, ctx.currentTime);
        osc2.frequency.setValueAtTime(523, ctx.currentTime + 0.28);

        gain.gain.setValueAtTime(0.3, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 1.2);

        osc1.connect(gain);
        osc2.connect(gain);
        gain.connect(ctx.destination);

        osc1.start(ctx.currentTime);
        osc1.stop(ctx.currentTime + 0.3);
        osc2.start(ctx.currentTime + 0.28);
        osc2.stop(ctx.currentTime + 1.2);
      } else if (type === 'kiosk') {
        // Crisp print / ticket success beep
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.type = 'triangle';
        osc.frequency.setValueAtTime(880, ctx.currentTime);
        osc.frequency.exponentialRampToValueAtTime(1760, ctx.currentTime + 0.15);
        gain.gain.setValueAtTime(0.25, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.25);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + 0.25);
      }
    } catch (e) {
      console.warn('Web Audio chime could not play', e);
    }
  }

  // Voice Announcement using Web Speech Synthesis API
  announceVoice(tokenNumber, counterId, sectorName) {
    if (!this.voiceEnabled) return;
    if (!('speechSynthesis' in window)) return;

    window.speechSynthesis.cancel(); // Stop previous
    setTimeout(() => {
      const phrase = `Attention please. Token ${tokenNumber.split('').join(' ')}, please proceed to Counter ${counterId}.`;
      const utterance = new SpeechSynthesisUtterance(phrase);
      utterance.rate = 0.92;
      utterance.pitch = 1.05;
      utterance.volume = 1.0;
      window.speechSynthesis.speak(utterance);
    }, 450); // slight pause after chime
  }

  toggleVoice() {
    this.voiceEnabled = !this.voiceEnabled;
    return this.voiceEnabled;
  }
}

const queueStore = new QueueStore();
