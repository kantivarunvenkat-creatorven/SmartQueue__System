// SmartQueue Master Application Controller & UI Binder

document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  initVoiceToggle();
  initSectorExplorer();
  initKiosk();
  initTvBoard();
  initAdminDashboard();
  initAiChat();

  // Listen to store changes for reactive updates across the page
  queueStore.subscribe(() => {
    updateHeroPreview();
    updateTvBoard();
    updateAdminDashboard();
    updateActiveTicketPass();
  });

  // Initial renders
  updateHeroPreview();
  updateTvBoard();
  updateAdminDashboard();
});

/* ==========================================================================
   1. Theme Management (Dark / Light)
   ========================================================================== */
function initTheme() {
  const toggleBtn = document.getElementById('theme-toggle-btn');
  const savedTheme = localStorage.getItem('smartqueue_theme') || 'dark';
  document.documentElement.setAttribute('data-theme', savedTheme);
  updateThemeIcon(toggleBtn, savedTheme);

  if (toggleBtn) {
    toggleBtn.addEventListener('click', () => {
      const current = document.documentElement.getAttribute('data-theme') || 'dark';
      const next = current === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', next);
      localStorage.setItem('smartqueue_theme', next);
      updateThemeIcon(toggleBtn, next);
    });
  }
}

function updateThemeIcon(btn, theme) {
  if (!btn) return;
  btn.innerHTML = theme === 'dark' ? '☀️' : '🌙';
  btn.setAttribute('title', theme === 'dark' ? 'Switch to Light Mode' : 'Switch to Dark Mode');
}

/* ==========================================================================
   2. Voice & Audio Announcer Toggle
   ========================================================================== */
function initVoiceToggle() {
  const voiceBtn = document.getElementById('voice-toggle-btn');
  if (!voiceBtn) return;

  voiceBtn.addEventListener('click', () => {
    const isEnabled = queueStore.toggleVoice();
    voiceBtn.classList.toggle('active-announcer', isEnabled);
    voiceBtn.innerHTML = isEnabled ? '🔊' : '🔇';
    voiceBtn.setAttribute('title', isEnabled ? 'Voice Announcements: ON' : 'Voice Announcements: MUTED');
    if (isEnabled) {
      queueStore.playChime('chime');
    }
  });
}

/* ==========================================================================
   3. Sector Explorer Tabs
   ========================================================================== */
function initSectorExplorer() {
  const tabsContainer = document.getElementById('sector-tabs-container');
  const detailContainer = document.getElementById('sector-detail-container');
  if (!tabsContainer || !detailContainer) return;

  // Render tabs
  tabsContainer.innerHTML = SECTOR_CATALOG.map((sec, idx) => `
    <button class="sector-tab-btn ${idx === 0 ? 'active' : ''}" data-sector="${sec.id}" id="sector-tab-${sec.id}">
      <span>${sec.icon}</span>
      <span>${sec.name}</span>
    </button>
  `).join('');

  // Handle Tab Click
  tabsContainer.querySelectorAll('.sector-tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      tabsContainer.querySelectorAll('.sector-tab-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const sectorId = btn.getAttribute('data-sector');
      renderSectorDetail(sectorId);
    });
  });

  // Initial render with first sector
  renderSectorDetail(SECTOR_CATALOG[0].id);
}

