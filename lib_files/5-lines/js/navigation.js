var jjNavigation = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
            scrollbar : function () {
                $('.side-menu-categories').perfectScrollbar({
                    suppressScrollX: true,
                    includePadding: true,
                    wheelSpeed: 30,
                    useKeyboard: false
                });
            },

            tracking : function () {
                // Home button
                $('#branded .tabsplaceholder .tabscontainer .home a').click(function(){
                    _gaq.push(['_trackEvent','jj-navigation', 'navigation', 'Home toggled']);
                });

                // Toggle menu
                $(document).on('hideSideMenuComplete', function(){
                    _gaq.push(['_trackEvent','jj-navigation', 'navigation', 'Menu hidden']);
                });

                $(document).on('showSideMenuComplete', function(){
                    _gaq.push(['_trackEvent','jj-navigation', 'navigation', 'Menu shown']);
                });

                // Subbrands
                $('#branded .tabsplaceholder .tabscontainer .tabs .tab a').click(function(){
                    var brandID = $(this).parent().data('brand');
                    _gaq.push(['_trackEvent','jj-navigation', 'tabs', brandID]);
                });
            }
        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjNavigation.scrollbar();
    jjNavigation.tracking();
});