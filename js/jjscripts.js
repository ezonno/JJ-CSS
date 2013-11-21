var jjShizzle = (function (jQuery) {
	if (!jQuery) {
		alert(app.resources["MISSING_LIB"]);
		return null;
	}

	return {

		// custom functions here
			centerBoxFive : function () {
				var boxFiveContent = $('#branded .content .wide_wrapper .products .box.five div');
				var boxFive = $('#branded .content .wide_wrapper .products .box.five');
				
				var tempNum = boxFive.height() - boxFiveContent.height();
				var actualNum = tempNum / 2;

				boxFiveContent.css('paddingTop', actualNum);
			},

			hoverNizzle : function () {
				$('#branded .content .wide_wrapper .promos .promo').hover(function(){
					$(this).find('.hover').stop().fadeToggle('fast');
				});
			}
		// end custom functions
	};
})(jQuery);

jQuery(document).ready(function () {
	jjShizzle.centerBoxFive();
	jjShizzle.hoverNizzle();
});