$( document ).ready(function() {
  $("#paper_style").change(function(){
    window.location.href ="./" + $("#paper_style").val();
  });
});
