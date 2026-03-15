// BVWA Modal Handler - werkt voor alle A-modules
(function() {
    // Wacht tot DOM volledig geladen is
    function initModal() {
        var modal    = document.getElementById('infoModal');
        var openBtn  = document.getElementById('openInfoBtn');
        var closeBtn = document.getElementById('closeInfoBtn');

        // Check of alle elementen bestaan
        if (!modal) {
            console.warn('BVWA: infoModal niet gevonden');
            return;
        }
        if (!openBtn) {
            console.warn('BVWA: openInfoBtn niet gevonden');
            return;
        }
        if (!closeBtn) {
            console.warn('BVWA: closeInfoBtn niet gevonden');
            return;
        }

        // Open modal
        openBtn.onclick = function(e) {
            e.preventDefault();
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden';
        };

        // Sluit via X knop
        closeBtn.onclick = function(e) {
            e.preventDefault();
            modal.style.display = 'none';
            document.body.style.overflow = '';
        };

        // Sluit via klik buiten modal
        modal.onclick = function(e) {
            if (e.target === modal) {
                modal.style.display = 'none';
                document.body.style.overflow = '';
            }
        };

        // Sluit via Escape
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' &&
                modal.style.display === 'block') {
                modal.style.display = 'none';
                document.body.style.overflow = '';
            }
        });
    }

    // Gebruik DOMContentLoaded als het DOM nog niet klaar is
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initModal);
    } else {
        // DOM is al klaar
        initModal();
    }
})();
