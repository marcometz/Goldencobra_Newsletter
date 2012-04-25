// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// $(document).ready(function() {
// 	$('#goldencobra-newsletter-registration-submit').bind("click", function(){
// 	  $('.validation_error').each(function() { $(this).remove();});
// 	  var gender_selection = false;
// 	  var male = $("#gender_male");
// 	  var female = $("#gender_female");
// 	  var male_result = (male.attr("checked") != "undefined" && male.attr("checked") == "checked");
// 	  var female_result = (female.attr("checked") != "undefined" && female.attr("checked") == "checked");
//   
// 	  if (male_result == false && female_result == false) {
// 	    $("#gender_female").parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 280px;'>Pflichtangabe</p>");
// 	  }
//   
// 	  if ($('#first_name').attr('value') == '') {
// 	    $('#first_name').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe</p>");
// 	  }
//   
// 	  if ($('#last_name').attr('value') == '') {
// 	    $('#last_name').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe</p>");
// 	  }
//   
// 	  if ($('#company').attr('value') == '') {
// 	    $('#company').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe</p>");
// 	  }
// 
//   
// 	  var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
// 	  if ($('#email').attr('value') == '') {
// 	    $('#email').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe</p>");
// 	  }
// 	  else if(!emailReg.test($('#email').attr('value'))) {
// 	    $('#email').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Email nicht gültig</p>");
// 	  }
//   
// 	});
// });
