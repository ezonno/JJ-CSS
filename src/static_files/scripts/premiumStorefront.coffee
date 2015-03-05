jjPremiumStorefront = do ($) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjPremiumStorefront.contentBoxesReached = false
		jjPremiumStorefront.fullwidthBoxReached = false

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
			jjPremiumStorefront.heroIsSlider = true
			jjPremiumStorefront.initHero()

		else if slides is 1
			jjPremiumStorefront.heroIsSlider = false
			# jjPremiumStorefront.displayHero()

	initHero: ->
		jjPremiumStorefront.jjSwiper = $('#branded .content .hero').swiper
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
				jjPremiumStorefront.displayHero()
			
			onSlideChangeEnd: ->
				if jjPremiumStorefront.heroInView
					jjPremiumStorefront.trackingHero('View')

		$('#branded .content .hero .swiper-prev').on 'click', (e) ->
			e.preventDefault()
			jjPremiumStorefront.jjSwiper.swipePrev()

		$('#branded .content .hero .swiper-next').on 'click', (e) ->
			e.preventDefault()
			jjPremiumStorefront.jjSwiper.swipeNext()

	displayHero: ->
		$('#branded .content .storefront-hero .swiper-container .swiper-slide').each ->
			$(@).show()

		if $('.swiper-slide video').length
			jjPremiumStorefront.resizeHero()

	resizeHero: ->
		# jjPremiumStorefront.jjSwiper.resizeFix()
		heroHeight = $('.swiper-slide a img').height()
		TweenMax.set $('#branded .content .hero.swiper-container'),
			height: heroHeight

	detectGrid: ->
		jjPremiumStorefront.resizeHero()

		if jjPremiumStorefront.pageIsLoaded
			jjPremiumStorefront.viewportHero()

		if !jjPremiumStorefront.footerReached
			jjPremiumStorefront.trackingScroll()

	trackingInit: ->
		jjPremiumStorefront.trackingScroll()

	viewportHero: ->
		heroViewportCheck = $('#branded .content .hero').isInViewport 
			'tolerance' : jjPremiumStorefront.tolerance

		if !jjPremiumStorefront.heroInView and heroViewportCheck
			jjPremiumStorefront.heroInView = true
			jjPremiumStorefront.trackingHero('View')
		else if !heroViewportCheck
			jjPremiumStorefront.heroInView = false

	clickHero: ->
		$('#branded .content .hero .swiper-slide a').click ->
			jjPremiumStorefront.trackingHero('Click')

	trackingHero: (type) ->
		if jjPremiumStorefront.heroIsSlider
			slideIndex = jjPremiumStorefront.jjSwiper.activeLoopIndex
			slideHumanIndex = slideIndex + 1
			activeSlide = $('#branded .content .hero .swiper-slide-active')
			slideWeek = activeSlide.data('week')
			slideImage = activeSlide.data('image')
			slideUrl = activeSlide.data('url')

			_gaq.push [
				'_trackEvent'
				'jj-premium-hero'
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
				'jj-premium-hero'
				type
				'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl
			]

	trackingScroll: ->
		$(window).scroll ->
			offsetWindow = $(window).height() * 0.50
			offsetContent = $('#branded .content .brandsite-content-boxes').offset().top - offsetWindow
			offsetFullwidth = $('#branded .content .brandsite-full-width-content-box').offset().top - offsetWindow

			$(window).scroll ->
				if $(window).scrollTop() >= offsetContent and !jjPremiumStorefront.contentBoxesReached
					_gaq.push [
						'_trackEvent'
						'jj-premium-scroll'
						'Scroll'
						'Content boxes in viewport'
					]

					jjPremiumStorefront.contentBoxesReached = true
				
				else if $(window).scrollTop() >= offsetFullwidth and !jjPremiumStorefront.fullwidthBoxReached
					_gaq.push [
						'_trackEvent'
						'jj-premium-scroll'
						'Scroll'
						'Full-width box in viewport'
					]

					jjPremiumStorefront.fullwidthBoxReached = true

	trackingClicks: ->
		contents = $('#branded .content .brandsite-content-boxes, #branded .content .brandsite-full-width-content-box, #branded .content .brandsite-small-content-boxes')

		contents.find('a').click ->
			id = $(@).data('track-id') ? 'Error - Please panic'

			_gaq.push [
				'_trackEvent'
				'jj-premium-content'
				'Click'
				id
			]

	# End custom functions

$(document).ready ->
	jjPremiumStorefront.assignGlobalVars()
	jjPremiumStorefront.responsiveHero()
	jjPremiumStorefront.trackingInit()
	jjPremiumStorefront.trackingClicks()

$(window).load ->
	jjPremiumStorefront.checkHero()
	jjPremiumStorefront.viewportHero()
	jjPremiumStorefront.clickHero()
	jjPremiumStorefront.pageIsLoaded = true

$(window).resize ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjPremiumStorefront.detectGrid, 500)

$(window).scroll ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjPremiumStorefront.viewportHero, 500)