jjOriginalsStorefront = do ($) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjOriginalsStorefront.contentBoxesReached = false
		jjOriginalsStorefront.smallContentBoxesReached = false

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
		contentBoxes = $('#branded .content .brandsite-content-boxes')
		smallContentBoxes = $('#branded .content .brandsite-small-content-boxes')

		offsetWindow = $(window).height() * 0.50
		offsetContent = if contentBoxes.length then contentBoxes.offset().top - offsetWindow else false
		offsetSmallContent = if smallContentBoxes.length then smallContentBoxes.offset().top - offsetWindow else false

		$(window).scroll ->
			if offsetContent and $(window).scrollTop() >= offsetContent and !jjOriginalsStorefront.contentBoxesReached
				_gaq.push [
					'_trackEvent'
					'jj-originals-scroll'
					'Scroll'
					'Content boxes in viewport'
				]

				jjOriginalsStorefront.contentBoxesReached = true

			else if offsetSmallContent and $(window).scrollTop() >= offsetSmallContent and !jjOriginalsStorefront.smallContentBoxesReached
				_gaq.push [
					'_trackEvent'
					'jj-originals-scroll'
					'Scroll'
					'Small content boxes in viewport'
				]

				jjOriginalsStorefront.smallContentBoxesReached = true

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
		# Pass full video url to the api for response
		# ID alone is not enough
		vimeoUrl = 'http://www.vimeo.com/' + videoID

		# Vimeo oembed api
		endpoint = 'http://www.vimeo.com/api/oembed.json'

		# Tell the api what we're looking to do
		callback = 'embedVideo'

		# Vimeo options as querys for the api call
		params = '&api=true'
		params += '&portrait=false'
		params += '&title=false'
		params += '&badge=false'
		params += '&byline=false'
		params += '&player_id=vimeoplayer'

		# Assemble the url to get a jsonp response
		embedurl = endpoint + '?url=' + encodeURIComponent(vimeoUrl) + '&callback=' + encodeURIComponent(callback) + params

		# Using ajax, just because ajax sounds cool
		# Could probably be a $.getJSON, but is essentially the same thing
		$.ajax(
			dataType: 'jsonp'
			url: embedurl
			crossDomain: true
		).done (data) ->
			# Assemble markup for the video player
			videoMarkup = '<button class="close"></button>'
			videoMarkup += data.html

			# We need to use dynamic injection of the iframe to avoid it adding an entry to window.history
			$('#branded .content .brandsite-video-container .brandsite-video-player').html(videoMarkup)

			jjBrandsiteVideo.showVideo()

	showVideo: ->
		# We'll wait for the iframe to load so the user doesn't see the frame refresh
		$('#branded .content .brandsite-video-container iframe').load (e) ->

			jjBrandsiteVideo.videoContainer = $('#branded .content .brandsite-video-container')
			
			# Using [0] to get the actualt iframe object
			jjBrandsiteVideo.videoFrame = $('#branded .content .brandsite-video-container iframe')[0]
			
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
	jjOriginalsStorefront.assignGlobalVars()
	jjOriginalsStorefront.responsiveHero()
	jjOriginalsStorefront.trackingInit()
	jjOriginalsStorefront.trackingClicks()
	jjOriginalsStorefront.switchImages()

	jjBrandsiteVideo.bindClicks()

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