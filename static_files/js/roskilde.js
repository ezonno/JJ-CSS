var jjRoskilde = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
         
		ScreamForMeRoskilde : function(email, name, surname, birthday, signupTC, signupCC) {

			// variable to hold request
			jjRoskilde.request;
			jjRoskilde.request2;

		    $(".modal_form textarea[name=dwfrm_newsletter_answerFree__1]").val();
		    $(".modal_form input[name=dwfrm_newsletter_email]").val(email);
		    $(".modal_form input[name=dwfrm_newsletter_firstName]").val(name);
		    $(".modal_form input[name=dwfrm_newsletter_lastName]").val(surname);
		    $(".modal_form input[name=dwfrm_newsletter_dateOfBirth]").val(birthday);
		    $(".accept-tc input").prop('checked', signupCC);
		    $(".accept-tc-comp input").prop('checked', signupTC);

		    // check if user wants to become a member
		    if($(".accept-tc input").is(':checked')) {
		        // abort any pending jjRoskilde.request
		        if (jjRoskilde.request) {
		            jjRoskilde.request.abort();
		        }
		        // setup some local variables
		        var $form = $(".modal_form");
		        // let's select and cache all the fields
		        var $inputs = $form.find("input, select, button, textarea");
		        // serialize the data in the form
		        var serializedData = $form.serialize();

		        // let's disable the inputs for the duration of the ajax jjRoskilde.request
		        $inputs.prop("disabled", true);

		        // fire off the jjRoskilde.request to /form.php
		        jjRoskilde.request = $.ajax({
		            url: newsletterProcessSignupURL,
		            type: "post",
		            data: serializedData
		        });

		        // callback handler that will be called on success
		        jjRoskilde.request.done(function (response, textStatus, jqXHR){
		        });

		        // callback handler that will be called on failure
		        jjRoskilde.request.fail(function (jqXHR, textStatus, errorThrown){
		        });

		        // callback handler that will be called regardless
		        // if the jjRoskilde.request failed or succeeded
		        jjRoskilde.request.always(function () {
		            // reenable the inputs
		            $inputs.prop("disabled", false);
		        });
		    }

		    // check if user wants to participate to the competition
		    if($(".accept-tc-comp input").is(':checked')) {
		        $("#email_form input[name=mandatoryQuestion_1]").val($(".modal_form textarea[name=dwfrm_newsletter_answerFree__1]").val()+" , country: "+$("input.core-country").val());
		        $("#email_form input[name=mandatoryQuestion_2]").val("signed up to customer club: "+$(".accept-tc input").is(':checked'));
		        $("#email_form input[name=mandatoryEmail]").val($(".modal_form input[name=dwfrm_newsletter_email]").val());
		        $("#email_form input[name=mandatoryFirstName]").val($(".modal_form input[name=dwfrm_newsletter_firstName]").val());
		        $("#email_form input[name=mandatoryLastName]").val($(".modal_form input[name=dwfrm_newsletter_lastName]").val());
		//$("#email_form input[name=mandatoryLastName]").val("NaN");

		        // abort any pending jjRoskilde.request
		        if (jjRoskilde.request2) {
		            jjRoskilde.request2.abort();
		        }
		        // setup some local variables
		        var $form2 = $("#email_form");
		        var $inputs2 = $form2.find("input, select, button, textarea");
		        // serialize the data in the form
		        var serializedData2 = $form2.serialize();

		        // let's disable the inputs for the duration of the ajax jjRoskilde.request
		        $inputs2.prop("disabled", true);

		        // fire off the jjRoskilde.request to /form.php
		        jjRoskilde.request2 = $.ajax({
		            url: cusomEmailsFormURL,
		            type: "post",
		            data: serializedData2
		        });

		        // callback handler that will be called on success
		        jjRoskilde.request2.done(function (response, textStatus, jqXHR){
		        });

		        // callback handler that will be called on failure
		        jjRoskilde.request2.fail(function (jqXHR, textStatus, errorThrown){
		        });

		        // callback handler that will be called regardless
		        // if the jjRoskilde.request failed or succeeded
		        jjRoskilde.request2.always(function () {
		            // reenable the inputs
		            $inputs2.prop("disabled", false);
		        });
		    }
		}
   
        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {

});