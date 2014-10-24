var jjNavigation = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }
	
    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
            scrollbar : function () {
                var sideMenuCategories = $('#branded .side-menu-categories');
                sideMenuCategories.perfectScrollbar({
                    suppressScrollX: true,
                    includePadding: true,
                    wheelSpeed: 30,
                    useKeyboard: false
                });
            },
			
			tabletscroll : function () {
				if( jQuery('html').hasClass("touch") ) {
					jQuery("#branded .side-menu-categories").perfectScrollbar('destroy');
					jQuery("#branded .side-menu-categories").css("overflowY", "auto");
					jQuery("#branded .side-menu-categories").css("position", "fixed", "important");
					jQuery("#branded .side-menu .jj-j-shop-highlights").css("padding-top", "25px");
				};
			},
			
			// simplesearch flash on click	
			simplesearchflash : function () {
				jQuery('.simple_search').click(function(){
					jQuery('.simple_search').addClass("flash");
 
					var $delay = setTimeout(function() {
						jQuery('.simple_search').removeClass("flash");
					}, 175);
				});
			},

        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjNavigation.scrollbar();
	jjNavigation.tabletscroll();
	jjNavigation.simplesearchflash();
});

