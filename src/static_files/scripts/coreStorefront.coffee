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
		contentBoxes = $('#branded .content .brandsite-content-boxes')

		offsetWindow = $(window).height() * 0.50
		offsetContent = if contentBoxes.length then contentBoxes.offset().top - offsetWindow else false
		
		$(window).scroll ->
			if offsetContent and $(window).scrollTop() >= offsetContent and !jjCoreStorefront.contentBoxesReached
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

# Callstack, window.scroll
# Timeout added to avoid mem overload when scrolling
$(window).scroll ->
	clearTimeout @id
	@id = setTimeout(jjCoreStorefront.viewportHero, 500)