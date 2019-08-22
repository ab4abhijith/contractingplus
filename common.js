//multiple Select


$(function () {
window.setTimeout(function() {
    $(".alert").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove(); 
    });
}, 6000);

	
    //     $('select[multiple].active.3col').multiselect({
    //         columns: 2,
    //         placeholder: 'Select Services',
    //         search: true,
    //         searchOptions: {
    //             'default': 'Search Services'
    //         },
    //         selectAll: false
    //     });

    });

  
   $('.button-left').click(function(){
       $('.sidebar').toggleClass('fliph');
	   $('.conent-wrap').toggleClass('conent-full');
   });
     
	 
	              ///dropdownbox toggling
	
	
	$('select').on('change', function() {
           
		   if(this.value.match('Kazim Fahad')){
			   $("#rohit").hide();
			    $("#priyanka").hide();
				 $("#katherine").show();
				  $("#sobhita").show();
				
			}
			 if(this.value.match('All Staff')){
			   $("#rohit").show();
			    $("#priyanka").show();
				 $("#katherine").show();
				  $("#sobhita").show();
			}
			 if(this.value.match('Mikky Hussin')){
			   $("#rohit").hide();
			    $("#priyanka").hide();
				 $("#katherine").hide();
				  $("#sobhita").hide();
			}
			 if(this.value.match('Hima shetty')){
			   $("#rohit").hide();
			    $("#priyanka").show();
				 $("#katherine").hide();
				  $("#sobhita").hide();
			}
			 if(this.value.match('Aishwarya Rai')){
			   $("#rohit").hide();
			    $("#priyanka").hide();
				 $("#katherine").hide();
				  $("#sobhita").hide();
			}
			 if(this.value.match('Diana Hayden')){
			   $("#rohit").show();
			    $("#priyanka").hide();
				 $("#katherine").hide();
				  $("#sobhita").hide();
			}
      })
	  
	  
	  
	  


 $('#rohit').hover(function(){
       $('#view-rohit').toggleClass('view-service');
   });
 $('#priyanka').hover(function(){
       $('#view-priyanka').toggleClass('view-service');
   });
    $('#katherine').hover(function(){
       $('#view-katherine').toggleClass('view-service');
   });
     $('#sobhita').hover(function(){
       $('#view-sobhita').toggleClass('view-service');
   });

//--------------

    $(".close-forgot").click(function(){
        $("#forgot-form").hide();
    });
    $(".forgot").click(function(){
        $("#forgot-form").show();
    });
	

//  New Close

  $("#close-btn").click(function(){
        $("#new-close-form").hide();
    });
    $("#new-close").click(function(){
        $("#new-close-form").show();
    });
	
//  New Edit

  $("#close-edit-btn").click(function(){
        $("#new-close-edit").hide();
    });
    $("#close-edit").click(function(){
        $("#new-close-edit").show();
    });	
	
//  New Delete

  $("#close-delete-btn").click(function(){
        $("#new-close-delete").hide();
    });
    $("#close-delete").click(function(){
        $("#new-close-delete").show();
    });	
	
//  Calendar Close

  $("#calendar-close-btn").click(function(){
        $("#calendar-close").hide();
    });
    $(".close-details").click(function(){
        $("#calendar-close").show();
    });	
	
//  Edit Staff Hours

  $("#close-btn").click(function(){
        $("#edit-staff-hours").hide();
    });
    $(".open").click(function(){
        $("#edit-staff-hours").show();

    });		


// History Details
  $("#close-history").click(function(){
        $("#history-details").hide();
    });
    $(".view-history").click(function(){
    	var comments = $(this).attr("data-notes");
    	$( "p.comments" ).html( comments );
        $("#history-details").show();
    });	




