jjNavigation = do ($) ->

	# Custom functions

	scrollbar: ->
		sideMenuCategories = $('#branded .side-menu-categories')
		
		sideMenuCategories.perfectScrollbar
			suppressScrollX: true
			includePadding: true
			wheelSpeed: 30
			useKeyboard: false

	tabletScroll: ->
			# Why isn't this done in css? Why the need for scripting?

		if $('html').hasClass("touch")
			# looks like the following is breaking iPad
			# $("#branded .side-menu-categories").perfectScrollbar('destroy')

			$("#branded .side-menu-categories").css("overflowY", "auto")
			$("#branded .side-menu-categories").css("position", "fixed", "important")
			$("#branded .side-menu .jj-j-shop-highlights").css("padding-top", "25px")

	simpleSearchFlash: ->
		$('.simple_search').click ->
			$('.simple_search').addClass("flash")

			$delay = setTimeout ->
				$('.simple_search').removeClass("flash")
			, 175

	# End custom functions

$(document).ready ->
	jjNavigation.scrollbar()
	jjNavigation.tabletScroll()
	jjNavigation.simpleSearchFlash()