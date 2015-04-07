jjStorefront = ((jQuery) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjStorefront.brandsReached = false
		jjStorefront.sellingpointsReached = false
		jjStorefront.footerReached = false

	responsiveHero: ->
		$('#branded .content .hero.swiper-container .swiper-slide img').dataImg
			sml: 1023
			med: 1440
			lrg: 1441
			resize: false

	checkHero: ->
		# Count number of slides
		slides = $('#branded .content .hero .swiper-slide').length

		# If stuff in the hero is a slider -> init
		if $('#branded .content .hero').find('.swiper-slide') and slides > 1
			jjStorefront.heroIsSlider = true
			jjStorefront.initHero()

		else if slides is 1
			jjStorefront.heroIsSlider = false
			# jjStorefront.displayHero()

	initHero: ->
		jjStorefront.jjSwiper = $('#branded .content .hero').swiper
			# Options
			mode: 'horizontal'
			loop: true
			autoplay: 8000
			speed: 1000
			calculateHeight: true
			createPagination: true
			paginationClickable: true
			keyboardControl: true
			
			# Resetting E-coms overwrites... Boneheads...
			slideClass: 'swiper-slide'
			slideActiveClass: 'swiper-slide-active'
			slideVisibleClass: 'swiper-slide-visible'
			slideDuplicateClass: 'swiper-slide-duplicate'
			wrapperClass: 'swiper-wrapper'
			paginationElementClass: 'swiper-pagination-switch'
			paginationActiveClass: 'swiper-active-switch'
			paginationVisibleClass: 'swiper-visible-switch'
			pagination: '.swiper-pagination'

			# Callback functions
			onSwiperCreated: ->
				$('#branded .content .hero .swiper-prev, #branded .content .hero .swiper-next').css('display' , 'block')
				# jjStorefront.resizeHero()
				jjStorefront.displayHero()
			
			onSlideChangeEnd: ->
				if jjStorefront.heroInView
					jjStorefront.trackingHero('View')

		$('#branded .content .hero .swiper-prev').on 'click', (e) ->
			e.preventDefault()
			jjStorefront.jjSwiper.swipePrev()

		$('#branded .content .hero .swiper-next').on 'click', (e) ->
			e.preventDefault()
			jjStorefront.jjSwiper.swipeNext()

	displayHero: ->
		$('#branded .content .storefront-hero .swiper-container .swiper-slide').each ->
			$(@).show()

		if $('.swiper-slide video').length
			jjStorefront.resizeHero()

	resizeHero: ->
		# jjStorefront.jjSwiper.resizeFix()
		# :last-child is a temp fix while custom banner is running
		# Need to fix that for future deployments
		heroHeight = $('.swiper-slide a img').height()

		TweenMax.set $('#branded .content .hero.swiper-container'),
			height: heroHeight

	viewportHero: ->
		heroViewportCheck = $('#branded .content .hero').isInViewport
			'tolerance' : jjStorefront.tolerance

		if !jjStorefront.heroInView and heroViewportCheck
			jjStorefront.heroInView = true
			jjStorefront.trackingHero('View')
		else if !heroViewportCheck
			jjStorefront.heroInView = false

	clickHero: ->
		$('#branded .content .hero .swiper-slide a').click ->
			jjStorefront.trackingHero('Click')

	hoverBrands: ->
		$('#branded .content .storefront-brands > div').hover (->
			$(@).removeClass('anim-out').addClass('anim-in')
		), ->
			$(@).removeClass('anim-in').addClass('anim-out')

	detectGrid: ->
		jjStorefront.resizeHero()

		if jjStorefront.pageIsLoaded
			jjStorefront.viewportHero()

		if !jjStorefront.footerReached
			jjStorefront.trackingScroll()

	trackingHero: (type) ->
		if jjStorefront.heroIsSlider
			slideIndex = jjStorefront.jjSwiper.activeLoopIndex
			slideHumanIndex = slideIndex + 1
			activeSlide = $('#branded .content .hero .swiper-slide-active')
			slideWeek = activeSlide.data('week')
			slideImage = activeSlide.data('image')
			slideUrl = activeSlide.data('url')

			_gaq.push [
				'_trackEvent'
				'jj-storefront-hero'
				type
				'Slide: ' + slideHumanIndex + ', week: ' + slideWeek + ', image: ' + slideImage + ', url: ' + slideUrl
			]
		else
			staticIndex = 0
			staticHumanIndex = staticIndex + 1
			staticActiveSlide = $('#branded .content .hero .swiper-slide')
			staticWeek = staticActiveSlide.data('week')
			staticImage = staticActiveSlide.data('image')
			staticUrl = staticActiveSlide.data('url')

			_gaq.push [
				'_trackEvent'
				'jj-storefront-hero'
				type
				'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl
			]

	trackingBrands: ->
		brands = $('#branded .content .storefront-brands')

		brands.find('a').click ->
			id = $(@).data('track-id') ? 'Error - Please panic'

			_gaq.push [
				'_trackEvent'
				'jj-storefront-brands'
				'Click'
				id
			]

	trackingHighlights: ->
		highlights = $('#branded .content .storefront-highlights')

		highlights.find('a').click ->
			# For testing only. Do no include preventDefault() in production code
			# e.preventDefault()
			
			highlightNo = $(@).index() + 1
			link = $(@).attr('href')
			
			_gaq.push [
				'_trackEvent'
				'jj-storefront-highlights'
				'Click'
				'Highlight no: ' + highlightNo + ', link: ' + link
			]

	trackingScroll: ->
		brands = $('#branded .content .storefront-brands')
		sellingpoints = $('#branded .content .storefront-sellingpoints')
		footer = $('#footer_global')

		offsetWindow = $(window).height() * 0.50

		offsetBrands = if brands.length then brands.offset().top - offsetWindow else false
		offsetSellingpoints = if sellingpoints.length then sellingpoints.offset().top - offsetWindow else false
		offsetFooter = if footer.length then footer.offset().top - offsetWindow else false

		$(window).scroll ->
			if offsetBrands and $(window).scrollTop() >= offsetBrands and !jjStorefront.brandsReached
				_gaq.push [
					'_trackEvent'
					'jj-storefront-scroll'
					'Scroll'
					'Brands in viewport'
				]

				jjStorefront.brandsReached = true

			else if offsetSellingpoints and $(window).scrollTop() >= offsetSellingpoints and !jjStorefront.sellingpointsReached
				_gaq.push [
					'_trackEvent'
					'jj-storefront-scroll'
					'Scroll'
					'Sellingpoints in viewport'
				]

				jjStorefront.sellingpointsReached = true

			else if offsetFooter and $(window).scrollTop() >= offsetFooter and !jjStorefront.footerReached
				_gaq.push [
					'_trackEvent'
					'jj-storefront-scroll'
					'Scroll'
					'Footer in viewport'
				]

				jjStorefront.footerReached = true

	# End custom functions
)(jQuery)

$(document).ready ->
	jjStorefront.assignGlobalVars()
	jjStorefront.responsiveHero()
	jjStorefront.hoverBrands()
	
	jjStorefront.trackingHighlights()
	jjStorefront.trackingBrands()

$(window).load ->
	jjStorefront.checkHero()
	jjStorefront.viewportHero()
	jjStorefront.clickHero()
	jjStorefront.trackingScroll()
	jjStorefront.pageIsLoaded = true

$(window).resize ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjStorefront.detectGrid, 500)