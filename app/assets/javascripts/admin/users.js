// csv file validations
$(document).ready(function(){
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

// $(document).ready(function(){
//  function preview(input) {
//            if (input.files && input.files[0]) {
//                var reader = new FileReader();
//                  reader.onload = function (e) {
//                    $('#user_pic')
//                        .attr('src', e.target.result);
//                };

//                reader.readAsDataURL(input.files[0]);
//            }
//        }
// });

//image preview code finish