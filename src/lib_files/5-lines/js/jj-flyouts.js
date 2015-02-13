var jjFlyouts = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    return {

        // custom functions here
            flyoutArrowCenter : function () {
                $('#branded .header .category_menu .flyout.sub_category').each(function(){
                    $(this).prepend('<div class="hoverArrow"></div>');
                    var offset = $(this).parent('li.level0item').outerWidth() / 2 - 14;
                    $(this).find('.hoverArrow').css('left', offset);
                });
            },

            flyoutHoverOverlay : function () {
                var overlayHTML = '<div class="flyoutOverlay"></div>',
                    hoverSelector = $('#branded .header .category_menu .menu .categories li.level0item'),
                    overlay;

                $('#branded').append(overlayHTML);
                overlay = $('#branded .flyoutOverlay');
                
                hoverSelector.hover(function(){
                    if (!$(this).find('a').hasClass('no-flyout')) {
                        overlay.addClass('awesome');
                    };
                }, function(){
                    overlay.removeClass('awesome');
                });
            },
        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjFlyouts.flyoutHoverOverlay();
});

jQuery(window).load(function() {
    app.enhanceFlyouts();
    jjFlyouts.flyoutArrowCenter();
});