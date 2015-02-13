jjCoreStorefront = do ($) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjCoreStorefront.brandsReached = false
		jjCoreStorefront.categoriesReached = false
		jjCoreStorefront.footerReached = false

	responsiveHero: ->
		$('#branded .content .hero.swiper-container .swiper-slide img').dataImg
			sml: 1260
			med: 1420
			lrg: 1660
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
				$('#branded .content .hero .swiper-prev, #branded .content .hero .swiper-next').css('display' , 'block')
				jjCoreStorefront.displayHero()
			
			onSlideChangeEnd: ->
				if jjCoreStorefront.heroInView
					jjCoreStorefront.trackingHero('View')

		$('#branded .content .hero .swiper-prev').on 'click', (e) ->
			e.preventDefault()
			jjCoreStorefront.jjSwiper.swipePrev()

		$('#branded .content .hero .swiper-next').on 'click', (e) ->
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
		jjCoreStorefront.brandHover()
		jjCoreStorefront.resizeHero()

		if jjCoreStorefront.pageIsLoaded
			jjCoreStorefront.viewportHero()

		if !jjCoreStorefront.footerReached
			jjCoreStorefront.trackingScroll()

	initQuickview: ->
		quickViewOptions =
			buttonSelector: null
			imageSelector: null
			buttonLinkSelector: '.quickview'
		
		app.quickView.bindEvents(quickViewOptions)

	trackingInit: ->
		jjCoreStorefront.trackingCategories()
		jjCoreStorefront.trackingScroll()

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
						'jj-core-storefront'
						'category boxes'
						'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, product: ' + product
					]

				else if $(@).hasClass('two')
					_gaq.push [
						'_trackEvent'
						'jj-core-storefront'
						'category boxes'
						'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, category: ' + category
					]

				else
					_gaq.push [
						'_trackEvent'
						'jj-core-storefront'
						'category boxes'
						'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: image, category: ' + category
					]

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
				'jj-core-storefront'
				'hero'
				'Slide: ' + slideHumanIndex + ', week: ' + slideWeek + ', image: ' + slideImage + ', url: ' + slideUrl + ', type: ' + type
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
				'jj-core-storefront'
				'hero'
				'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl + ', type: ' + type
			]

	trackingScroll: ->
		$(window).scroll ->
			offsetCategories = $('#branded .content .storefront-categories').offset().top
			offsetFooter = $('#footer_global').offset().top

			$(window).scroll ->
				if $(window).scrollTop() >= offsetCategories and !jjCoreStorefront.categoriesReached
					_gaq.push [
						'_trackEvent'
						'jj-core-storefront'
						'scroll'
						'Category boxes reached'
					]

					jjCoreStorefront.categoriesReached = true
				
				else if $(window).scrollTop() >= offsetFooter and !jjCoreStorefront.footerReached
					_gaq.push [
						'_trackEvent'
						'jj-core-storefront'
						'scroll'
						'Footer reached'
					]

					jjCoreStorefront.footerReached = true

	closeCallout: ->
		 $('#branded .content .storefront-promos .storefront-callout button').click (e) ->
			callout = $('#branded .content .storefront-promos .storefront-callout')

			TweenLite.to callout, 0.4, 
				height: 0
				borderWidth: 0
				ease: 'easeOutCubic'

			TweenLite.to callout.parent(), 0.4, 
				marginTop: 0
				ease: 'easeOutCubic'

	# End custom functions

$(document).ready ->
	jjCoreStorefront.assignGlobalVars()
	jjCoreStorefront.responsiveHero()
	jjCoreStorefront.initQuickview()
	jjCoreStorefront.trackingInit()
	jjCoreStorefront.closeCallout()

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