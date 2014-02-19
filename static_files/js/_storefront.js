var jjStorefront = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    return {

        // custom functions here
            initHero : function () {
                $('#branded .content .jj-storefront .hero').owlCarousel();
            }
        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjStorefront.initHero();
});