/**
 * LibasAI Navigation & UI Interactivity System
 * Handles mega-menus, search overlay, mobile drawer, scroll reveals, and path normalization.
 */
(function () {
  function initNav() {
    var navRoot = document.getElementById('lb-nav-root');
    var navBar = document.querySelector('.lb-nav');
    var megaHost = document.querySelector('.lb-mega-host');
    var searchOverlay = document.getElementById('lb-search-overlay');
    var mobileNav = document.getElementById('lb-mobile-nav');
    var forYouHost = document.getElementById('lb-menu-foryou');

    // Triggers
    var btnDiscover = document.getElementById('lb-discover-trigger');
    var btnBrands = document.getElementById('lb-brands-trigger');
    var btnFeatures = document.getElementById('lb-features-trigger');
    var btnForYou = document.getElementById('lb-foryou-trigger');
    var btnSearch = document.getElementById('lb-search-trigger');
    var btnBurger = document.getElementById('lb-burger-btn');
    var btnMobileClose = document.getElementById('lb-mobile-close');

    // Panels
    var panelDiscover = document.getElementById('lb-menu-discover');
    var panelBrands = document.getElementById('lb-menu-brands');
    var panelFeatures = document.getElementById('lb-menu-features');
    var panelForYou = document.getElementById('lb-menu-foryou');

    var activeMenu = null;
    var closeTimer = null;
    var searchOpen = false;

    function openMenu(name) {
      if (closeTimer) { clearTimeout(closeTimer); closeTimer = null; }
      activeMenu = name;

      var hasMegaPanel = (name === 'discover' && !!panelDiscover) ||
                         (name === 'brands' && !!panelBrands) ||
                         (name === 'features' && !!panelFeatures) ||
                         (name === 'foryou' && !!panelForYou && panelForYou.classList.contains('lb-mega-panel'));

      if (megaHost) megaHost.classList.toggle('is-open', hasMegaPanel);
      if (forYouHost && forYouHost.classList.contains('lb-foryou-host')) {
        forYouHost.classList.toggle('is-open', name === 'foryou');
      }

      if (btnDiscover) btnDiscover.setAttribute('aria-expanded', name === 'discover');
      if (btnBrands) btnBrands.setAttribute('aria-expanded', name === 'brands');
      if (btnFeatures) btnFeatures.setAttribute('aria-expanded', name === 'features');
      if (btnForYou) btnForYou.setAttribute('aria-expanded', name === 'foryou');

      if (panelDiscover) panelDiscover.classList.toggle('is-active', name === 'discover');
      if (panelBrands) panelBrands.classList.toggle('is-active', name === 'brands');
      if (panelFeatures) panelFeatures.classList.toggle('is-active', name === 'features');
      if (panelForYou && panelForYou.classList.contains('lb-mega-panel')) {
        panelForYou.classList.toggle('is-active', name === 'foryou');
      }
    }

    function closeAllMenus() {
      activeMenu = null;
      if (megaHost) megaHost.classList.remove('is-open');
      if (forYouHost && forYouHost.classList.contains('lb-foryou-host')) {
        forYouHost.classList.remove('is-open');
      }

      if (btnDiscover) btnDiscover.setAttribute('aria-expanded', 'false');
      if (btnBrands) btnBrands.setAttribute('aria-expanded', 'false');
      if (btnFeatures) btnFeatures.setAttribute('aria-expanded', 'false');
      if (btnForYou) btnForYou.setAttribute('aria-expanded', 'false');

      if (panelDiscover) panelDiscover.classList.remove('is-active');
      if (panelBrands) panelBrands.classList.remove('is-active');
      if (panelFeatures) panelFeatures.classList.remove('is-active');
      if (panelForYou && panelForYou.classList.contains('lb-mega-panel')) {
        panelForYou.classList.remove('is-active');
      }
    }

    function scheduleClose() {
      if (closeTimer) clearTimeout(closeTimer);
      closeTimer = setTimeout(closeAllMenus, 220);
    }

    function cancelClose() {
      if (closeTimer) { clearTimeout(closeTimer); closeTimer = null; }
    }

    // Attach hover/click handlers
    if (btnDiscover) {
      btnDiscover.addEventListener('mouseenter', function () { openMenu('discover'); });
      btnDiscover.addEventListener('click', function (e) {
        e.preventDefault();
        activeMenu === 'discover' ? closeAllMenus() : openMenu('discover');
      });
    }
    if (btnBrands) {
      btnBrands.addEventListener('mouseenter', function () { openMenu('brands'); });
      btnBrands.addEventListener('click', function (e) {
        e.preventDefault();
        activeMenu === 'brands' ? closeAllMenus() : openMenu('brands');
      });
    }
    if (btnFeatures) {
      btnFeatures.addEventListener('mouseenter', function () { openMenu('features'); });
      btnFeatures.addEventListener('click', function (e) {
        // Directly redirect to dedicated AI Features page
        window.location.href = '/ai-features.html';
      });
    }
    if (btnForYou) {
      btnForYou.addEventListener('mouseenter', function () { openMenu('foryou'); });
      btnForYou.addEventListener('click', function (e) {
        e.preventDefault();
        activeMenu === 'foryou' ? closeAllMenus() : openMenu('foryou');
      });
    }

    if (navRoot) {
      navRoot.addEventListener('mouseleave', scheduleClose);
      navRoot.addEventListener('mouseenter', cancelClose);
    }
    if (megaHost) {
      megaHost.addEventListener('mouseenter', cancelClose);
      megaHost.addEventListener('mouseleave', scheduleClose);
    }
    if (forYouHost) {
      forYouHost.addEventListener('mouseenter', cancelClose);
      forYouHost.addEventListener('mouseleave', scheduleClose);
    }

    // Search overlay
    function toggleSearch() {
      searchOpen = !searchOpen;
      if (searchOverlay) searchOverlay.classList.toggle('is-open', searchOpen);
      if (btnSearch) btnSearch.setAttribute('aria-expanded', searchOpen);
      if (searchOpen) {
        closeAllMenus();
        var inp = document.getElementById('lb-search-input');
        if (inp) setTimeout(function () { inp.focus(); }, 120);
      }
    }

    if (btnSearch) {
      btnSearch.addEventListener('click', function (e) {
        e.preventDefault();
        toggleSearch();
      });
    }

    // Mobile nav
    if (btnBurger && mobileNav) {
      btnBurger.addEventListener('click', function () {
        mobileNav.classList.add('is-open');
        document.body.style.overflow = 'hidden';
      });
    }
    if (btnMobileClose && mobileNav) {
      btnMobileClose.addEventListener('click', function () {
        mobileNav.classList.remove('is-open');
        document.body.style.overflow = '';
      });
    }

    // Mobile accordions
    var accordionHeads = document.querySelectorAll('.lb-accordion__head');
    accordionHeads.forEach(function (head) {
      head.addEventListener('click', function () {
        var isExp = head.getAttribute('aria-expanded') === 'true';
        head.setAttribute('aria-expanded', !isExp);
        var panel = head.nextElementSibling;
        if (panel) {
          panel.classList.toggle('is-open', !isExp);
        }
      });
    });

    // Scroll listener for sticky nav style & reveals
    function onScroll() {
      var y = window.scrollY || window.pageYOffset || 0;
      if (navBar) {
        navBar.classList.toggle('is-scrolled', y > 14);
      }
      var reveals = document.querySelectorAll('.lb-reveal:not(.is-visible)');
      reveals.forEach(function (el) {
        var rect = el.getBoundingClientRect();
        if (rect.top < window.innerHeight - 40) {
          el.classList.add('is-visible');
        }
      });
    }

    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();

    // Fix static hosting link fallbacks
    // Fix static hosting link fallbacks
    // If opened via file:// or directly on a simple static server (like Python http.server or GitHub Pages),
    // ensure clean URLs resolve to their corresponding html file without 404 errors.
    var linkMap = {
      '/': 'index.html',
      '/index': 'index.html',
      '/ai/ask': 'Ai Assistant.dc.html',
      '/ai/search': 'Ai Assistant.dc.html',
      '/ai/image-search': 'image-search.html',
      '/ai/compare': 'compare.html',
      '/ai/outfit-builder': 'outfit-builder.html',
      '/ai': 'ai-features.html',
      '/ai-features': 'ai-features.html',
      '/brands': 'Brands.dc.html',
      '/brands/popular': 'Brands.dc.html',
      '/brands/emerging': 'Brands.dc.html',
      '/brands/local': 'Brands.dc.html',
      '/shop/women': 'Product Listing.dc.html',
      '/shop/men': 'Product Listing.dc.html',
      '/shop/pret': 'Product Listing.dc.html',
      '/shop/unstitched': 'Product Listing.dc.html',
      '/shop/kurta': 'Product Listing.dc.html',
      '/shop/shalwar-kameez': 'Product Listing.dc.html',
      '/shop/lawn': 'Product Listing.dc.html',
      '/shop/accessories': 'Product Listing.dc.html',
      '/discover/new-arrivals': 'Product Listing.dc.html',
      '/discover/trending': 'Product Listing.dc.html',
      '/discover/wedding': 'Product Listing.dc.html',
      '/discover/formal': 'Product Listing.dc.html',
      '/discover/eid': 'Product Listing.dc.html',
      '/discover/casual': 'Product Listing.dc.html',
      '/for-you': 'Product Listing.dc.html',
      '/for-you/picks': 'Product Listing.dc.html',
      '/for-you/recently-viewed': 'Product Listing.dc.html',
      '/for-you/wishlist-inspired': 'Product Listing.dc.html',
      '/for-you/budget': 'Product Listing.dc.html',
      '/tailors': 'tailors.html',
      '/tailors/': 'tailors.html',
      '/tailor-profile': 'tailor-profile.html',
      '/get-stitched': 'get-stitched.html',
      '/my-requests': 'my-requests.html',
      '/tailor-portal': 'tailor-portal.html',
      '/wishlist': 'wishlist.html',
      '/account': 'account.html',
      '/about': 'about.html',
      '/contact': 'contact.html',
      '/terms': 'terms.html',
      '/privacy': 'privacy.html'
    };

    document.querySelectorAll('a[href]').forEach(function (a) {
      var href = a.getAttribute('href');
      if (!href) return;
      var cleanHref = href.split('?')[0].split('#')[0];
      var query = (href.indexOf('?') !== -1) ? href.substring(href.indexOf('?')) : '';

      if (linkMap[cleanHref]) {
        a.setAttribute('href', linkMap[cleanHref] + query);
      } else if (cleanHref.indexOf('/') === 0 && !cleanHref.endsWith('.html') && cleanHref !== '/') {
        // Fallback for any other clean path
        var candidate = cleanHref.substring(1) + '.html';
        a.setAttribute('href', candidate + query);
      }
    });

    // Wishlist buttons micro-interaction
    document.querySelectorAll('.lb-rail-card__wish').forEach(function (btn) {
      btn.addEventListener('click', function (e) {
        e.preventDefault();
        btn.classList.toggle('is-active');
      });
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initNav);
  } else {
    initNav();
  }
})();
