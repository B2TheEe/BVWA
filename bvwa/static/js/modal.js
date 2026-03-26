// BVWA Modal Handler - werkt voor alle A-modules (info- en voorbeelden-modal)
(function() {
    function initModal(modalId, openBtnId, closeBtnId) {
        var modal    = document.getElementById(modalId);
        var openBtn  = document.getElementById(openBtnId);
        var closeBtn = document.getElementById(closeBtnId);

        if (!modal || !openBtn || !closeBtn) return;

        openBtn.onclick = function(e) {
            e.preventDefault();
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden';
        };

        closeBtn.onclick = function(e) {
            e.preventDefault();
            modal.style.display = 'none';
            document.body.style.overflow = '';
        };

        modal.onclick = function(e) {
            if (e.target === modal) {
                modal.style.display = 'none';
                document.body.style.overflow = '';
            }
        };
    }

    function closeAllModals() {
        var modals = document.querySelectorAll('.modal-overlay');
        modals.forEach(function(m) {
            if (m.style.display === 'block') {
                m.style.display = 'none';
                document.body.style.overflow = '';
            }
        });
    }

    function initAllModals() {
        initModal('infoModal',     'openInfoBtn',     'closeInfoBtn');
        initModal('examplesModal', 'openExamplesBtn', 'closeExamplesBtn');
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeAllModals();
        }
    });

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initAllModals);
    } else {
        initAllModals();
    }
})();
