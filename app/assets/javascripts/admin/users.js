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
document
 .getElementById("fileinput")
 .addEventListener("change", readSingleFile, false);
});
// csv file validations end..