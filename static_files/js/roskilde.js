var jjRoskilde = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
            evalProductClusters : function () {

            },

            injectContent : function () {
                $('#branded.pt_category .container_24 .productresultarea .productlisting').first().after($('.roskilde-container'));
                $('.roskilde-container').show();
            }
        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjRoskilde.injectContent();
});