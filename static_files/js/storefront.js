var jjStorefront = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
            assignGlobalVars : function () {
                // Needed to pass through several functions
                window.gridContainer = $('#branded .content .storefront-categories .gridify');
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
                    jjStorefront.displayHero();
                }
            },

            initHero : function () {
                jjStorefront.jjSwiper = $('#branded .content .hero').swiper({
                        mode: 'horizontal',
                        loop: true,
                        autoplay: 6000,
                        speed: 800,
                        calculateHeight: true,
                        updateOnImagesReady: true,
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
                var heroHeight = $('#branded .content .hero.swiper-container .swiper-slide img').height();

                if (jjStorefront.heroIsSlider) {
                    TweenMax.to($('#branded .content .hero.swiper-container'), 0.6, {height: heroHeight, ease:Quad.Power4});
                } else {
                    TweenMax.set($('#branded .content .hero.swiper-container'), {height: 'auto'});
                }

                jjStorefront.tolerance = heroHeight / 2;
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
                            TweenMax.to($(this).find('.text'), 0.4, {delay: 0.2, opacity: 1, bottom: 15, right: 15});
                        }, function(){
                            TweenMax.to($(this).find('.overlay'), 0.3, {opacity: 0});
                            TweenMax.to($(this).find('.image'), 0.3, {backgroundSize: newWidth + 'px ' + newHeight + 'px'});
                            TweenMax.to($(this).find('.text'), 0.3, {opacity: 0, bottom: 10, right: 10, overwrite: true});
                        });
                });
            },

            categoryHover : function () { // Disabled, but might be enabled later
                $('#branded .content .storefront-categories .gridify .box .content').each(function(){
                    $(this).hover(function(){
                        TweenMax.to($(this).find('.text'), 0.6, {bottom: 0, backgroundColor: 'rgba(252, 252, 252, 0.8)'});
                        TweenMax.to($(this).find('.overlay'), 0.6, {opacity: 1});
                        if (gridContainer.hasClass('mixed') && $(this).parent().hasClass('small')) {
                            TweenMax.to($(this).find('.slidein .linkcontainer > *'), 0.6, {opacity: 1});
                        } else if (gridContainer.hasClass('small')) {
                            TweenMax.to($(this).find('.slidein .linkcontainer > *'), 0.6, {opacity: 1});
                        } else {
                            TweenMax.staggerTo($(this).find('.slidein .linkcontainer > *'), 0.6, {opacity: 1}, 0.08);
                        }
                    }, function(){
                        TweenMax.to($(this).find('.text'), 0.4, {bottom: -50, backgroundColor: 'rgba(252, 252, 252, 0.0)',});
                        TweenMax.to($(this).find('.overlay'), 0.4, {opacity: 0});
                        if (gridContainer.hasClass('mixed') && $(this).parent().hasClass('small')) {
                            TweenMax.to($(this).find('.slidein .linkcontainer > *'), 0.3, {opacity: 0});
                        } else if (gridContainer.hasClass('small')) {
                            TweenMax.to($(this).find('.slidein .linkcontainer > *'), 0.3, {opacity: 0});
                        } else {
                            TweenMax.staggerTo($(this).find('.slidein .linkcontainer > *').get().reverse(), 0.3, {opacity: 0}, 0.08);
                        }
                    });
                });
            },

            detectGrid : function () {
                var width = $(window).width();
                
                // Boom. JS media queries
                if (width >= 1400) {
                    jjStorefront.gridifyInit(270);
                    jjStorefront.centerCallouts();
                } else if (width >= 1200) {
                    jjStorefront.gridifyInit(225);
                    jjStorefront.centerCallouts();
                } else if (width < 1200) {
                    jjStorefront.gridifyInit(180);
                    jjStorefront.centerCallouts();
                }

                if (jjStorefront.heroIsSlider) {
                    jjStorefront.displayHero();
                }
                
                jjStorefront.brandHover();

                if (jjStorefront.pageIsLoaded) {
                    jjStorefront.tolerance = $('#branded .content .hero .swiper-slide').height() / 2;
                    jjStorefront.viewportHero();
                }
            },

            gridifyInit : function (colWidth) {
                gridContainer.isotope({
                    itemSelector: '.box', // Don't change
                    layoutMode: 'masonry',
                    masonry: {
                        columnWidth: colWidth // Value passed from detectGrid();
                    },
                    animationEngine: 'best-available',
                    animationOptions: {
                        duration: 600,
                        ease: 'swing'
                    },
                    getSortData: {
                        grid : function ($elem) {
                            return parseInt($elem.data('pos-mixed'), 10);
                        }
                    }
                });
            },

            gridifyMixed : function () {
                gridContainer.removeClass('large small').addClass('mixed');
                gridContainer.isotope('reLayout');
                gridContainer.isotope({sortBy: 'grid'});
            },

            gridifyLarge : function () {
                gridContainer.removeClass('mixed small').addClass('large');
                gridContainer.isotope('reLayout');
                gridContainer.isotope({sortBy: 'original-order'});
            },

            gridifySmall : function () {
                gridContainer.removeClass('mixed large').addClass('small');
                gridContainer.isotope('reLayout');
                gridContainer.isotope({sortBy: 'original-order'});
            },

            controls : function () {
                $('#branded .content .storefront-misc .controls a').click(function(e){
                    e.preventDefault();
                    $('#branded .content .storefront-misc .controls a').removeClass('active');
                    $(this).addClass('active');

                    if ($(this).hasClass('mixed')) {
                        jjStorefront.gridifyMixed();
                        jjStorefront.trackingGridSwitch('Mixed grid');
                    } else if ($(this).hasClass('large')) {
                        jjStorefront.gridifyLarge();
                        jjStorefront.trackingGridSwitch('Large grid');
                    } else if ($(this).hasClass('small')) {
                        jjStorefront.gridifySmall();
                        jjStorefront.trackingGridSwitch('Small grid');
                    }
                });
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
            },

            trackingBrands : function () {
                $('#branded .content .storefront-brands .brand').not('.sellingpoints').each(function(){
                    var brandID = $(this).data('brand');

                    $(this).find('a').click(function(){
                        if ($(this).hasClass('quickview')) {
                            _gaq.push(['_trackEvent','jj-frontpage-test', 'brands', brandID + ', shopping']);
                        } else {
                            _gaq.push(['_trackEvent','jj-frontpage-test', 'brands', brandID + ', brandsite']);
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
                    jjStorefront.trackingHero('Viewed');
                } else if (!heroViewportCheck) {
                    jjStorefront.heroInView = false;
                }
            },

            clickHero : function () {
                $('#branded .content .hero .swiper-slide a').click(function(){
                    jjStorefront.trackingHero('Clicked');
                });
            },

            trackingHero : function (type) {
                var slideIndex = jjStorefront.jjSwiper.activeLoopIndex,
                    humanIndex = slideIndex + 1,
                    activeSlide = $('#branded .content .hero .swiper-slide-active'),
                    week = activeSlide.data('week'),
                    image = activeSlide.data('image'),
                    url = activeSlide.data('url');

                _gaq.push(['_trackEvent','jj-frontpage-test', 'Slide: ' + humanIndex + ', week: ' + week + ', image: ' + image + ', url: ' + url + ', type: ' + type]);

            },

            trackingScroll : function () {

            }
        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjStorefront.assignGlobalVars();
    jjStorefront.responsiveHero();
    jjStorefront.brandHover();
    //jjStorefront.categoryHover();
    jjStorefront.controls();
    jjStorefront.initQuickview();
    jjStorefront.detectGrid();
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