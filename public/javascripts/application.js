console.log('hello');

$('.login-btn').click(function() {
  $('.login-popup-wrap').toggle();
})

jQuery.validator.addMethod( 'passwordMatch', function(value, element) {

    // The two password inputs
    var password = $("#register-password").val();
    var confirmPassword = $("#register-pass-confirm").val();

    // Check for equality with the password inputs
    if (password != confirmPassword ) {
        console.log('false');
        return false;
    } else {
        console.log('true');
        return true;
    }

}, "Your Passwords Must Match");

$('#form-register').validate({
    // rules
    rules: {
        register_password: {
            required: true,
            minlength: 3
        },
        register_pass_confirm: {
            required: true,
            minlength: 3,
            passwordMatch: true // set this on the field you're trying to match
        }
    },

    // messages
    messages: {
        register_password: {
            required: "What is your password?",
            minlength: "Your password must contain more than 3 characters"
        },
        register_pass_confirm: {
            required: "You must confirm your password",
            minlength: "Your password must contain more than 3 characters",
            passwordMatch: "Your Passwords Must Match" // custom message for mismatched passwords
        }
    }
});//end validate
