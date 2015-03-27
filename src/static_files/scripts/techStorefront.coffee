jjTechStorefront = do ($) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjTechStorefront.contentBoxesReached = false
		jjTechStorefront.fullwidthBoxReached = false

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
			jjTechStorefront.heroIsSlider = true
			jjTechStorefront.initHero()

		else if slides is 1
			jjTechStorefront.heroIsSlider = false
			# jjTechStorefront.displayHero()

	initHero: ->
		jjTechStorefront.jjSwiper = $('#branded .content .hero').swiper
			# Options
			mode: 'horizontal'
			loop: true
			autoplay: 8000
			speed: 1000
			calculateHeight: true
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
				jjTechStorefront.displayHero()
			
			onSlideChangeEnd: ->
				if jjTechStorefront.heroInView
					jjTechStorefront.trackingHero('View')

		$('#branded .content .hero .swiper-prev').on 'click', (e) ->
			e.preventDefault()
			jjTechStorefront.jjSwiper.swipePrev()

		$('#branded .content .hero .swiper-next').on 'click', (e) ->
			e.preventDefault()
			jjTechStorefront.jjSwiper.swipeNext()

	displayHero: ->
		$('#branded .content .storefront-hero .swiper-container .swiper-slide').each ->
			$(@).show()

		if $('.swiper-slide video').length
			jjTechStorefront.resizeHero()

	resizeHero: ->
		# jjTechStorefront.jjSwiper.resizeFix()
		heroHeight = $('.swiper-slide a img').height()
		TweenMax.set $('#branded .content .hero.swiper-container'),
			height: heroHeight

	detectGrid: ->
		jjTechStorefront.resizeHero()

		if jjTechStorefront.pageIsLoaded
			jjTechStorefront.viewportHero()

		if !jjTechStorefront.footerReached
			jjTechStorefront.trackingScroll()

	trackingInit: ->
		jjTechStorefront.trackingScroll()

	viewportHero: ->
		heroViewportCheck = $('#branded .content .hero').isInViewport
			'tolerance' : jjTechStorefront.tolerance

		if !jjTechStorefront.heroInView and heroViewportCheck
			jjTechStorefront.heroInView = true
			jjTechStorefront.trackingHero('View')
		else if !heroViewportCheck
			jjTechStorefront.heroInView = false

	clickHero: ->
		$('#branded .content .hero .swiper-slide a').click ->
			jjTechStorefront.trackingHero('Click')

	trackingHero: (type) ->
		if jjTechStorefront.heroIsSlider
			slideIndex = jjTechStorefront.jjSwiper.activeLoopIndex
			slideHumanIndex = slideIndex + 1
			activeSlide = $('#branded .content .hero .swiper-slide-active')
			slideWeek = activeSlide.data('week')
			slideImage = activeSlide.data('image')
			slideUrl = activeSlide.data('url')

			_gaq.push [
				'_trackEvent'
				'jj-tech-hero'
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
				'jj-tech-hero'
				type
				'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl
			]

	trackingScroll: ->
		offsetWindow = $(window).height() * 0.50
		offsetContent = $('#branded .content .brandsite-content-boxes').offset().top - offsetWindow
		offsetFullwidth = $('#branded .content .brandsite-full-width-content-box').offset().top - offsetWindow

		$(window).scroll ->
			if $(window).scrollTop() >= offsetContent and !jjTechStorefront.contentBoxesReached
				_gaq.push [
					'_trackEvent'
					'jj-tech-scroll'
					'Scroll'
					'Content boxes in viewport'
				]

				jjTechStorefront.contentBoxesReached = true
			
			else if $(window).scrollTop() >= offsetFullwidth and !jjTechStorefront.fullwidthBoxReached
				_gaq.push [
					'_trackEvent'
					'jj-tech-scroll'
					'Scroll'
					'Full-width box in viewport'
				]

				jjTechStorefront.fullwidthBoxReached = true

	trackingClicks: ->
		contents = $('#branded .content .brandsite-content-boxes, #branded .content .brandsite-full-width-content-box')

		contents.find('a').click ->
			id = $(@).data('track-id') ? 'Error - Please panic'

			_gaq.push [
				'_trackEvent'
				'jj-tech-content'
				'Click'
				id
			]

	switchImages: ->
		# Whoever you are, you should look away now
		# Raping bandwidth and http requests here
		v = window.innerWidth
		images = $('#branded .content .brandsite-small-content-boxes, #branded .content .brandsite-content-boxes, #branded .content .brandsite-full-width-content-box').find('img')

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
	jjTechStorefront.assignGlobalVars()
	jjTechStorefront.responsiveHero()
	jjTechStorefront.trackingInit()
	jjTechStorefront.trackingClicks()
	jjTechStorefront.switchImages()

$(window).load ->
	jjTechStorefront.checkHero()
	jjTechStorefront.viewportHero()
	jjTechStorefront.clickHero()
	jjTechStorefront.pageIsLoaded = true

$(window).resize ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjTechStorefront.detectGrid, 500)

$(window).scroll ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjTechStorefront.viewportHero, 500)