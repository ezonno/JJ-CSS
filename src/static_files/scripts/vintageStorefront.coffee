jjVintageStorefront = do ($) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjVintageStorefront.contentBoxesReached = false
		jjVintageStorefront.fullwidthBoxReached = false

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
			jjVintageStorefront.heroIsSlider = true
			jjVintageStorefront.initHero()

		else if slides is 1
			jjVintageStorefront.heroIsSlider = false
			# jjVintageStorefront.displayHero()

	initHero: ->
		jjVintageStorefront.jjSwiper = $('#branded .content .hero').swiper
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
				jjVintageStorefront.displayHero()
			
			onSlideChangeEnd: ->
				if jjVintageStorefront.heroInView
					jjVintageStorefront.trackingHero('View')

		$('#branded .content .hero .swiper-prev').on 'click', (e) ->
			e.preventDefault()
			jjVintageStorefront.jjSwiper.swipePrev()

		$('#branded .content .hero .swiper-next').on 'click', (e) ->
			e.preventDefault()
			jjVintageStorefront.jjSwiper.swipeNext()

	displayHero: ->
		$('#branded .content .storefront-hero .swiper-container .swiper-slide').each ->
			$(@).show()

		if $('.swiper-slide video').length
			jjVintageStorefront.resizeHero()

	resizeHero: ->
		# jjVintageStorefront.jjSwiper.resizeFix()
		heroHeight = $('.swiper-slide a img').height()
		TweenMax.set $('#branded .content .hero.swiper-container'),
			height: heroHeight

	detectGrid: ->
		jjVintageStorefront.resizeHero()

		if jjVintageStorefront.pageIsLoaded
			jjVintageStorefront.viewportHero()

		if !jjVintageStorefront.footerReached
			jjVintageStorefront.trackingScroll()

	trackingInit: ->
		jjVintageStorefront.trackingScroll()

	viewportHero: ->
		heroViewportCheck = $('#branded .content .hero').isInViewport
			'tolerance' : jjVintageStorefront.tolerance

		if !jjVintageStorefront.heroInView and heroViewportCheck
			jjVintageStorefront.heroInView = true
			jjVintageStorefront.trackingHero('View')
		else if !heroViewportCheck
			jjVintageStorefront.heroInView = false

	clickHero: ->
		$('#branded .content .hero .swiper-slide a').click ->
			jjVintageStorefront.trackingHero('Click')

	trackingHero: (type) ->
		if jjVintageStorefront.heroIsSlider
			slideIndex = jjVintageStorefront.jjSwiper.activeLoopIndex
			slideHumanIndex = slideIndex + 1
			activeSlide = $('#branded .content .hero .swiper-slide-active')
			slideWeek = activeSlide.data('week')
			slideImage = activeSlide.data('image')
			slideUrl = activeSlide.data('url')

			_gaq.push [
				'_trackEvent'
				'jj-vintage-hero'
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
				'jj-vintage-hero'
				type
				'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl
			]

	trackingScroll: ->
		offsetWindow = $(window).height() * 0.50
		offsetContent = $('#branded .content .brandsite-content-boxes').offset().top - offsetWindow
		offsetFullwidth = $('#branded .content .brandsite-full-width-content-box').offset().top - offsetWindow

		$(window).scroll ->
			if $(window).scrollTop() >= offsetContent and !jjVintageStorefront.contentBoxesReached
				_gaq.push [
					'_trackEvent'
					'jj-vintage-scroll'
					'Scroll'
					'Content boxes in viewport'
				]

				jjVintageStorefront.contentBoxesReached = true
			
			else if $(window).scrollTop() >= offsetFullwidth and !jjVintageStorefront.fullwidthBoxReached
				_gaq.push [
					'_trackEvent'
					'jj-vintage-scroll'
					'Scroll'
					'Full-width box in viewport'
				]

				jjVintageStorefront.fullwidthBoxReached = true

	trackingClicks: ->
		contents = $('#branded .content .brandsite-content-boxes, #branded .content .brandsite-full-width-content-box, #branded .content .brandsite-small-content-boxes')

		contents.find('a').click ->
			id = $(@).data('track-id') ? 'Error - Please panic'

			_gaq.push [
				'_trackEvent'
				'jj-vintage-content'
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
	jjVintageStorefront.assignGlobalVars()
	jjVintageStorefront.responsiveHero()
	jjVintageStorefront.trackingInit()
	jjVintageStorefront.trackingClicks()
	jjVintageStorefront.switchImages()

$(window).load ->
	jjVintageStorefront.checkHero()
	jjVintageStorefront.viewportHero()
	jjVintageStorefront.clickHero()
	jjVintageStorefront.pageIsLoaded = true

$(window).resize ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjVintageStorefront.detectGrid, 500)

$(window).scroll ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjVintageStorefront.viewportHero, 500)