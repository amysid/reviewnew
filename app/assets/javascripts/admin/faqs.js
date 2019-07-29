// // Add New and Edit Road map vaildation start.
// $(document).ready(function(){

jQuery.validator.addMethod("minlengthxo", function (value, element,param) {
  originalVal = CKEDITOR.instances.editor1.getData().replace(/<[^>]*>/g, '');
  var length = $.isArray( originalVal ) ? value.length : this.getLength( originalVal, element );
  return length >= param;
}, "default errorMessage");
// $(document).ready(function(){
$(document).on("turbolinks:load",function(){
$("#admin_faq").validate({
  ignore: [],
    rules: {
      "faqs[question]":{
        required: true,
        minlength: 20,
        maxlength: 100
      },
      "faqs[answer]":{
        required: function() 
        {
          CKEditorUpdate();                        
        }, 
        minlength: 20,
        maxlength: 500
      },      
    }
  });
  function CKEditorUpdate(){
    for(instance in CKEDITOR.instances){
       CKEDITOR.instances[instance].updateElement();
 }
}
  });
// });

// // Add New and Edit Road map validation finish.