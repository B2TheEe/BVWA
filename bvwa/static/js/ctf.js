// BVWA CTF module - flag-indiening en modal
async function submitFlag() {
    const flag = document.getElementById('flagInput').value.trim();
    const resultEl = document.getElementById('submitResult');

    if (!flag) {
        resultEl.innerHTML = '<div class="msg-error">Voer een flag in.</div>';
        return;
    }

    const res = await fetch('/ctf/submit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'flag=' + encodeURIComponent(flag)
    });
    const data = await res.json();

    if (data.status === 'correct') {
        resultEl.innerHTML = '<div class="msg-success">Correct! Flag gevonden: <strong>' + data.name + '</strong></div>';
        document.getElementById('flagInput').value = '';
        setTimeout(() => location.reload(), 1200);
    } else if (data.status === 'already_found') {
        resultEl.innerHTML = '<div class="msg-info">Al gevonden: <strong>' + data.name + '</strong></div>';
    } else if (data.status === 'unauthorized') {
        resultEl.innerHTML = '<div class="msg-error">Je bent niet ingelogd.</div>';
    } else {
        resultEl.innerHTML = '<div class="msg-error">Onjuiste flag — probeer opnieuw.</div>';
    }
}

document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('flagInput').addEventListener('keydown', function (e) {
        if (e.key === 'Enter') submitFlag();
    });

    document.getElementById('openInfoBtn').addEventListener('click', function () {
        document.getElementById('infoModal').classList.add('active');
    });
    document.getElementById('closeInfoBtn').addEventListener('click', function () {
        document.getElementById('infoModal').classList.remove('active');
    });
    document.getElementById('infoModal').addEventListener('click', function (e) {
        if (e.target === this) this.classList.remove('active');
    });
});
