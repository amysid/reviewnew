// csv file validations
$(document).ready(function() {
    const readSingleFile = () => {
        const fileInput = document.getElementById("fileinput");
        const form = document.getElementById("controls-form");

        if (fileInput.files[0].type !== "text/csv") {
            alert("Accept only CSV file");
            form.reset();
        }
    };
    // Some sweet event listeners!
    //document.getElementById("fileinput").addEventListener("change", readSingleFile, false);
});
// csv file validations end..

//image preview for use edit profile

$(document).ready(function() {
    function preview(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                $('#user_pic')
                    .attr('src', e.target.result);
            };

            reader.readAsDataURL(input.files[0]);
        }
    }
});

//image preview code finish
// $(document).ready(function(){
$(document).on("turbolinks:load",function(){
$("#user_admin_side").validate({
    // ignore[],
    // errorPlacement: function(error, element) {
    //     error.insertBefore(element);
    // },
    rules: {
        "user[name]": {
            required: true,
            minlength: 2,
            maxlength: 15

        },
        "user[mobile_no]": {
            required: true,
            minlength: 7,
            maxlength: 14,
            digitsonly: true
        }
    },
    messages: {
        "user[name]": {
            required: "Please Fill the name field .",
            minlength: "Minimum characters are 2",
            maxlength: "Maximum characters are 15",
        },
        "user[mobile_no]": {
            required: "Please fill the mobile number",
            minlength: "Minimum characters are 7",
            maxlength: "Maximum characters are 14",
            digitsonly: "only digits Please"
        }
    }
});
// })
});
// jQuery.validator.addMethod('lettersonly', function(value, element) {
//     return this.optional(element) || /^[a-z ]+$/i.test(value);
// }, 'letters only Please');
jQuery.validator.addMethod('digitsonly', function(value, element) {
    return this.optional(element) || /^[0-9]+$/i.test(value);
}, 'letters only Please');




