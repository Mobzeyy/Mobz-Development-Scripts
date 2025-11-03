const loadedScripts = new Set();
const loadedCSS = new Set();
const uiContainer = document.getElementById('ui-container');

function loadUI(uiName) {
    // Load HTML dynamically
    fetch(`data/${uiName}/index.html`)
        .then(res => res.text())
        .then(html => {
            uiContainer.innerHTML = html;
            uiContainer.style.display = 'block';
            uiContainer.style.pointerEvents = 'auto'; // allow interaction with UI
        });

    // Load JS dynamically (once per UI)
    if (!loadedScripts.has(uiName)) {
        const script = document.createElement('script');
        script.src = `data/${uiName}/script.js`;
        document.body.appendChild(script);
        loadedScripts.add(uiName);
    }

    // Load CSS dynamically (once per UI)
    if (!loadedCSS.has(uiName)) {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = `data/${uiName}/style.css`;
        document.head.appendChild(link);
        loadedCSS.add(uiName);
    }
}

function closeUI() {
    uiContainer.style.display = 'none';
    uiContainer.innerHTML = '';
	uiContainer.style.pointerEvents = 'auto'; // allow interaction with UI
}

// Listen to NUI messages from client
window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.action === 'openUI' && data.ui) {
        loadUI(data.ui);
    }

    if (data.action === 'closeUI') {
        closeUI();
    }
});

// Optional: ESC key closes UI
document.addEventListener('keydown', (e) => {
    if (e.key === "Escape" || e.key === "Esc") {
        fetch(`https://mobz-dependenciesV2/closeUI`, { method: 'POST' });
    }
});
