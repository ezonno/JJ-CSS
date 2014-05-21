var jjStorefront = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
            assignGlobalVars : function () {
                // Vars for scrolling track - False should only be set once on load
                jjStorefront.brandsReached = false;
                jjStorefront.categoriesReached = false;
                jjStorefront.footerReached = false;
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
                    jjStorefront.heroIsSlider = true;
                    jjStorefront.initHero();

                    // On callbacks from the sidemenu, resize the hero
                    $(document).on('hideSideMenuComplete showSideMenuComplete', function(){
                        jjStorefront.resizeHero();
                    });

                } else if (slides === 1) {
                    jjStorefront.heroIsSlider = false;
                    //jjStorefront.displayHero();
                }
            },

            initHero : function () {
                jjStorefront.jjSwiper = $('#branded .content .hero').swiper({
                        mode: 'horizontal',
                        loop: true,
                        autoplay: 6000,
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
                            jjStorefront.displayHero();
                        },
                        onSlideChangeEnd: function(){
                            if (jjStorefront.heroInView) {
                                jjStorefront.trackingHero('Viewed');
                            }
                        }
                    });

                $('#branded .content .hero .swiper-prev').on('click', function(e){
                    e.preventDefault();
                    jjStorefront.jjSwiper.swipePrev();
                });

                $('#branded .content .hero .swiper-next').on('click', function(e){
                    e.preventDefault();
                    jjStorefront.jjSwiper.swipeNext();
                });
            },

            displayHero : function () {
                $('#branded .content .storefront-hero .swiper-container .swiper-slide').each(function(){
                    $(this).show();
                });
            },

            resizeHero : function () {
                jjStorefront.jjSwiper.resizeFix();
                var heroHeight = $('.swiper-slide a img').height();
                TweenMax.set($('#branded .content .hero.swiper-container'), {height: heroHeight});
            },

            centerCallouts : function () {
                var containerHeight = $('#branded .content .storefront-brands .brand.sellingpoints .one').height();
                var contentHeight = $('#branded .content .storefront-brands .brand.sellingpoints .one .content').height();
                var offset = (containerHeight - contentHeight) / 2;

                $('#branded .content .storefront-brands .brand.sellingpoints .content').css('top', offset);
            },

            brandHover : function () {
                $('#branded .content .storefront-brands .brand').each(function(){
                    // Avoid multiple instances of the hover event
                    $(this).off('hover');

                    var width = $(this).find('.image').width(),
                        height = $(this).find('.image').height(),
                        newWidth = width + 10,
                        newHeight = height + 10;

                        $(this).find('.image').css('background-size', newWidth + 'px ' + newHeight + 'px');

                        $(this).hover(function(){
                            TweenMax.to($(this).find('.overlay'), 0.4, {opacity: 1});
                            TweenMax.to($(this).find('.image'), 0.4, {backgroundSize:  width + 'px ' + height + 'px'});
                            TweenMax.to($(this).find('.buttons'), 0.4, {delay: 0.2, opacity: 1});
                        }, function(){
                            TweenMax.to($(this).find('.overlay'), 0.3, {opacity: 0});
                            TweenMax.to($(this).find('.image'), 0.3, {backgroundSize: newWidth + 'px ' + newHeight + 'px'});
                            TweenMax.to($(this).find('.buttons'), 0.3, {opacity: 0, overwrite: true});
                        });
                });
            },

            detectGrid : function () {
                jjStorefront.brandHover();
                jjStorefront.resizeHero();
                jjStorefront.centerCallouts();

                if (jjStorefront.pageIsLoaded) {
                    jjStorefront.viewportHero();
                }

                if (!jjStorefront.footerReached) {
                    jjStorefront.trackingScroll();
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
                jjStorefront.trackingBrands();
                jjStorefront.trackingCategories();
                //jjStorefront.trackingScroll();
                jjStorefront.trackingNavigation();
            },

            trackingBrands : function () {
                $('#branded .content .storefront-brands .brand').not('.sellingpoints').each(function(){
                    var brandID = $(this).data('brand');

                    $(this).find('a').click(function(){
                        if ($(this).hasClass('quickview')) {
                            _gaq.push(['_trackEvent','jj-frontpage-test', 'brand boxes', brandID + ', shopping']);
                        } else {
                            _gaq.push(['_trackEvent','jj-frontpage-test', 'brand boxes', brandID + ', brandsite']);
                        }
                    });
                });
            },

            trackingGridSwitch : function (gridSwitch) {
                _gaq.push(['_trackEvent','jj-frontpage-test', 'controls', gridSwitch]);
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
                            _gaq.push(['_trackEvent','jj-frontpage-test', 'category boxes', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, product: ' + product]);
                        } else if ($(this).hasClass('two')) {
                            _gaq.push(['_trackEvent','jj-frontpage-test', 'category boxes', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, category: ' + category]);
                        } else {
                            _gaq.push(['_trackEvent','jj-frontpage-test', 'category boxes', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: image, category: ' + category]);
                        }
                    });
                });
            },

            viewportHero : function () {
                var heroViewportCheck = $('#branded .content .hero').isInViewport({'tolerance' : jjStorefront.tolerance});

                if (!jjStorefront.heroInView && heroViewportCheck) {
                    jjStorefront.heroInView = true;
                    jjStorefront.trackingHero('viewed');
                } else if (!heroViewportCheck) {
                    jjStorefront.heroInView = false;
                }
            },

            clickHero : function () {
                $('#branded .content .hero .swiper-slide a').click(function(){
                    jjStorefront.trackingHero('clicked');
                });
            },

            trackingHero : function (type) {
                var slideIndex = jjStorefront.jjSwiper.activeLoopIndex,
                    humanIndex = slideIndex + 1,
                    activeSlide = $('#branded .content .hero .swiper-slide-active'),
                    week = activeSlide.data('week'),
                    image = activeSlide.data('image'),
                    url = activeSlide.data('url');

                _gaq.push(['_trackEvent','jj-frontpage-test', 'hero', 'Slide: ' + humanIndex + ', week: ' + week + ', image: ' + image + ', url: ' + url + ', type: ' + type]);
            },

            trackingScroll : function () {
                var offsetBrands = $('#branded .content .storefront-brands').offset().top,
                offsetCategories = $('#branded .content .storefront-categories').offset().top,
                offsetFooter = $('#footer_global').offset().top;

                $(window).scroll(function(){
                    if ($(window).scrollTop() >= offsetBrands && !jjStorefront.brandsReached) {
                        _gaq.push(['_trackEvent','jj-frontpage-test', 'scroll', 'Brand boxes reached']);
                        jjStorefront.brandsReached = true;
                    } else if ($(window).scrollTop() >= offsetCategories && !jjStorefront.categoriesReached) {
                        _gaq.push(['_trackEvent','jj-frontpage-test', 'scroll', 'Category boxes reached']);
                        jjStorefront.categoriesReached = true;
                    } else if ($(window).scrollTop() >= offsetFooter && !jjStorefront.footerReached) {
                        _gaq.push(['_trackEvent','jj-frontpage-test', 'scroll', 'Footer reached']);
                        jjStorefront.footerReached = true;
                    }
                });
            },

            trackingNavigation : function () {
                // Home button
                $('#branded .tabsplaceholder .tabscontainer .home a').click(function(){
                    _gaq.push(['_trackEvent','jj-frontpage-test', 'navigation', 'Home toggled']);
                });

                // Toggle menu
                $(document).on('hideSideMenuComplete', function(){
                    _gaq.push(['_trackEvent','jj-frontpage-test', 'navigation', 'Menu hidden']);
                });

                $(document).on('showSideMenuComplete', function(){
                    _gaq.push(['_trackEvent','jj-frontpage-test', 'navigation', 'Menu shown']);
                });

                // Subbrands
                $('#branded .tabsplaceholder .tabscontainer .tabs .tab a').click(function(){
                    var brandID = $(this).parent().data('brand');
                    _gaq.push(['_trackEvent','jj-frontpage-test', 'tabs', brandID]);
                });

                // Scrollbar
                $('#branded .side-menu .ps-container .ps-scrollbar-y').mousedown(function(e){
                    _gaq.push(['_trackEvent','jj-frontpage-test', 'navigation', 'Scrollbar clicked']);
                });
            }

        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjStorefront.assignGlobalVars();
    jjStorefront.responsiveHero();
    jjStorefront.brandHover();
    jjStorefront.centerCallouts();
    jjStorefront.initQuickview();
    jjStorefront.trackingInit();
});

jQuery(window).load(function(){
    jjStorefront.checkHero();
    jjStorefront.viewportHero();
    jjStorefront.clickHero();
    jjStorefront.pageIsLoaded = true;
});

jQuery(window).resize(function(){
    // Timeout added to avoid mem overload when resizing
    clearTimeout(this.id);
    this.id = setTimeout(jjStorefront.detectGrid, 500);
});

jQuery(window).scroll(function(){
    // Timeout added to avoid mem overload when resizing
    clearTimeout(this.id);
    this.id = setTimeout(jjStorefront.viewportHero, 500);
});