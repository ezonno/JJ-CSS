var jjTechStorefront = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
            assignGlobalVars : function () {
                // Vars for scrolling track - False should only be set once on load
                jjTechStorefront.categoriesReached = false;
                jjTechStorefront.footerReached = false;
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
                    jjTechStorefront.heroIsSlider = true;
                    jjTechStorefront.initHero();

                    // On callbacks from the sidemenu, resize the hero
                    $(document).on('hideSideMenuComplete showSideMenuComplete', function(){
                        jjTechStorefront.resizeHero();
                    });

                } else if (slides === 1) {
                    jjTechStorefront.heroIsSlider = false;
                    //jjTechStorefront.displayHero();
                }
            },

            initHero : function () {
                jjTechStorefront.jjSwiper = $('#branded .content .hero').swiper({
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
                        keyboardControl: true,
                        onSwiperCreated: function(){
                            $('#branded .content .hero .swiper-prev, #branded .content .hero .swiper-next').css('display' , 'block');
                            jjTechStorefront.displayHero();
                        },
                        onSlideChangeEnd: function(){
                            if (jjTechStorefront.heroInView) {
                                jjTechStorefront.trackingHero('Viewed');
                            }
                        }
                    });

                $('#branded .content .hero .swiper-prev').on('click', function(e){
                    e.preventDefault();
                    jjTechStorefront.jjSwiper.swipePrev();
                });

                $('#branded .content .hero .swiper-next').on('click', function(e){
                    e.preventDefault();
                    jjTechStorefront.jjSwiper.swipeNext();
                });
            },

            displayHero : function () {
                $('#branded .content .storefront-hero .swiper-container .swiper-slide').each(function(){
                    $(this).show();
                });
            },

            resizeHero : function () {
                jjTechStorefront.jjSwiper.resizeFix();
                var heroHeight = $('.swiper-slide a img').height();
                TweenMax.set($('#branded .content .hero.swiper-container'), {height: heroHeight});
            },

            detectGrid : function () {
                jjTechStorefront.resizeHero();

                if (jjTechStorefront.pageIsLoaded) {
                    jjTechStorefront.viewportHero();
                }

                if (!jjTechStorefront.footerReached) {
                    jjTechStorefront.trackingScroll();
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
                jjTechStorefront.trackingCategories();

                jjTechStorefront.trackingScroll();
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
                            _gaq.push(['_trackEvent','jj-tech-storefront', 'category boxes', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, product: ' + product]);
                        } else if ($(this).hasClass('two')) {
                            _gaq.push(['_trackEvent','jj-tech-storefront', 'category boxes', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, category: ' + category]);
                        } else {
                            _gaq.push(['_trackEvent','jj-tech-storefront', 'category boxes', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: image, category: ' + category]);
                        }
                    });
                });
            },

            viewportHero : function () {
                var heroViewportCheck = $('#branded .content .hero').isInViewport({'tolerance' : jjTechStorefront.tolerance});

                if (!jjTechStorefront.heroInView && heroViewportCheck) {
                    jjTechStorefront.heroInView = true;
                    jjTechStorefront.trackingHero('viewed');
                } else if (!heroViewportCheck) {
                    jjTechStorefront.heroInView = false;
                }
            },

            clickHero : function () {
                $('#branded .content .hero .swiper-slide a').click(function(){
                    jjTechStorefront.trackingHero('clicked');
                });
            },

            trackingHero : function (type) {
                if (jjTechStorefront.heroIsSlider) {
                    var slideIndex  = jjTechStorefront.jjSwiper.activeLoopIndex,
                    slideHumanIndex = slideIndex + 1,
                    activeSlide     = $('#branded .content .hero .swiper-slide-active'),
                    slideWeek       = activeSlide.data('week'),
                    slideImage      = activeSlide.data('image'),
                    slideUrl        = activeSlide.data('url');

                    _gaq.push(['_trackEvent','jj-tech-storefront', 'hero', 'Slide: ' + slideHumanIndex + ', week: ' + slideWeek + ', image: ' + slideImage + ', url: ' + slideUrl + ', type: ' + type]);
                } else {
                    var staticIndex = 0,
                    staticHumanIndex     = staticIndex + 1,
                    staticActiveSlide    = $('#branded .content .hero .swiper-slide'),
                    staticWeek           = staticActiveSlide.data('week'),
                    staticImage          = staticActiveSlide.data('image'),
                    staticUrl            = staticActiveSlide.data('url');

                    _gaq.push(['_trackEvent','jj-tech-storefront', 'hero', 'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl + ', type: ' + type]);
                }

                
            },

            trackingScroll : function () {
                var offsetCategories = $('#branded .content .storefront-categories').offset().top,
                offsetFooter = $('#footer_global').offset().top;

                $(window).scroll(function(){
                    if ($(window).scrollTop() >= offsetCategories && !jjTechStorefront.categoriesReached) {
                        _gaq.push(['_trackEvent','jj-tech-storefront', 'scroll', 'Category boxes reached']);
                        jjTechStorefront.categoriesReached = true;
                    } else if ($(window).scrollTop() >= offsetFooter && !jjTechStorefront.footerReached) {
                        _gaq.push(['_trackEvent','jj-tech-storefront', 'scroll', 'Footer reached']);
                        jjTechStorefront.footerReached = true;
                    }
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
    jjTechStorefront.assignGlobalVars();
    jjTechStorefront.responsiveHero();
    jjTechStorefront.initQuickview();
    jjTechStorefront.trackingInit();
    jjTechStorefront.closeCallout()
});

jQuery(window).load(function(){
    jjTechStorefront.checkHero();
    jjTechStorefront.viewportHero();
    jjTechStorefront.clickHero();
    jjTechStorefront.pageIsLoaded = true;
});

jQuery(window).resize(function(){
    // Timeout added to avoid mem overload when resizing
    clearTimeout(this.id);
    this.id = setTimeout(jjTechStorefront.detectGrid, 500);
});

jQuery(window).scroll(function(){
    // Timeout added to avoid mem overload when resizing
    clearTimeout(this.id);
    this.id = setTimeout(jjTechStorefront.viewportHero, 500);
});