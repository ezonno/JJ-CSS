var jjPremiumStorefront = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
            assignGlobalVars : function () {
                // Vars for scrolling track - False should only be set once on load
                jjPremiumStorefront.categoriesReached = false;
                jjPremiumStorefront.footerReached = false;
            },

            responsiveHero : function () {
                $('#branded .content .hero.swiper-container .swiper-slide img').dataImg({
                    sml: 1260,
                    med: 1420,
                    lrg: 1660,
                    resize: false
                });
            },

            checkHero : function () {
                // Count number of slides
                var slides = $('#branded .content .hero .swiper-slide').length;

                // If stuff in the hero is a slider -> init
                if ($('#branded .content .hero').find('.swiper-slide') && slides > 1) {
                    jjPremiumStorefront.heroIsSlider = true;
                    jjPremiumStorefront.initHero();

                    // On callbacks from the sidemenu, resize the hero
                    $(document).on('hideSideMenuComplete showSideMenuComplete', function(){
                        jjPremiumStorefront.resizeHero();
                    });

                } else if (slides === 1) {
                    jjPremiumStorefront.heroIsSlider = false;
                    //jjPremiumStorefront.displayHero();
                }
            },

            initHero : function () {
                jjPremiumStorefront.jjSwiper = $('#branded .content .hero').swiper({
                        mode: 'horizontal',
                        loop: true,
                        //autoplay: 6000,
                        speed: 800,
                        calculateHeight: true,
                        slideClass: 'swiper-slide',
                        slideActiveClass: 'swiper-slide-active',
                        slideVisibleClass: 'swiper-slide-visible',
                        slideDuplicateClass: 'swiper-slide-duplicate',
                        wrapperClass: 'swiper-wrapper',
                        paginationElementClass: 'swiper-pagination-switch',
                        paginationActiveClass: 'swiper-active-switch',
                        paginationVisibleClass: 'swiper-visible-switch',
                        createPagination: true,
                        paginationClickable: true,
                        pagination: '.swiper-pagination',
                        onSwiperCreated: function(){
                            $('#branded .content .hero .swiper-prev, #branded .content .hero .swiper-next').css('display' , 'block');
                            jjPremiumStorefront.displayHero();
                        },
                        onSlideChangeEnd: function(){
                            if (jjPremiumStorefront.heroInView) {
                                jjPremiumStorefront.trackingHero('Viewed');
                            }
                        }
                    });

                $('#branded .content .hero .swiper-prev').on('click', function(e){
                    e.preventDefault();
                    jjPremiumStorefront.jjSwiper.swipePrev();
                });

                $('#branded .content .hero .swiper-next').on('click', function(e){
                    e.preventDefault();
                    jjPremiumStorefront.jjSwiper.swipeNext();
                });
            },

            displayHero : function () {
                $('#branded .content .storefront-hero .swiper-container .swiper-slide').each(function(){
                    $(this).show();
                });
            },

            resizeHero : function () {
                jjPremiumStorefront.jjSwiper.resizeFix();
                var heroHeight = $('.swiper-slide a img').height();
                TweenMax.set($('#branded .content .hero.swiper-container'), {height: heroHeight});
            },

            detectGrid : function () {
                jjPremiumStorefront.resizeHero();

                if (jjPremiumStorefront.pageIsLoaded) {
                    jjPremiumStorefront.viewportHero();
                }

                if (!jjPremiumStorefront.footerReached) {
                    jjPremiumStorefront.trackingScroll();
                }
            },

            initQuickview : function () {
                var quickViewOptions = {
                    buttonSelector:null,
                    imageSelector:null,
                    buttonLinkSelector:  '.quickview'
                };
                
                app.quickView.bindEvents(quickViewOptions);
            },

            trackingInit : function () {
                jjPremiumStorefront.trackingCategories();

                jjPremiumStorefront.trackingScroll();
                
                jjPremiumStorefront.trackingNavigation();
            },

            trackingCategories : function () {
                $('#branded .content .storefront-categories .gridify .box').each(function(){
                    var box  = $(this).data('pos-grid'),
                    week     = $(this).data('week'),
                    product  = $(this).data('product'),
                    category = $(this).data('category'),
                    image    = $(this).data('image');

                    $(this).find('a').click(function(){
                        if ($(this).hasClass('one')) {
                            _gaq.push(['_trackEvent','jj-premium-storefront', 'category boxes', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, product: ' + product]);
                        } else if ($(this).hasClass('two')) {
                            _gaq.push(['_trackEvent','jj-premium-storefront', 'category boxes', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, category: ' + category]);
                        } else {
                            _gaq.push(['_trackEvent','jj-premium-storefront', 'category boxes', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: image, category: ' + category]);
                        }
                    });
                });
            },

            viewportHero : function () {
                var heroViewportCheck = $('#branded .content .hero').isInViewport({'tolerance' : jjPremiumStorefront.tolerance});

                if (!jjPremiumStorefront.heroInView && heroViewportCheck) {
                    jjPremiumStorefront.heroInView = true;
                    jjPremiumStorefront.trackingHero('viewed');
                } else if (!heroViewportCheck) {
                    jjPremiumStorefront.heroInView = false;
                }
            },

            clickHero : function () {
                $('#branded .content .hero .swiper-slide a').click(function(){
                    jjPremiumStorefront.trackingHero('clicked');
                });
            },

            trackingHero : function (type) {
                if (jjPremiumStorefront.heroIsSlider) {
                    var slideIndex  = jjPremiumStorefront.jjSwiper.activeLoopIndex,
                    slideHumanIndex = slideIndex + 1,
                    activeSlide     = $('#branded .content .hero .swiper-slide-active'),
                    slideWeek       = activeSlide.data('week'),
                    slideImage      = activeSlide.data('image'),
                    slideUrl        = activeSlide.data('url');

                    _gaq.push(['_trackEvent','jj-premium-storefront', 'hero', 'Slide: ' + slideHumanIndex + ', week: ' + slideWeek + ', image: ' + slideImage + ', url: ' + slideUrl + ', type: ' + type]);
                } else {
                    var staticIndex = 0,
                    staticHumanIndex     = staticIndex + 1,
                    staticActiveSlide    = $('#branded .content .hero .swiper-slide'),
                    staticWeek           = staticActiveSlide.data('week'),
                    staticImage          = staticActiveSlide.data('image'),
                    staticUrl            = staticActiveSlide.data('url');

                    _gaq.push(['_trackEvent','jj-premium-storefront', 'hero', 'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl + ', type: ' + type]);
                }

                
            },

            trackingScroll : function () {
                var offsetCategories = $('#branded .content .storefront-categories').offset().top,
                offsetFooter = $('#footer_global').offset().top;

                $(window).scroll(function(){
                    if ($(window).scrollTop() >= offsetCategories && !jjPremiumStorefront.categoriesReached) {
                        _gaq.push(['_trackEvent','jj-premium-storefront', 'scroll', 'Category boxes reached']);
                        jjPremiumStorefront.categoriesReached = true;
                    } else if ($(window).scrollTop() >= offsetFooter && !jjPremiumStorefront.footerReached) {
                        _gaq.push(['_trackEvent','jj-premium-storefront', 'scroll', 'Footer reached']);
                        jjPremiumStorefront.footerReached = true;
                    }
                });
            },

            trackingNavigation : function () {
                // Home button
                $('#branded .tabsplaceholder .tabscontainer .home a').click(function(){
                    _gaq.push(['_trackEvent','jj-premium-storefront', 'navigation', 'Home toggled']);
                });

                // Toggle menu
                $(document).on('hideSideMenuComplete', function(){
                    _gaq.push(['_trackEvent','jj-premium-storefront', 'navigation', 'Menu hidden']);
                });

                $(document).on('showSideMenuComplete', function(){
                    _gaq.push(['_trackEvent','jj-premium-storefront', 'navigation', 'Menu shown']);
                });

                // Subbrands
                $('#branded .tabsplaceholder .tabscontainer .tabs .tab a').click(function(){
                    var brandID = $(this).parent().data('brand');
                    _gaq.push(['_trackEvent','jj-premium-storefront', 'tabs', brandID]);
                });

                // Scrollbar
                $('#branded .side-menu .ps-container .ps-scrollbar-y').mousedown(function(e){
                    _gaq.push(['_trackEvent','jj-premium-storefront', 'navigation', 'Scrollbar clicked']);
                });
            },

            closeCallout : function () {
                 $('#branded .content .storefront-promos .storefront-callout button').click(function(e){
                    var callout = $('#branded .content .storefront-promos .storefront-callout');

                    TweenLite.to(callout, 0.4, {height: 0, borderWidth: 0, ease: 'easeOutCubic'});
                    TweenLite.to(callout.parent(), 0.4, {marginTop: 0, ease: 'easeOutCubic'});
                 });
            }

        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjPremiumStorefront.assignGlobalVars();
    jjPremiumStorefront.responsiveHero();
    jjPremiumStorefront.initQuickview();
    jjPremiumStorefront.trackingInit();
    jjPremiumStorefront.closeCallout()
});

jQuery(window).load(function(){
    jjPremiumStorefront.checkHero();
    jjPremiumStorefront.viewportHero();
    jjPremiumStorefront.clickHero();
    jjPremiumStorefront.pageIsLoaded = true;
});

jQuery(window).resize(function(){
    // Timeout added to avoid mem overload when resizing
    clearTimeout(this.id);
    this.id = setTimeout(jjPremiumStorefront.detectGrid, 500);
});

jQuery(window).scroll(function(){
    // Timeout added to avoid mem overload when resizing
    clearTimeout(this.id);
    this.id = setTimeout(jjPremiumStorefront.viewportHero, 500);
});