function renderSectorDetail(sectorId) {
  const container = document.getElementById('sector-detail-container');
  const sector = SECTOR_CATALOG.find(s => s.id === sectorId);
  if (!container || !sector) return;

  container.innerHTML = `
    <div class="sector-detail-card" style="border-top: 4px solid ${sector.color}">
      <div>
        <span class="sector-counter-tag">⚡ ${sector.defaultCounter}</span>
        <h3 style="font-size: 1.85rem; margin-bottom: 0.5rem;">${sector.icon} ${sector.name}</h3>
        <p style="color: var(--text-muted); margin-bottom: 1.5rem;">${sector.subtitle}</p>
        
        <div class="sector-badge-banner">
          <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 0.75rem;">
            <div style="font-family: var(--font-mono); font-size: 1.8rem; font-weight: 800; color: ${sector.color};">
              Prefix [${sector.prefix}]
            </div>
            <div style="font-size: 0.85rem; color: var(--text-dim);">
              Token numbers auto-route to Counter ${sector.counterId}
            </div>
          </div>
          <p style="font-size: 0.88rem; color: var(--text-muted);">
            Real-time queue tracking, automated SMS/voice alerts, and priority triage available.
          </p>
        </div>

        <div style="margin-top: 1.75rem;">
          <a href="#kiosk-section" class="btn-primary" onclick="selectSectorInKiosk('${sector.id}')">
            Issue ${sector.name} Token Ticket →
          </a>
        </div>
      </div>

      <div>
        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.5rem;">
          <h4 style="font-size: 1.15rem;">Available Services & Desks (${sector.services.length})</h4>
          <span style="font-size: 0.75rem; color: var(--text-dim); text-transform: uppercase;">Click to Quick-Book</span>
        </div>
        <div class="service-chips-grid">
          ${sector.services.map(s => `
            <div class="service-chip" onclick="quickSelectService('${sector.id}', '${s.id}')">
              <span class="service-chip-icon">${s.icon}</span>
              <div>
                <div class="service-chip-title">${s.name}</div>
                <div class="service-chip-desc">${s.description.substring(0, 55)}...</div>
                <div style="font-size: 0.72rem; color: var(--accent); margin-top: 0.3rem; font-weight: 700;">
                  ⏱️ ~${s.avgServiceMinutes} mins avg turnaround
                </div>
              </div>
            </div>
          `).join('')}
        </div>
      </div>
    </div>
  `;
}

/* ==========================================================================
   4. Live Citizen Kiosk & Digital Ticket Pass
   ========================================================================== */
let activeCreatedTokenId = null;

function initKiosk() {
  const sectorSelect = document.getElementById('kiosk-sector-select');
  const serviceSelect = document.getElementById('kiosk-service-select');
  const noteInput = document.getElementById('kiosk-note-input');
  const form = document.getElementById('kiosk-token-form');

  if (!sectorSelect || !serviceSelect) return;

  // Populate sectors
  sectorSelect.innerHTML = SECTOR_CATALOG.map(s => `
    <option value="${s.id}">${s.icon} ${s.name} (${s.defaultCounter.split(' ')[0]} ${s.defaultCounter.split(' ')[1]})</option>
  `).join('');

  // Handle sector change to update services
  sectorSelect.addEventListener('change', () => {
    updateKioskServices(sectorSelect.value);
  });

  // Handle service change to update note placeholder
  serviceSelect.addEventListener('change', () => {
    const sId = sectorSelect.value;
    const servId = serviceSelect.value;
    const item = findServiceById(servId);
    if (item && noteInput) {
      noteInput.placeholder = item.service.customerDetailsHint;
    }
  });

  // Initial populate of services
  updateKioskServices(sectorSelect.value);

  // Form submit
  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      const userName = document.getElementById('kiosk-name-input').value.trim();
      const userPhone = document.getElementById('kiosk-phone-input').value.trim();
      const note = document.getElementById('kiosk-note-input').value.trim();
      const sectorId = sectorSelect.value;
      const serviceId = serviceSelect.value;

      const token = queueStore.generateToken({
        sectorId,
        serviceId,
        userName,
        userPhone,
        note
      });

      activeCreatedTokenId = token.id;
      aiService.setActiveToken(token.id);
      renderTicketPass(token);

      // Scroll to ticket pass smoothly
      document.getElementById('ticket-pass-area')?.scrollIntoView({ behavior: 'smooth', block: 'center' });
    });
  }
}

function updateKioskServices(sectorId) {
  const serviceSelect = document.getElementById('kiosk-service-select');
  const noteInput = document.getElementById('kiosk-note-input');
  const sector = SECTOR_CATALOG.find(s => s.id === sectorId);
  if (!serviceSelect || !sector) return;

  serviceSelect.innerHTML = sector.services.map(s => `
    <option value="${s.id}">${s.icon} ${s.name} (~${s.avgServiceMinutes}m)</option>
  `).join('');

  if (sector.services[0] && noteInput) {
    noteInput.placeholder = sector.services[0].customerDetailsHint;
  }
}

