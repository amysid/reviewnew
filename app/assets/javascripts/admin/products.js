
// $(document).ready(function(){
$("#admin_new_product").validate({
       ignore: [],
       // debug: false,
   rules: {
     "product[category_name]": {
       required: true,
     },
     "product[sub_category_name]": {
       required: true,
     },
     "product[product_name]": {
       required: true,
       minlength: 3,
       maxlength: 35,
     },
     "product[video]": {
       required: true,
     },
     "product[date]": {
       required: true,
       date: true

     },
},
   messages: {
     "product[category_name]":{
       required: "Please select the category name.",
     },
     "product[sub_category_name]": {
       required: "Please Select Sub category",
     },
      "product[product_name]": {
       required: "Please Write a Product Name",
       minlength: "Minimum characters are 2.",
       maxlength: "Maximum characters are 35.",
     },
      "product[video]": {
       required: "Please Select a Video",
     },
      "product[date]": {
       required: "Please Select a Date",
       date: "Only digits are allowed"

     },
   },
   });
});


$(document).on("turbolinks:load",function(){
$("input.datetimepicker_start").datepicker({
   autoclose: true,
   minDate: 0,

});

$(function() {
 $("input.datetimepicker_start").on('change', function(){
   debugger;
        var date = Date.parse($(this).val());
        if (date < Date.now()){
            alert('Publish Date should be proper format and not of past');
            $(this).val('');
        }

   });
});