jjOriginalsStorefront = do ($) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjOriginalsStorefront.contentBoxesReached = false

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
			jjOriginalsStorefront.heroIsSlider = true
			jjOriginalsStorefront.initHero()

		else if slides is 1
			jjOriginalsStorefront.heroIsSlider = false
			# jjOriginalsStorefront.displayHero()

	initHero: ->
		jjOriginalsStorefront.jjSwiper = $('#branded .content .hero').swiper
			# Options
			mode: 'horizontal'
			loop: true
			autoplay: 8000
			speed: 1000
			calculateHeight: true
			paginationClickable: true
			keyboardControl: true
			
			# Resetting E-coms overwrites... Boneheads...
			slideClass: 'swiper-slide'
			slideActiveClass: 'swiper-slide-active'
			slideVisibleClass: 'swiper-slide-visible'
			slideDuplicateClass: 'swiper-slide-duplicate'
			wrapperClass: 'swiper-wrapper'

			# Callback functions
			onSwiperCreated: ->
				$('#branded .content .hero .swiper-prev, #branded .content .hero .swiper-next').css('display' , 'block')
				jjOriginalsStorefront.displayHero()
			
			onSlideChangeEnd: ->
				if jjOriginalsStorefront.heroInView
					jjOriginalsStorefront.trackingHero('View')

		$('#branded .content .hero .swiper-prev').on 'click', (e) ->
			e.preventDefault()
			jjOriginalsStorefront.jjSwiper.swipePrev()

		$('#branded .content .hero .swiper-next').on 'click', (e) ->
			e.preventDefault()
			jjOriginalsStorefront.jjSwiper.swipeNext()

	displayHero: ->
		$('#branded .content .storefront-hero .swiper-container .swiper-slide').each ->
			$(@).show()

		if $('.swiper-slide video').length
			jjOriginalsStorefront.resizeHero()

	resizeHero: ->
		# jjOriginalsStorefront.jjSwiper.resizeFix()
		heroHeight = $('.swiper-slide a img').height()
		TweenMax.set $('#branded .content .hero.swiper-container'),
			height: heroHeight

	detectGrid: ->
		jjOriginalsStorefront.resizeHero()

		if jjOriginalsStorefront.pageIsLoaded
			jjOriginalsStorefront.viewportHero()

		if !jjOriginalsStorefront.footerReached
			jjOriginalsStorefront.trackingScroll()

	trackingInit: ->
		jjOriginalsStorefront.trackingScroll()

	viewportHero: ->
		heroViewportCheck = $('#branded .content .hero').isInViewport
			'tolerance' : jjOriginalsStorefront.tolerance

		if !jjOriginalsStorefront.heroInView and heroViewportCheck
			jjOriginalsStorefront.heroInView = true
			jjOriginalsStorefront.trackingHero('View')
		else if !heroViewportCheck
			jjOriginalsStorefront.heroInView = false

	clickHero: ->
		$('#branded .content .hero .swiper-slide a').click ->
			jjOriginalsStorefront.trackingHero('Click')

	trackingHero: (type) ->
		if jjOriginalsStorefront.heroIsSlider
			slideIndex = jjOriginalsStorefront.jjSwiper.activeLoopIndex
			slideHumanIndex = slideIndex + 1
			activeSlide = $('#branded .content .hero .swiper-slide-active')
			slideWeek = activeSlide.data('week')
			slideImage = activeSlide.data('image')
			slideUrl = activeSlide.data('url')

			_gaq.push [
				'_trackEvent'
				'jj-originals-hero'
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
				'jj-originals-hero'
				type
				'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl
			]

	trackingScroll: ->
		offsetWindow = $(window).height() * 0.50
		offsetContent = $('#branded .content .brandsite-content-boxes').offset().top - offsetWindow

		$(window).scroll ->
			if $(window).scrollTop() >= offsetContent and !jjOriginalsStorefront.contentBoxesReached
				_gaq.push [
					'_trackEvent'
					'jj-originals-scroll'
					'Scroll'
					'Content boxes in viewport'
				]

				jjOriginalsStorefront.contentBoxesReached = true

	trackingClicks: ->
		contents = $('#branded .content .brandsite-content-boxes, #branded .content .brandsite-full-width-content-box, #branded .content .brandsite-small-content-boxes')

		contents.find('a').click ->
			id = $(@).data('track-id') ? 'Error - Please panic'

			_gaq.push [
				'_trackEvent'
				'jj-originals-content'
				'Click'
				id
			]

	switchImages: ->
		# Whoever you are, you should look away now
		# Raping bandwidth and http requests here
		v = window.innerWidth
		images = $('#branded .content .brandsite-content-boxes, #branded .content .brandsite-small-content-boxes').find('img')

		if (v <= 1280)
			images.each ->
				newSrc = $(@).attr('src').replace('medium', 'small')
				$(@).attr('src', newSrc)
		else if (v >= 1440)
			images.each ->
				newSrc = $(@).attr('src').replace('medium', 'large')
				$(@).attr('src', newSrc)

	# End custom functions

$(document).ready ->
	jjOriginalsStorefront.assignGlobalVars()
	jjOriginalsStorefront.responsiveHero()
	jjOriginalsStorefront.trackingInit()
	jjOriginalsStorefront.trackingClicks()
	jjOriginalsStorefront.switchImages()

$(window).load ->
	jjOriginalsStorefront.checkHero()
	jjOriginalsStorefront.viewportHero()
	jjOriginalsStorefront.clickHero()
	jjOriginalsStorefront.pageIsLoaded = true

$(window).resize ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjOriginalsStorefront.detectGrid, 500)

$(window).scroll ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjOriginalsStorefront.viewportHero, 500)