// Color Box in gallery
			
			$(document).ready(function(){
				  var conceptName = $('#selectBox').find(":selected").text();
              
				  //console.log(conceptName);
				//Examples of how to assign the Colorbox event to elements
				
		
				$(".group1").colorbox({rel:'group1'});
				$(".youtube").colorbox({iframe:true, innerWidth:640, innerHeight:390});
				$(".group1").colorbox({rel:'group1'});
				
				
				//Example of preserving a JavaScript event for inline calls.
				$("#click").click(function(){ 
					$('#click').css({"background-color":"#f00", "color":"#fff", "cursor":"inherit"}).text("Open this window again and this message will still be here.");
					return false;
				});
			});
			
   

   /*$('.button-left').click(function(){
       $('.sidebar').toggleClass('fliph');
	   $('.conent-wrap').toggleClass('conent-full');
   });*/
     
	 
	              ///dropdownbox toggling
	
	
	$('select').on('change', function() {
           
		   if(this.value.match('Kazim Fahad')){
			   $("#rohit").hide();
			    $("#priyanka").hide();
				 $("#katherine").show();
				  $("#sobhita").show();
				
			}
			 if(this.value.match('All Staff')){
			   $("#rohit").show();
			    $("#priyanka").show();
				 $("#katherine").show();
				  $("#sobhita").show();
			}
			 if(this.value.match('Mikky Hussin')){
			   $("#rohit").hide();
			    $("#priyanka").hide();
				 $("#katherine").hide();
				  $("#sobhita").hide();
			}
			 if(this.value.match('Hima shetty')){
			   $("#rohit").hide();
			    $("#priyanka").show();
				 $("#katherine").hide();
				  $("#sobhita").hide();
			}
			 if(this.value.match('Aishwarya Rai')){
			   $("#rohit").hide();
			    $("#priyanka").hide();
				 $("#katherine").hide();
				  $("#sobhita").hide();
			}
			 if(this.value.match('Diana Hayden')){
			   $("#rohit").show();
			    $("#priyanka").hide();
				 $("#katherine").hide();
				  $("#sobhita").hide();
			}
      })
	  
	  
	  
	  


 $('#rohit').hover(function(){
       $('#view-rohit').toggleClass('view-service');
   });
 $('#priyanka').hover(function(){
       $('#view-priyanka').toggleClass('view-service');
   });
    $('#katherine').hover(function(){
       $('#view-katherine').toggleClass('view-service');
   });
     $('#sobhita').hover(function(){
       $('#view-sobhita').toggleClass('view-service');
   });

//--------------

    $(".close-forgot").click(function(){
        $("#forgot-form").hide();
    });
    $(".forgot").click(function(){
        $("#forgot-form").show();
    });
	

//  New Close

  $("#close-btn").click(function(){
        $("#new-close-form").hide();
    });
    $("#new-close").click(function(){
        $("#new-close-form").show();
    });
	
//  New Edit

  $("#close-edit-btn").click(function(){
        $("#new-close-edit").hide();
    });
    $("#close-edit").click(function(){
        $("#new-close-edit").show();
    });	
	
//  New Delete

  $("#close-delete-btn").click(function(){
        $("#new-close-delete").hide();
    });
    $("#close-delete").click(function(){
        $("#new-close-delete").show();
    });	
	
