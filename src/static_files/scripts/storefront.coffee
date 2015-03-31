jjStorefront = ((jQuery) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjStorefront.brandsReached = false
		jjStorefront.categoriesReached = false
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
		heroHeight = $('.swiper-slide a:last-child img').height()

		TweenMax.set $('#branded .content .hero.swiper-container'),
			height: heroHeight

	brandHover: ->
		$('#branded .content .storefront-brands .brand').each ->
			# Avoid multiple instances of the hover event
			$(@).off('hover')

			width = $(@).find('.image').width()
			height = $(@).find('.image').height()
			newWidth = width + 10
			newHeight = height + 10

			$(@).find('.image').css('background-size', newWidth + 'px ' + newHeight + 'px')

			$(@).hover ->
				TweenMax.to $(@).find('.overlay'), 0.4,
					opacity: 1
				
				TweenMax.to $(@).find('.image'), 0.4,
					backgroundSize:  width + 'px ' + height + 'px'

				TweenMax.to $(@).find('.buttons'), 0.4,
					delay: 0.2
					opacity: 1
			, ->
				TweenMax.to $(@).find('.overlay'), 0.3,
					opacity: 0
				
				TweenMax.to $(@).find('.image'), 0.3,
					backgroundSize: newWidth + 'px ' + newHeight + 'px'
				
				TweenMax.to $(@).find('.buttons'), 0.3,
					opacity: 0
					overwrite: true

	detectGrid: ->
		jjStorefront.brandHover()
		jjStorefront.resizeHero()

		if jjStorefront.pageIsLoaded
			jjStorefront.viewportHero()

		if !jjStorefront.footerReached
			jjStorefront.trackingScroll()

	initQuickview: ->
		quickViewOptions =
			buttonSelector: null
			imageSelector: null
			buttonLinkSelector: '.quickview'
		
		app.quickView.bindEvents(quickViewOptions)

	trackingInit: ->
		jjStorefront.trackingHighlights()
		jjStorefront.trackingBrands()
		#jjStorefront.trackingCategories()
		jjStorefront.trackingScroll()

	trackingHighlights: ->
		$('#branded .content .storefront-promos ul li').click (e) ->
			# For testing only. Do no include preventDefault() in production code
			# e.preventDefault()
			
			highlightNo = $(@).index() + 1
			link = $(@).find('a').attr('href')
			
			_gaq.push [
				'_trackEvent'
				'jj-storefront-highlights'
				'Click', 'Highlight no: ' + highlightNo + ', link: ' + link
			]

	trackingBrands: ->
		$('#branded .content .storefront-brands .brand').click ->
			brandID = $(@).data('brand')
			_gaq.push [
				'_trackEvent'
				'jj-storefront-brandboxes'
				'Click'
				brandID
			]

	trackingCategories: ->
		$('#branded .content .storefront-categories .gridify .box').each ->
			box = $(@).data('pos-grid')
			week = $(@).data('week')
			product = $(@).data('product')
			category = $(@).data('category')
			image = $(@).data('image')

			$(@).find('a').click ->

				if $(@).hasClass('one')
					_gaq.push [
						'_trackEvent'
						'jj-storefront-categoryboxes'
						'Click'
						'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, product: ' + product
					]

				else if $(@).hasClass('two')
					_gaq.push [
						'_trackEvent'
						'jj-storefront-categoryboxes'
						'Click', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, category: ' + category
					]

				else
					_gaq.push [
						'_trackEvent'
						'jj-storefront-categoryboxes'
						'Click', 'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: image, category: ' + category
					]

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

	trackingScroll: ->
		$(window).scroll ->
			if $('#branded .content .storefront-brands').isInViewport() and !jjStorefront.brandsReached
				_gaq.push [
					'_trackEvent'
					'jj-storefront-scroll'
					'Scroll'
					'Brands in viewport'
				]
				
				jjStorefront.brandsReached = true

			if $('#branded .content .storefront-categories').isInViewport() and !jjStorefront.categoriesReached
				_gaq.push [
					'_trackEvent'
					'jj-storefront-scroll'
					'Scroll'
					'Categories in viewport'
				]
				
				jjStorefront.categoriesReached = true

			if $('#footer_global').isInViewport() and !jjStorefront.footerReached
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
	jjStorefront.brandHover()
	jjStorefront.initQuickview()
	jjStorefront.trackingInit()

$(window).load ->
	jjStorefront.checkHero()
	jjStorefront.viewportHero()
	jjStorefront.clickHero()
	jjStorefront.pageIsLoaded = true

$(window).resize ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjStorefront.detectGrid, 500)

$(window).scroll ->
	# Timeout added to avoid mem overload when resizing
	clearTimeout @id
	@id = setTimeout(jjStorefront.detectGrid, 500)