function selectSectorInKiosk(sectorId) {
  const sectorSelect = document.getElementById('kiosk-sector-select');
  if (!sectorSelect) return;
  sectorSelect.value = sectorId;
  updateKioskServices(sectorId);
}

function quickSelectService(sectorId, serviceId) {
  selectSectorInKiosk(sectorId);
  const serviceSelect = document.getElementById('kiosk-service-select');
  if (serviceSelect) {
    serviceSelect.value = serviceId;
    const item = findServiceById(serviceId);
    const noteInput = document.getElementById('kiosk-note-input');
    if (item && noteInput) {
      noteInput.placeholder = item.service.customerDetailsHint;
    }
  }
  document.getElementById('kiosk-section')?.scrollIntoView({ behavior: 'smooth' });
}

function renderTicketPass(token) {
  const container = document.getElementById('ticket-pass-area');
  if (!container) return;

  const tokens = queueStore.getTokens();
  const waitingTokens = tokens.filter(t => t.counterId === token.counterId && t.status === 'waiting');
  const myIndex = waitingTokens.findIndex(t => t.id === token.id);
  const peopleAhead = myIndex >= 0 ? myIndex : 0;
  const estWait = Math.max(2, peopleAhead * (token.avgMinutes || 4));

  const statusLabel = token.status === 'serving' 
    ? '📢 NOW SERVING!' 
    : (token.status === 'completed' ? '✅ COMPLETED' : '⏳ WAITING');

  const statusClass = token.status === 'serving' ? 'serving' : (token.status === 'completed' ? 'completed' : 'waiting');

  container.innerHTML = `
    <div class="ticket-pass" id="live-ticket-card">
      <div class="ticket-header">
        <div class="ticket-brand">
          <div class="brand-icon" style="width: 2rem; height: 2rem; font-size: 1rem;">Q</div>
          <span>SmartQueue Pass</span>
        </div>
        <div class="token-status-pill ${statusClass}">
          ${statusLabel}
        </div>
      </div>

      <div class="ticket-token-display">
        <div class="token-lbl">Your Live Token Number</div>
        <div class="token-num">${token.tokenNumber}</div>
        <div style="font-size: 0.82rem; color: var(--text-dim); margin-top: 0.25rem;">
          Sector: <strong>${token.sectorName}</strong>
        </div>
      </div>

      <div class="ticket-info-grid">
        <div class="ticket-info-item">
          <span class="lbl">Allocated Desk</span>
          <span class="val" style="color: var(--primary-light);">${token.assignedCounter}</span>
        </div>
        <div class="ticket-info-item">
          <span class="lbl">Visitor Name</span>
          <span class="val">${token.userName}</span>
        </div>
        <div class="ticket-info-item">
          <span class="lbl">Selected Service</span>
          <span class="val">${token.serviceName}</span>
        </div>
        <div class="ticket-info-item">
          <span class="lbl">Est. Wait Time</span>
          <span class="val" style="color: var(--status-waiting);">~${estWait} minutes</span>
        </div>
        <div class="ticket-info-item">
          <span class="lbl">People Ahead</span>
          <span class="val" style="font-size: 1.15rem; font-weight: 800;">${peopleAhead}</span>
        </div>
        <div class="ticket-info-item">
          <span class="lbl">Issued At</span>
          <span class="val">${new Date(token.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
        </div>
      </div>

      ${token.note ? `
        <div style="background: rgba(0,0,0,0.06); padding: 0.6rem 0.9rem; border-radius: 8px; font-size: 0.8rem; margin-bottom: 1.25rem;">
          <strong style="color: var(--text-dim);">Customer Note:</strong> "${token.note}"
        </div>
      ` : ''}

      <div class="ticket-qr-area">
        <div class="ticket-qr-box">
          <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
            <rect width="100" height="100" fill="white"/>
            <!-- Stylized QR Code Pattern for Token -->
            <path d="M10,10 h30 v30 h-30 z M15,15 v20 h20 v-20 z M22,22 h6 v6 h-6 z" fill="#023e8a"/>
            <path d="M60,10 h30 v30 h-30 z M65,15 v20 h20 v-20 z M72,22 h6 v6 h-6 z" fill="#023e8a"/>
            <path d="M10,60 h30 v30 h-30 z M15,65 v20 h20 v-20 z M22,72 h6 v6 h-6 z" fill="#023e8a"/>
            <rect x="45" y="10" width="8" height="15" fill="#023e8a"/>
            <rect x="45" y="30" width="8" height="25" fill="#023e8a"/>
            <rect x="58" y="45" width="15" height="8" fill="#023e8a"/>
            <rect x="78" y="45" width="12" height="8" fill="#023e8a"/>
            <rect x="45" y="60" width="18" height="18" fill="#023e8a"/>
            <rect x="70" y="60" width="20" height="8" fill="#023e8a"/>
            <rect x="70" y="75" width="20" height="15" fill="#023e8a"/>
          </svg>
        </div>
        <div style="font-size: 0.75rem; color: var(--text-dim); text-transform: uppercase; font-weight: 700; letter-spacing: 0.05em;">
          Scan with Mobile Scanner at Counter
        </div>
      </div>

      <div class="ticket-actions">
        <button class="btn-secondary" style="flex: 1;" onclick="window.print()">
          🖨️ Print Pass
        </button>
        <button class="btn-primary" style="flex: 1;" onclick="simulateStaffCall('${token.id}')">
          📢 Test Staff Call
        </button>
      </div>
    </div>
  `;
}

