jjCoreStorefront = do ($) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjCoreStorefront.contentBoxesReached = false

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
		contents = $('#branded .content .brandsite-content-boxes')

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
		v = window.innerWidth
		images = $('#branded .content .brandsite-content-boxes').find('img')

		if (v <= 1280)
			images.each ->
				newSrc = $(@).attr('src').replace('medium', 'small')
				$(@).attr('src', newSrc)
		else if (v >= 1440)
			images.each ->
				newSrc = $(@).attr('src').replace('medium', 'large')
				$(@).attr('src', newSrc)

	# End custom functions

# Video module start
window.jjBrandsiteVideo = do ($) ->
	bindClicks: ->
		$('#branded .content a.video-trigger').click (e) ->
			# Stop links from triggering navigation
			e.preventDefault()

			# Vimeo ID to pass to player
			videoID = $(@).data('video-id')

			# Load the video
			jjBrandsiteVideo.loadVideo(videoID)

		$('#branded .content .brandsite-video-container').click ->
			jjBrandsiteVideo.hideVideo()

	loadVideo: (videoID) ->
		videoPlayer = $('#branded .content .brandsite-video-container #vimeoplayer')
		
		# Templates for the URL needed in the iframe
		# Down the line this should be changed
		# Possibly oembed or HTML video
		urlTemplate = '//player.vimeo.com/video/'
		queryTemplate = '?api=1&player_id=vimeoplayer&portrait=0&title=0&badge=0&byline=0'

		src = urlTemplate + videoID + queryTemplate

		videoPlayer.attr('src', src)

		jjBrandsiteVideo.showVideo()

	showVideo: ->
		# We'll wait for the iframe to load so the user doesn't see the frame refresh
		$('#branded .content .brandsite-video-container #vimeoplayer').load (e) ->

			jjBrandsiteVideo.videoContainer = $('#branded .content .brandsite-video-container')
			
			# Using [0] to get the actualt iframe object
			jjBrandsiteVideo.videoFrame = $('#branded .content .brandsite-video-container #vimeoplayer')[0]
			
			# $f is a vimeo froogaloop.min.js function
			jjBrandsiteVideo.video = $f(jjBrandsiteVideo.videoFrame)

			TweenMax.set jjBrandsiteVideo.videoContainer,
				display: 'block'

			TweenMax.to jjBrandsiteVideo.videoContainer, 0.3,
				opacity: 1
				ease: 'easeOutCubic'

			jjBrandsiteVideo.video.api('play')

	hideVideo: ->
		TweenMax.to jjBrandsiteVideo.videoContainer, 0.3,
			opacity: 0
			ease: 'easeOutCubic'
			onComplete: ->
				jjBrandsiteVideo.video.api('pause')
				TweenMax.set jjBrandsiteVideo.videoContainer,
					display: 'none'


# Callstack, doc.ready
$(document).ready ->
	jjCoreStorefront.assignGlobalVars()
	jjCoreStorefront.responsiveHero()
	jjCoreStorefront.trackingInit()
	jjCoreStorefront.trackingClicks()
	jjCoreStorefront.switchImages()

	jjBrandsiteVideo.bindClicks()

# Callstack, window.load
$(window).load ->
	jjCoreStorefront.checkHero()
	jjCoreStorefront.viewportHero()
	jjCoreStorefront.clickHero()
	jjCoreStorefront.pageIsLoaded = true

# Callstack, window.resize
# Timeout added to avoid mem overload when resizing
$(window).resize ->
	clearTimeout @id
	@id = setTimeout(jjCoreStorefront.detectGrid, 500)

# Callstack, window.close
# Timeout added to avoid mem overload when scrolling
$(window).scroll ->
	clearTimeout @id
	@id = setTimeout(jjCoreStorefront.viewportHero, 500)