//  Calendar Close

  $("#calendar-close-btn").click(function(){
        $("#calendar-close").hide();
    });
    $(".cancel-btn-appointment").click(function(){
    	var cust_name= $("#cust_name").val();
    	$("#hidden_date").val(cust_name);
    	cancel_txt= "Are you sure you want to cancel this appointment with "+cust_name+"?";
    	email_txt = "*An email will be sent to "+cust_name;
    	$("div.reg-wrap #appnt_text").text(cancel_txt);
    	$("div.reg-wrap #emailtxt").text(email_txt);
        $("#calendar-close").show();
    });		
	

	//  Edit Staff Hours

  $("#edit-close-btn").click(function(){
        $("#edit-staff-hours").hide();
    });
  
    $('.staff_table').on('click', '.open', function(e){
    	var staff_name = $(this).attr("data-staff");
    	var staff_id = $(this).attr('id');
    	var staff_date = $(this).attr("data-date");
    	var e_time = $(this).attr("data-end");
    	var s_time = $(this).attr("data-start");
    	var s_id = $(this).attr("data-id");
    	$("#hidden_date").val(staff_date);
    	$("#hidden_id").val(s_id);
    	$("#hidden_identify").val(staff_id);
    	var staff_date_split = staff_date.split(" ");
    	$("div#edit-staff-hours p").html(staff_date);
    	$("div#edit-staff-hours h2").html('Edit'+'   '+staff_name+'   '+'Hours');

    	var data = {
    		'action' : 'staff_working_time',
    		'data' : { 'startTime' :s_time,
    					'endTime':e_time,
    					'day':staff_date_split[0].toLowerCase()
    				}
		};
    	$.post(ajaxurl, data,
		  function (response) 
		  {
		  	var obj = $.parseJSON(response);
		  	$(".starttimesel").html(obj.start_time);
		  	$(".endtimesel").html(obj.end_time);
		  });
        $("#edit-staff-hours").show();
         var nodelete = $("i", this).attr("data-nodelete");
         if(nodelete =="No")
         {
         	$('#delete_button').hide();
     	 }
	     else
	     {
	     	 $('#delete_button').show();
	     }
    });		

// Color Box in gallery
			
			$(document).ready(function(){
				  var conceptName = $('#selectBox').find(":selected").text();
				$(".group1").colorbox({rel:'group1'});
				$(".youtube").colorbox({iframe:true, innerWidth:640, innerHeight:390});
				$(".group1").colorbox({rel:'group1'});
				
				
				//Example of preserving a JavaScript event for inline calls.
				$("#click").click(function(){ 
					$('#click').css({"background-color":"#f00", "color":"#fff", "cursor":"inherit"}).text("Open this window again and this message will still be here.");
					return false;
				});
			});


//  enable and disable select options using checkbox
			
			function enableEdit(checked){
				if(!checked){
					document.getElementById('a').disabled = true;
					document.getElementById('b').disabled = true;
				}
				else{
					document.getElementById('a').disabled = false;
					document.getElementById('b').disabled = false;
				}
			}
// enabling and disabling select group

			function enableText(checked,id){
				if(!checked){
				
					document.getElementById('a').disabled = true;
					document.getElementById('b').disabled = true;
				}
				else{
					document.getElementById('a').disabled = false;
					document.getElementById('b').disabled = false;
				}
			}
			function enableText1(checked){
				if(!checked){
					
					document.getElementById('c').disabled = true;
					document.getElementById('d').disabled = true;
				}
				else{
					document.getElementById('c').disabled = false;
					document.getElementById('d').disabled = false;
				}
			}
			function enableText2(checked){
				if(!checked){
					
					document.getElementById('e').disabled = true;
					document.getElementById('f').disabled = true;
				}
				else{
					document.getElementById('e').disabled = false;
					document.getElementById('f').disabled = false;
				}
			}
			function enableText3(checked){
				if(!checked){
					
					document.getElementById('g').disabled = true;
					document.getElementById('h').disabled = true;
				}
				else{
					document.getElementById('g').disabled = false;
					document.getElementById('h').disabled = false;
				}
			}
			function enableText4(checked){
				if(!checked){
					
					document.getElementById('i').disabled = true;
					document.getElementById('j').disabled = true;
				}
				else{
					document.getElementById('i').disabled = false;
					document.getElementById('j').disabled = false;
				}
			}
			function enableText5(checked){
				if(!checked){
					
					document.getElementById('k').disabled = true;
					document.getElementById('l').disabled = true;
				}
				else{
					document.getElementById('k').disabled = false;
					document.getElementById('l').disabled = false;
				}
			}
			function enableText6(checked){
				if(!checked){
					
					document.getElementById('m').disabled = true;
					document.getElementById('n').disabled = true;
				}
				else{
					document.getElementById('m').disabled = false;
					document.getElementById('n').disabled = false;
				}
			}
// Staff Date Picker
// $(document).ready(function(){  
//   var input = document.querySelector('input[name="date"]');
//             var picker = datepicker(input);
//         });