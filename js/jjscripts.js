var jjShizzle = (function (jQuery) {
	if (!jQuery) {
		alert(app.resources["MISSING_LIB"]);
		return null;
	}

	return {

		// custom functions here
			wrapPromos : function () {
				$('#branded .content .wide_wrapper .jsSlotMarker[data-slot-id="storefront4-campaign3-row1"]').before('<div class="promos"><div class="bottom"></div></div><div class="clear"></div>');
				
				$('#branded .content .wide_wrapper .promoMoveTop').prependTo('#branded .content .wide_wrapper .promos');
				$('#branded .content .wide_wrapper .promoMoveBottom').appendTo('#branded .content .wide_wrapper .promos .bottom');
			},

			centerBoxFive : function () {
				var boxFiveContent = $('#branded .content .wide_wrapper .products .box.five div');
				var boxFive = $('#branded .content .wide_wrapper .products .box.five');
				
				var tempNum = boxFive.height() - boxFiveContent.height();
				var actualNum = tempNum / 2;

				boxFiveContent.css('paddingTop', actualNum);
			},

			brandImgHover : function () {
				$('#branded .content .wide_wrapper .brandimages .brandimage').hover(function(){
					$(this).find('.hover, .overlay').stop().fadeIn('fast');
				}, function(){
					$(this).find('.hover, .overlay').stop().fadeOut('fast');
				});
			},

			promoFade : function () {
				$('#branded .content .wide_wrapper .promos').find('.promoMoveTop, .promoMoveBottom').fadeIn();
			},

			promoHover : function () {
				$('#branded .content .wide_wrapper .promos .promo').hover(function(){
					$(this).find('.overlay').stop().fadeIn('fast');
				}, function(){
					$(this).find('.overlay').stop().fadeOut('fast');
				});
			},

			productsHover : function () {
				$('#branded .content .wide_wrapper .products .box').not('.five').hover(function(){
					$(this).find('.overlay').stop().fadeIn('fast');
				}, function(){
					$(this).find('.overlay').stop().fadeOut('fast');
				});
			}
		// end custom functions
	};
})(jQuery);

jQuery(document).ready(function () {
	jjShizzle.wrapPromos();
	jjShizzle.centerBoxFive();
	jjShizzle.brandImgHover();
	jjShizzle.promoFade();
	jjShizzle.promoHover();
	jjShizzle.productsHover();
});