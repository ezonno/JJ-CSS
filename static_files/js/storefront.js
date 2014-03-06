var jjStorefront = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
            assignGlobalVars : function () {
                window.gridContainer = $('#branded .content .storefront-categories .gridify');
            },

            initHero : function () {
                jjStorefront.jjSwiper = $('#branded .content .hero').swiper({
                        mode: 'horizontal',
                        loop: 'true',
                        calculateHeight: 'true',
                        autoplay: '5000',
                        updateOnImagesReady: true,
                        resizeReInit: true,
                        onFirstInit: function(){
                            $('#branded .content .hero.swiper-container').css('display', 'block');
                        }
                    });

                $('#branded .content .hero .swiper-prev').on('click', function(e){
                    e.preventDefault();
                    jjSwiper.swipePrev();
                });

                $('#branded .content .hero .swiper-next').on('click', function(e){
                    e.preventDefault();
                    jjSwiper.swipeNext();
                });
            },

            resizeHero : function () {
                jjStorefront.jjSwiper.resizeFix();
            },

            brandHover : function () {
                $('#branded .content .storefront-brands .brand').each(function(){
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

            categoryHover : function () {
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

            gridifyInit : function () {
                gridContainer.isotope({
                    itemSelector: '.box',
                    layoutMode: 'masonry',
                    masonry: {
                        columnWidth: 270
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
                    } else if ($(this).hasClass('large')) {
                        jjStorefront.gridifyLarge();
                    } else if ($(this).hasClass('small')) {
                        jjStorefront.gridifySmall();
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
            }
        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjStorefront.assignGlobalVars();
    jjStorefront.initHero();
    jjStorefront.brandHover();
    //jjStorefront.categoryHover();
    jjStorefront.controls();
    jjStorefront.initQuickview();
});

jQuery(window).load(function(){
    jjStorefront.gridifyInit();
});