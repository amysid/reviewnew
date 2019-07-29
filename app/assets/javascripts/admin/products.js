// $(document).ready(function(){
jQuery.validator.addMethod("minlengthxo", function (value, element,param) {
  originalVal = CKEDITOR.instances.editor1.getData().replace(/<[^>]*>/g, '');
  var length = $.isArray( originalVal ) ? value.length : this.getLength( originalVal, element );
  return length >= param;
}, "default errorMessage");
// $(document).ready(function(){
$(document).on("turbolinks:load",function(){

$("#admin_product").validate({
  ignore: [],
    rules: {
      "product[product_name]":{
        required: true,
        minlength: 3,
        maxlength: 64
      },
      "faqs[answer]":{
        required: function() 
        {
          CKEditorUpdate();                        
        }, 
        minlength: 3,
        maxlength: 100
      },      
    }
  });
  // });
  function CKEditorUpdate(){
    for(instance in CKEDITOR.instances){
       CKEDITOR.instances[instance].updateElement();
 }
}
// });
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