function updateActiveTicketPass() {
  if (activeCreatedTokenId) {
    const tokens = queueStore.getTokens();
    const token = tokens.find(t => t.id === activeCreatedTokenId);
    if (token) {
      renderTicketPass(token);
    }
  }
}

function simulateStaffCall(tokenId) {
  queueStore.callToken(tokenId);
  const flashEl = document.getElementById('live-ticket-card');
  if (flashEl) {
    flashEl.style.transition = 'transform 0.2s, box-shadow 0.2s';
    flashEl.style.boxShadow = '0 0 40px rgba(72, 202, 228, 0.8)';
    setTimeout(() => {
      flashEl.style.boxShadow = '';
    }, 1500);
  }
}

/* ==========================================================================
   5. Live Waiting Room TV Display Board
   ========================================================================== */
function initTvBoard() {
  // Start TV clock
  setInterval(() => {
    const clockEl = document.getElementById('tv-live-clock');
    if (clockEl) {
      const now = new Date();
      clockEl.textContent = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
    }
  }, 1000);

  // Fullscreen button
  const fsBtn = document.getElementById('tv-fullscreen-btn');
  if (fsBtn) {
    fsBtn.addEventListener('click', () => {
      const board = document.getElementById('tv-display-board');
      if (!document.fullscreenElement) {
        board?.requestFullscreen?.();
      } else {
        document.exitFullscreen?.();
      }
    });
  }
}

