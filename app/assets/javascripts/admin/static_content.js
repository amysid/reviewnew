// $(document).ready(function(){
jQuery.validator.addMethod("minlengthxo", function (value, element,param) {
  originalVal = CKEDITOR.instances.editor1.getData().replace(/<[^>]*>/g, '');
  var length = $.isArray( originalVal ) ? value.length : this.getLength( originalVal, element );
  return length >= param;
}, "default errorMessage");
// $(document).ready(function(){
$(document).on("turbolinks:load",function(){

$("#static_content_edit").validate({
  ignore: [],
    rules: {
      "static_content[title]":{
        required: true,
        minlength: 5,
        maxlength: 64
      },
      "static_content[description]":{
        required: function() 
        {
          CKEditorUpdate();                        
        }, 
        minlength: 20,
        maxlength: 1000
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