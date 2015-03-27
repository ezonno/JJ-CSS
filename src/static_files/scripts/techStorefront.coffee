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

# Video module start
jjBrandsiteVideo = do ($) ->
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

$(document).ready ->
	jjTechStorefront.assignGlobalVars()
	jjTechStorefront.responsiveHero()
	jjTechStorefront.trackingInit()
	jjTechStorefront.trackingClicks()
	jjTechStorefront.switchImages()

	jjBrandsiteVideo.bindClicks()

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