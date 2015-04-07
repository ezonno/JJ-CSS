jjBrandLanding = ((jQuery) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjBrandLanding.footerReached = false

	hoverBrands: ->
		$('#branded .content .storefront-brands > div').hover (->
			$(@).removeClass('anim-out').addClass('anim-in')
		), ->
			$(@).removeClass('anim-in').addClass('anim-out')

	detectGrid: ->
		if !jjBrandLanding.footerReached
			jjBrandLanding.trackingScroll()

	trackingBrands: ->
		brands = $('#branded .content .storefront-brands')

		brands.find('a').click ->
			id = $(@).data('track-id') ? 'Error - Please panic'

			_gaq.push [
				'_trackEvent'
				'jj-brand-landing'
				'Click'
				id
			]

	trackingScroll: ->
		footer = $('#footer_global')

		offsetWindow = $(window).height() * 0.50

		offsetFooter = if footer.length then footer.offset().top - offsetWindow else false

		$(window).scroll ->
			if offsetFooter and $(window).scrollTop() >= offsetFooter and !jjBrandLanding.footerReached
				_gaq.push [
					'_trackEvent'
					'jj-brand-landing-scroll'
					'Scroll'
					'Footer in viewport'
				]

				jjBrandLanding.footerReached = true

	# End custom functions
)(jQuery)

$(document).ready ->
	jjBrandLanding.assignGlobalVars()
	jjBrandLanding.hoverBrands()
	jjBrandLanding.trackingBrands()

$(window).load ->
	jjBrandLanding.trackingScroll()
	jjBrandLanding.pageIsLoaded = true

$(window).resize ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjBrandLanding.detectGrid, 500)