function updateTvBoard() {
  const container = document.getElementById('tv-counters-container');
  const tickerEl = document.getElementById('tv-ticker-stream');
  if (!container) return;

  const tokens = queueStore.getTokens();
  const counters = [
    { id: 1, name: 'Counter 1', sector: 'Hospital & Healthcare', defaultToken: 'H01' },
    { id: 2, name: 'Counter 2', sector: 'Citizen Service Center', defaultToken: 'S01' },
    { id: 3, name: 'Counter 3', sector: 'General Store', defaultToken: 'G01' },
    { id: 4, name: 'Counter 4', sector: 'Bank & Financial', defaultToken: 'B01' },
  ];

  container.innerHTML = counters.map(c => {
    const currentServing = tokens.find(t => t.counterId === c.id && t.status === 'serving');
    const waitingCount = tokens.filter(t => t.counterId === c.id && t.status === 'waiting').length;
    const tokenDisplay = currentServing ? currentServing.tokenNumber : '--';
    const serviceDisplay = currentServing ? currentServing.serviceName : 'Counter Available';

    return `
      <div class="tv-counter-card ${currentServing && (Date.now() - currentServing.servedAt < 15000) ? 'flash-call' : ''}">
        <div class="tv-counter-name">${c.name}</div>
        <div class="tv-counter-title">${c.sector}</div>
        <div class="tv-token-serving">${tokenDisplay}</div>
        <div style="font-size: 0.82rem; color: #94a3b8; margin-bottom: 0.75rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
          ${serviceDisplay}
        </div>
        <div style="display: flex; justify-content: center; gap: 0.5rem; align-items: center;">
          <span class="tv-counter-status">${currentServing ? 'NOW SERVING' : 'READY'}</span>
          <span style="font-size: 0.72rem; color: #64748b;">${waitingCount} waiting</span>
        </div>
      </div>
    `;
  }).join('');

  if (tickerEl) {
    const waitingList = tokens.filter(t => t.status === 'waiting');
    if (waitingList.length > 0) {
      tickerEl.textContent = 'UPCOMING IN QUEUE: ' + waitingList.map(t => `${t.tokenNumber} (${t.assignedCounter.split(' ')[0]} ${t.assignedCounter.split(' ')[1]})`).join('  •  ');
    } else {
      tickerEl.textContent = 'All queues operating smoothly. No delayed visitors at this moment.';
    }
  }
}

/* ==========================================================================
   6. Staff / Admin Command Center
   ========================================================================== */
let adminCounterFilter = 'all';

function initAdminDashboard() {
  const filterBtns = document.querySelectorAll('.admin-counter-filter-btn');
  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      adminCounterFilter = btn.getAttribute('data-filter');
      updateAdminDashboard();
    });
  });

  const quickWalkinBtn = document.getElementById('admin-quick-walkin-btn');
  if (quickWalkinBtn) {
    quickWalkinBtn.addEventListener('click', () => {
      const sectorId = prompt('Enter Sector ID (hospital / citizen / store / bank):', 'hospital');
      if (sectorId && SECTOR_CATALOG.some(s => s.id === sectorId.toLowerCase())) {
        const token = queueStore.generateToken({
          sectorId: sectorId.toLowerCase(),
          userName: 'Walk-in Citizen',
          note: 'Direct counter walk-in issued by desk operator'
        });
        alert(`Issued token ${token.tokenNumber} for ${token.assignedCounter}!`);
      }
    });
  }
}

