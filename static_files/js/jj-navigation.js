$( document ).ready(function() {
   		// Click animation on simple_search
		$('.simple_search').click(function(){
				$('.simple_search').addClass("flash");
				var delay = setTimeout(function() {
				$('.simple_search').removeClass("flash");
			}, 175)
		});
  });