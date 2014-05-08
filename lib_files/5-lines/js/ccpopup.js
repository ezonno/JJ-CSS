var jjCCpopup = (function (jQuery) {
    if (!jQuery) {
        alert(app.resources["MISSING_LIB"]);
        return null;
    }

    if (!window.console) console = {log: function() {}};

    return {

        // custom functions here
         
            bowToMeMinion : function(email, name, surname, birthday, signupCC) {

                // variable to hold request
                jjCCpopup.request;

                $(".modal_form input[name=dwfrm_newsletter_email]").val(email);
                $(".modal_form input[name=dwfrm_newsletter_firstName]").val(name);
                $(".modal_form input[name=dwfrm_newsletter_lastName]").val(surname);
                $(".modal_form input[name=dwfrm_newsletter_dateOfBirth]").val(birthday);
                $(".accept-tc input").prop('checked', signupCC);

                // check if user wants to become a member
                if($(".accept-tc input").is(':checked')) {
                    // abort any pending jjRoskilde.request
                    if (jjCCpopup.request) {
                        jjCCpopup.request.abort();
                    }
                    // setup some local variables
                    var $form = $(".modal_form");
                    // let's select and cache all the fields
                    var $inputs = $form.find("input, select, button, textarea");
                    // serialize the data in the form
                    var serializedData = $form.serialize();

                    // let's disable the inputs for the duration of the ajax jjCCpopup.request
                    $inputs.prop("disabled", true);

                    // fire off the jjCCpopup.request to /form.php
                    jjCCpopup.request = $.ajax({
                        url: newsletterProcessSignupURL,
                        type: "post",
                        data: serializedData
                    });

                    // callback handler that will be called on success
                    jjCCpopup.request.done(function (response, textStatus, jqXHR){
                    });

                    // callback handler that will be called on failure
                    jjCCpopup.request.fail(function (jqXHR, textStatus, errorThrown){
                    });

                    // callback handler that will be called regardless
                    // if the jjCCpopup.request failed or succeeded
                    jjCCpopup.request.always(function () {
                        // reenable the inputs
                        $inputs.prop("disabled", false);
                    });
                }
            },

            initThisBastard : function () {
                jjCCpopup.popupHeight = $('.customerclub-popup').height() + 10;

                TweenMax.set($('.customerclub-popup'), {bottom: '-' + jjCCpopup.popupHeight});

                $('.customerclub-trigger a').click(function(){
                    if (!jjCCpopup.popupActive) {
                        jjCCpopup.animIn();
                    } else if (jjCCpopup.popupActive) {
                        jjCCpopup.animOut();
                    }
                });
            },

            animIn : function () {
                TweenMax.set($('.customerclub-popup'), {display: 'block'});
                TweenMax.to($('.customerclub-popup'), 0.6, {ease:Power2.EaseOut, bottom: 60});
                jjCCpopup.popupActive = true;

                if (jjCCpopup.egged) {
                    TweenMax.to($('.vader'), 0.6, {ease:Power2.EaseOut, bottom: 200});
                }
            },

            animOut : function () {
                TweenMax.to($('.customerclub-popup'), 0.6, {ease:Power2.EaseOut, bottom: '-' + jjCCpopup.popupHeight});

                if (jjCCpopup.egged) {
                    TweenMax.to($('.vader'), 0.6, {ease:Power2.EaseOut, bottom: -jjCCpopup.popupHeight});
                }

                jjCCpopup.popupActive = false;
            },

            maskInput : function () {
                $('.customerclub-popup form .req.dob').mask("99-99-9999", {placeholder:"x"});
            },
            
            submitIt : function () {
                $('.customerclub-popup form .submitThisShit').click(function(e){
                    e.preventDefault();

                    var NAMEcheck, DOBcheck, boxCHECK, mailCHECK;
                    var mailReg = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;


                    $('.customerclub-popup form .req').each(function() {
                        if ($(this).hasClass('dob')) {
                            var regDOB = /(\b\d{2}[-.]?\d{2}[-.]?\d{4})\b/.test($('.customerclub-popup form .req.dob').val());

                            if (!regDOB) {
                                $(this).addClass('fillOutThisShit');
                                $('.customerclub-popup form span.dobspan').addClass('fillOutThisShit');
                                DOBcheck = false;
                            } else {
                                $(this).removeClass('fillOutThisShit');
                                $('.custumerclub-popup form span.dobspan').removeClass('fillOutThisShit');
                                DOBcheck = true;
                            }
                        } else if ($(this).hasClass('chkbox')) {
                            if (!$(this).attr('checked')) {
                                $('.customerclub-popup form .spanchk').addClass('checkThisShit');
                                boxCHECK = false;
                            } else {
                                $('.customerclub-popup form .spanchk').removeClass('checkThisShit');
                                boxCHECK = true;
                            }
                        } else if ($(this).hasClass('email')) {
                            if(!mailReg.test($(this).val())) {
                                $(this).addClass('fillOutThisShit');
                                mailCHECK = false;
                            } else {
                                ($(this).removeClass('fillOutThisShit'));
                                mailCHECK = true;
                            }
                        } else {
                            if($(this).val() === null || $(this).val() === "") {
                                $(this).addClass('fillOutThisShit');
                                NAMEcheck = false;
                            } else {
                                ($(this).removeClass('fillOutThisShit'));
                                NAMEcheck = true;
                            }
                        }
                    });

                    console.log(NAMEcheck, DOBcheck, mailCHECK, boxCHECK);
                    

                    if (NAMEcheck && DOBcheck && mailCHECK && boxCHECK) {

                        var email = $('.customerclub-popup .req.email').val();
                        var firstName = $('.customerclub-popup .req.firstname').val();
                        var lastName = $('.customerclub-popup .req.lastname').val();
                        var dob = $('.customerclub-popup .req.dob').val();
                        var club = $('.customerclub-popup form .club').prop('checked');

                        console.log(email, firstName, lastName, dob, club);

                        if (firstName.toLowerCase() === "darth" && lastName.toLowerCase() === "vader") {
                            jjCCpopup.iAmYourFather();
                        } else {
                            jjCCpopup.bowToMeMinion(
                                email,      // email
                                firstName,  // first name
                                lastName,   // last name
                                dob,        // dob
                                club        // club signup
                            );

                            jjCCpopup.thankyou();
                        }
                    }
                });
            },

            iAmYourFather : function () {
                TweenMax.set($('.vader'), {display: 'block'});
                jjCCpopup.egged = true;
            },

            thankyou : function () {

            },
        // end custom functions
    };
})(jQuery);

jQuery(document).ready(function () {
    jjCCpopup.initThisBastard();
    jjCCpopup.maskInput();
    jjCCpopup.submitIt();
});