function updateAdminDashboard() {
  const metrics = queueStore.getMetrics();
  const tokens = queueStore.getTokens();

  // Update KPI boxes
  document.getElementById('kpi-waiting-count') && (document.getElementById('kpi-waiting-count').textContent = metrics.waitingCount);
  document.getElementById('kpi-serving-count') && (document.getElementById('kpi-serving-count').textContent = metrics.servingCount);
  document.getElementById('kpi-completed-count') && (document.getElementById('kpi-completed-count').textContent = metrics.completedCount);
  document.getElementById('kpi-avg-wait') && (document.getElementById('kpi-avg-wait').textContent = `${metrics.avgWaitMins}m`);

  // Filter tokens
  let filtered = tokens;
  if (adminCounterFilter !== 'all') {
    filtered = tokens.filter(t => t.counterId.toString() === adminCounterFilter);
  }

  // Sort: serving first, then waiting (by time), then completed
  filtered.sort((a, b) => {
    const order = { serving: 0, waiting: 1, completed: 2 };
    if (order[a.status] !== order[b.status]) return order[a.status] - order[b.status];
    return b.createdAt - a.createdAt;
  });

  const tbody = document.getElementById('admin-queue-tbody');
  if (!tbody) return;

  if (filtered.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="6" style="text-align: center; padding: 2rem; color: var(--text-dim);">
          No tokens in queue for selected counter. Click "Issue Walk-in" or generate a token from Kiosk!
        </td>
      </tr>
    `;
    return;
  }

  tbody.innerHTML = filtered.map(t => {
    const statusPill = t.status === 'serving' 
      ? '<span class="token-status-pill serving">Serving</span>'
      : (t.status === 'completed' ? '<span class="token-status-pill" style="background: rgba(45,198,83,0.15); color: var(--status-completed);">Done</span>' : '<span class="token-status-pill waiting">Waiting</span>');

    return `
      <tr>
        <td>
          <span class="token-cell-badge">${t.tokenNumber}</span>
        </td>
        <td>
          <div style="font-weight: 700;">${t.userName || 'Walk-in'}</div>
          <div style="font-size: 0.75rem; color: var(--text-dim);">${t.userPhone || 'No phone'}</div>
        </td>
        <td>
          <div style="font-weight: 600; font-size: 0.88rem;">${t.serviceName}</div>
          <div style="font-size: 0.72rem; color: var(--accent);">${t.sectorName}</div>
        </td>
        <td>
          <span style="font-size: 0.85rem; font-weight: 700; color: var(--text-muted);">${t.assignedCounter.split(' ')[0]} ${t.assignedCounter.split(' ')[1]}</span>
        </td>
        <td>${statusPill}</td>
        <td>
          <div class="desk-actions-group">
            ${t.status === 'waiting' ? `
              <button class="btn-table-action call" onclick="queueStore.callToken('${t.id}')">
                📢 Call
              </button>
            ` : ''}
            ${t.status === 'serving' ? `
              <button class="btn-table-action recall" onclick="queueStore.recallToken('${t.id}')">
                🔔 Recall
              </button>
              <button class="btn-table-action complete" onclick="queueStore.completeToken('${t.id}')">
                ✅ Done
              </button>
            ` : ''}
            ${t.status === 'completed' ? `
              <span style="font-size: 0.75rem; color: var(--text-dim);">Completed</span>
            ` : ''}
          </div>
        </td>
      </tr>
    `;
  }).join('');
}

/* ==========================================================================
   7. AI Assistant Chat UI
   ========================================================================== */
function initAiChat() {
  const input = document.getElementById('ai-chat-input');
  const sendBtn = document.getElementById('ai-chat-send-btn');
  const messagesList = document.getElementById('ai-chat-messages');

  if (!input || !sendBtn) return;

  function handleSend() {
    const text = input.value.trim();
    if (!text) return;

    // Append user message
    appendMessage('user', text);
    input.value = '';

    // Simulate AI thinking and reply
    setTimeout(() => {
      const reply = aiService.processQuery(text);
      appendMessage('bot', reply);
    }, 350);
  }

  sendBtn.addEventListener('click', handleSend);
  input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') handleSend();
  });

  // Handle Quick Pills
  document.querySelectorAll('.ai-pill-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      input.value = btn.textContent.replace(/[🏥🏢🛒🏦⏱️]/g, '').trim();
      handleSend();
    });
  });
}

function appendMessage(sender, text) {
  const messagesList = document.getElementById('ai-chat-messages');
  if (!messagesList) return;

  const bubble = document.createElement('div');
  bubble.className = `chat-bubble ${sender}`;
  bubble.textContent = text;
  messagesList.appendChild(bubble);
  messagesList.scrollTop = messagesList.scrollHeight;
}

/* ==========================================================================
   8. Hero Live Interactive Preview Widget
   ========================================================================== */
function updateHeroPreview() {
  const previewNum = document.getElementById('hero-preview-token-num');
  const previewDesk = document.getElementById('hero-preview-token-desk');
  const previewService = document.getElementById('hero-preview-token-service');
  if (!previewNum) return;

  const tokens = queueStore.getTokens();
  const serving = tokens.find(t => t.status === 'serving') || tokens[0];
  if (serving) {
    previewNum.textContent = serving.tokenNumber;
    previewDesk && (previewDesk.textContent = serving.assignedCounter);
    previewService && (previewService.textContent = serving.serviceName);
  }
}
