jjCoreStorefront = do ($) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjCoreStorefront.contentBoxesReached = false
		jjCoreStorefront.fullwidthBoxReached = false

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
			jjCoreStorefront.heroIsSlider = true
			jjCoreStorefront.initHero()

		else if slides is 1
			jjCoreStorefront.heroIsSlider = false
			# jjCoreStorefront.displayHero()

	initHero: ->
		jjCoreStorefront.jjSwiper = $('#branded .content .hero').swiper
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
				$('#branded .content .storefront-hero .swiper-prev, #branded .content .storefront-hero .swiper-next').css('display' , 'block')
				jjCoreStorefront.displayHero()
			
			onSlideChangeEnd: ->
				if jjCoreStorefront.heroInView
					jjCoreStorefront.trackingHero('View')

		$('#branded .content .storefront-hero .swiper-prev').on 'click', (e) ->
			e.preventDefault()
			jjCoreStorefront.jjSwiper.swipePrev()

		$('#branded .content .storefront-hero .swiper-next').on 'click', (e) ->
			e.preventDefault()
			jjCoreStorefront.jjSwiper.swipeNext()

	displayHero: ->
		$('#branded .content .storefront-hero .swiper-container .swiper-slide').each ->
			$(@).show()

		if $('.swiper-slide video').length
			jjCoreStorefront.resizeHero()

	resizeHero: ->
		# jjCoreStorefront.jjSwiper.resizeFix()
		heroHeight = $('.swiper-slide a img').height()
		TweenMax.set $('#branded .content .hero.swiper-container'),
			height: heroHeight

	detectGrid: ->
		jjCoreStorefront.resizeHero()

		if jjCoreStorefront.pageIsLoaded
			jjCoreStorefront.viewportHero()

		if !jjCoreStorefront.footerReached
			jjCoreStorefront.trackingScroll()

	trackingInit: ->
		jjCoreStorefront.trackingScroll()

	viewportHero: ->
		heroViewportCheck = $('#branded .content .hero').isInViewport
			'tolerance' : jjCoreStorefront.tolerance

		if !jjCoreStorefront.heroInView and heroViewportCheck
			jjCoreStorefront.heroInView = true
			jjCoreStorefront.trackingHero('View')
		else if !heroViewportCheck
			jjCoreStorefront.heroInView = false

	clickHero: ->
		$('#branded .content .hero .swiper-slide a').click ->
			jjCoreStorefront.trackingHero('Click')

	trackingHero: (type) ->
		if jjCoreStorefront.heroIsSlider
			slideIndex = jjCoreStorefront.jjSwiper.activeLoopIndex
			slideHumanIndex = slideIndex + 1
			activeSlide = $('#branded .content .hero .swiper-slide-active')
			slideWeek = activeSlide.data('week')
			slideImage = activeSlide.data('image')
			slideUrl = activeSlide.data('url')

			_gaq.push [
				'_trackEvent'
				'jj-core-hero'
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
				'jj-core-hero'
				type
				'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl
			]

	trackingScroll: ->
		offsetWindow = $(window).height() * 0.50
		offsetContent = $('#branded .content .brandsite-content-boxes').offset().top - offsetWindow
		
		$(window).scroll ->
			if $(window).scrollTop() >= offsetContent and !jjCoreStorefront.contentBoxesReached
				_gaq.push [
					'_trackEvent'
					'jj-core-scroll'
					'Scroll'
					'Content boxes in viewport'
				]

				jjCoreStorefront.contentBoxesReached = true

	trackingClicks: ->
		contents = $('#branded .content .brandsite-content-boxes, #branded .content .brandsite-full-width-content-box, #branded .content .brandsite-small-content-boxes')

		contents.find('a').click ->
			id = $(@).data('track-id') ? 'Error - Please panic'

			_gaq.push [
				'_trackEvent'
				'jj-core-content'
				'Click'
				id
			]

	switchImages: ->
		# Whoever you are, you should look away now
		# Raping bandwidth and http requests here
		v = $(window).width()
		images = $('#branded .content .brandsite-content-boxes, #branded .content .brandsite-full-width-content-box, #branded .content .brandsite-small-content-boxes').find('img')

		if (v <= 1205)
			images.each ->
				newSrc = $(@).attr('src').replace('medium', 'small')
				$(@).attr('src', newSrc)
		else if (v >= 1440)
			images.each ->
				newSrc = $(@).attr('src').replace('medium', 'large')
				$(@).attr('src', newSrc)

	# End custom functions

$(document).ready ->
	jjCoreStorefront.assignGlobalVars()
	jjCoreStorefront.responsiveHero()
	jjCoreStorefront.trackingInit()
	jjCoreStorefront.trackingClicks()
	jjCoreStorefront.switchImages()

$(window).load ->
	jjCoreStorefront.checkHero()
	jjCoreStorefront.viewportHero()
	jjCoreStorefront.clickHero()
	jjCoreStorefront.pageIsLoaded = true

$(window).resize ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjCoreStorefront.detectGrid, 500)

$(window).scroll ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjCoreStorefront.viewportHero, 500)