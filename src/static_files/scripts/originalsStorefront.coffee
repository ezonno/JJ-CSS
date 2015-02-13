jjOriginalsStorefront = do ($) ->
	
	# Custom functions here
	assignGlobalVars: ->
		# Vars for scrolling track - False should only be set once on load
		jjOriginalsStorefront.brandsReached = false
		jjOriginalsStorefront.categoriesReached = false
		jjOriginalsStorefront.footerReached = false

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
		jjOriginalsStorefront.brandHover()
		jjOriginalsStorefront.resizeHero()

		if jjOriginalsStorefront.pageIsLoaded
			jjOriginalsStorefront.viewportHero()

		if !jjOriginalsStorefront.footerReached
			jjOriginalsStorefront.trackingScroll()

	initQuickview: ->
		quickViewOptions =
			buttonSelector: null
			imageSelector: null
			buttonLinkSelector: '.quickview'
		
		app.quickView.bindEvents(quickViewOptions)

	trackingInit: ->
		jjOriginalsStorefront.trackingCategories()
		jjOriginalsStorefront.trackingScroll()

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
						'jj-originals-storefront'
						'category boxes'
						'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, product: ' + product
					]

				else if $(@).hasClass('two')
					_gaq.push [
						'_trackEvent'
						'jj-originals-storefront'
						'category boxes'
						'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: text, category: ' + category
					]

				else
					_gaq.push [
						'_trackEvent'
						'jj-originals-storefront'
						'category boxes'
						'Box: ' + box + ', week: ' + week + ', image: ' + image + ', clicked: image, category: ' + category
					]

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
				'jj-originals-storefront'
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
				'jj-originals-storefront'
				'hero'
				'Slide: ' + staticHumanIndex + ', week: ' + staticWeek + ', image: ' + staticImage + ', url: ' + staticUrl + ', type: ' + type
			]

	trackingScroll: ->
		$(window).scroll ->
			offsetCategories = $('#branded .content .storefront-categories').offset().top
			offsetFooter = $('#footer_global').offset().top

			$(window).scroll ->
				if $(window).scrollTop() >= offsetCategories and !jjOriginalsStorefront.categoriesReached
					_gaq.push [
						'_trackEvent'
						'jj-originals-storefront'
						'scroll'
						'Category boxes reached'
					]

					jjOriginalsStorefront.categoriesReached = true
				
				else if $(window).scrollTop() >= offsetFooter and !jjOriginalsStorefront.footerReached
					_gaq.push [
						'_trackEvent'
						'jj-originals-storefront'
						'scroll'
						'Footer reached'
					]

					jjOriginalsStorefront.footerReached = true

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
	jjOriginalsStorefront.assignGlobalVars()
	jjOriginalsStorefront.responsiveHero()
	jjOriginalsStorefront.initQuickview()
	jjOriginalsStorefront.trackingInit()
	jjOriginalsStorefront.closeCallout()

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