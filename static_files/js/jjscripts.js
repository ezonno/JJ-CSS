var jjShizzle = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    return {

        // custom functions here
            scrollbars : function () {
                
            },

            tracking : function () {
                // Brand boxes
                $('#branded .content .wide_wrapper .brandimages .brandimage a').click(function(){
                    var trackID = $(this).attr('track');

                    _gaq.push(['_trackEvent','jj-frontpage', 'brandimages',trackID]);
                });

                // Promos
                $('#branded .content .wide_wrapper .promos .promo').click(function(){
                    var promoID = $(this).attr('class');

                    switch (promoID) {
                        case 'promo top':
                            _gaq.push(['_trackEvent','jj-frontpage', 'promos', 'Promo 1 (Big)']);
                            break;
                        case 'promo one':
                            _gaq.push(['_trackEvent','jj-frontpage', 'promos', 'Promo 2 (Small)']);
                            break;
                        case 'promo two':
                            _gaq.push(['_trackEvent','jj-frontpage', 'promos', 'Promo 3 (Small)']);
                            break;
                        default:
                            break;
                    }
                });
            }
        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    
    //jjShizzle.tracking();
});