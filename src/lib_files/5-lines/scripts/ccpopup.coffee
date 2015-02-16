jjCCpopup = do ($) ->

    # Custom functions here

    bowToMeMinion: (email, name, surname, birthday, signupCC) ->
        
        # Var to hold the request
        jjCCpopup.request

		$("#footer_global .modal_form input[name=dwfrm_newsletter_email]").val(email)
		$("#footer_global .modal_form input[name=dwfrm_newsletter_firstName]").val(name)
		$("#footer_global .modal_form input[name=dwfrm_newsletter_lastName]").val(surname)
		$("#footer_global .modal_form input[name=dwfrm_newsletter_dateOfBirth]").val(birthday)
		$("#footer_global .accept-tc input").prop('checked', signupCC)

		# Check if user wants to become a member
		if $("#footer_global .accept-tc input").is(':checked')

			# setup some local variables
			$form = $("#footer_global .modal_form")

			# Let's select and cache all the fields
			$inputs = $form.find("input, select, button, textarea")
			
			# Serialize the data in the form
			serializedData = $form.serialize()

			# Let's disable the inputs for the duration of the ajax jjCCpopup.request
			$inputs.prop("disabled", true)

			# Fire off the jjCCpopup.request to /form.php
			jjCCpopup.request = $.ajax
				url: newsletterProcessSignupURL
				type: "post"
				data: serializedData

			# Callback handler that will be called on success
			jjCCpopup.request.done (response, textStatus, jqXHR) ->

			# Callback handler that will be called on failure
			jjCCpopup.request.fail (jqXHR, textStatus, errorThrown) ->

			# callback handler that will be called regardless
			# if the jjCCpopup.request failed or succeeded
			jjCCpopup.request.always ->
				# reenable the inputs
				$inputs.prop("disabled", false)

	initThisBastard: ->
		# Set the height for animation
		jjCCpopup.popupHeight = $('.customerclub-popup').height() + 10

		# Set init position
		TweenMax.set $('.customerclub-popup'),
			bottom: '-' + jjCCpopup.popupHeight

		# Handling of toggle logic
		$('.customerclub-trigger a').click (e) ->
			e.preventDefault()

			if !jjCCpopup.popupActive
				jjCCpopup.animIn()
			else if jjCCpopup.popupActive
				jjCCpopup.animOut()

	ignore: ->
		# Temporary ignore
		$('.customerclub-popup .close').click (e) ->
			e.preventDefault()

			jjCCpopup.animOut()

			$.cookie 'jjCCpopup_ignore_week', 'true', {expires: 7}, path: '/'
			
			_gaq.push [
				'_trackEvent'
				'jj-cc-popup'
				'action'
				'Hidden, week'
			]

		# Permanent ignore
		$('.customerclub-popup .existingmember').click (e) ->
			e.preventDefault()

			jjCCpopup.animOut();

			$.cookie 'jjCCpopup_ignore_forever', 'true', {expires: 365}, path: '/'
			
			_gaq.push [
				'_trackEvent'
				'jj-cc-popup'
				'action'
				'Hidden, forever'
			]

	initThemCookies: ->
		# Eval if user has chosen to ignore popup
		ignore_week    = $.cookie('jjCCpopup_ignore_week')
		ignore_forever = $.cookie('jjCCpopup_ignore_forever')

		if !ignore_week and !ignore_forever
			jjCCpopup.mayTheCookieBeWithYou()

	mayTheCookieBeWithYou: ->
		# Count the page views
		if $.cookie('jjCCpopup_count')
			counter = $.cookie('jjCCpopup_count')
			counter = parseInt(counter, 10)
			
			$.cookie 'jjCCpopup_count', counter + 1, { expires: 7 }, path: '/'
		else
			$.cookie 'jjCCpopup_count', 1, { expires: 7 }, path: '/'

		# If the count reaches 5, show the popup
		###
		if $.cookie('jjCCpopup_count') is '5'
			jjCCpopup.animIn()

			# Then reset the counter
			$.cookie 'jjCCpopup_count', 1, { expires: 7 }, path: '/'
		###

	animIn: ->
		TweenMax.set $('.customerclub-popup'),
			display: 'block'

		TweenMax.to $('.customerclub-popup'), 0.6, 
			ease:Power2.EaseOut
			bottom: 49
		
		jjCCpopup.popupActive = true;

		_gaq.push [
			'_trackEvent'
			'jj-cc-popup'
			'action'
			'Popup shown'
		]

		# Top secret. Look away.
		if jjCCpopup.egged
			TweenMax.to $('.vader'), 0.6,
				ease:Power2.EaseOut
				bottom: 186

	animOut: ->
		TweenMax.to $('.customerclub-popup'), 0.6, 
			ease:Power2.EaseOut
			bottom: '-' + jjCCpopup.popupHeight

		# Also top secret. Look away again.
		if jjCCpopup.egged
			TweenMax.to $('.vader'), 0.6, 
				ease:Power2.EaseOut
				bottom: -jjCCpopup.popupHeight

		jjCCpopup.popupActive = false

	maskInput: ->
		# Mask the DOB input
		$('.customerclub-popup form .req.dob').mask '99-99-9999', placeholder: 'x'

	submitIt: ->
		$('.customerclub-popup form .submitThisShit').click (e) ->
			e.preventDefault()

			# vars for validation
			mailReg = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;


			$('.customerclub-popup form .req').each ->
				# DOB check
				if $(@).hasClass('dob')
					regDOB = /(\b\d{2}[-.]?\d{2}[-.]?\d{4})\b/.test($('.customerclub-popup form .req.dob').val())

					if !regDOB
						$(@).addClass('fillOutThisShit')
						$('.customerclub-popup form span.dobspan').addClass('fillOutThisShit')
						DOBcheck = false
					else
						$(@).removeClass('fillOutThisShit')
						$('.custumerclub-popup form span.dobspan').removeClass('fillOutThisShit')
						DOBcheck = true
				
				# Checkbox check
				else if $(@).hasClass('chkbox')
					if !$(@).attr('checked')
						$('.customerclub-popup form .spanchk').addClass('checkThisShit')
						boxCHECK = false
					else
						$('.customerclub-popup form .spanchk').removeClass('checkThisShit')
						boxCHECK = true
				
				# Email check
				else if $(@).hasClass('email')
					if !mailReg.test($(@).val())
						$(@).addClass('fillOutThisShit')
						mailCHECK = false
					else
						$(@).removeClass('fillOutThisShit')
						mailCHECK = true
				
				# Name check
				else
					if $(@).val() is null or $(@).val() is ""
						$(@).addClass('fillOutThisShit')
						NAMEcheck = false
					else
						$(@).removeClass('fillOutThisShit')
						NAMEcheck = true
			
			# Only submit if all validations pass
			if NAMEcheck and DOBcheck and mailCHECK and boxCHECK

				email = $('.customerclub-popup .req.email').val()
				firstName = $('.customerclub-popup .req.firstname').val()
				lastName = $('.customerclub-popup .req.lastname').val()
				dob = $('.customerclub-popup .req.dob').val()
				club = $('.customerclub-popup form .club').prop('checked')

				# Top top secret. Look away. Definately not an easter egg. Har har.
				if firstName.toLowerCase() is "darth" and lastName.toLowerCase() is "vader"
					jjCCpopup.iAmYourFather()
				else
					# Submit to CC database
					jjCCpopup.bowToMeMinion(
						email      # email
						firstName  # first name
						lastName   # last name
						dob        # dob
						club       # club signup
					)

					# After you sign up we don't bother you for a year
					$.cookie 'jjCCpopup_ignore_forever', 'true',  {expires: 365}, path: '/'
					
					# Also, thanks
					jjCCpopup.thankyou()

	# Top secret. Look away! Absolutely not an easter egg.
	iAmYourFather: ->
		TweenMax.set $('.vader'), 
			display: 'block'
		
		_gaq.push [
			'_trackEvent'
			'jj-cc-popup'
			'action'
			'Secret easter egg'
		]
		
		jjCCpopup.egged = true

	thankyou: ->
		TweenMax.to $('.customerclub-popup .signup-content'), 0.6,
			height: 0
			ease:Power2.easeOut
		
		TweenMax.to $('.customerclub-popup .thankyou-content'), 0.6,
			height: 150
			ease:Power2.easeOut

		_gaq.push [
			'_trackEvent'
			'jj-cc-popup'
			'action'
			'Signed up'
		]

		setTimeout ->
			jjCCpopup.animOut()
		, 6000

$(document).ready ->
	jjCCpopup.initThisBastard()
	jjCCpopup.ignore()
	jjCCpopup.initThemCookies()
	jjCCpopup.maskInput()
	jjCCpopup.submitIt()