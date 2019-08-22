
 ( function( $ ) {
  //Salon Registration
    $("#ajax-contact-form").validate({
        rules: {
            saloon_name: {
              required: true
            },
            manager_name: {
              required: true
                        },
            start_time: {
              required: true
                        },
            end_time: {
              required: true
                        },
            profile_image: {
              required: true,
                        },
            available_for:{
              required: true
                        },
            email: {
              required: true
                        },
            phone: {
              required: true
                        },
            address: {
              required: true
                        },
            city: {
              required: true
                        },
            zip_code: {
              required: true
                        },
            create_pass: {
              required: true
                        },
            confirm_pass: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) 
        {
            if ($('.err')[0]) {
                // swal('Oops...','Something went wrong','error')
                $('#common-alert').show();
                $('#common_alert_text').html('Oops!!!');
                $('#common_alert_desc').html('Appointments Not Allowed For Past Time');
                return false;
            }
            form_data = $(form).serialize();
            if (form_data) 
            {
                // $('.loading').show();
                $.post(ajaxurl, 'action=register&' + form_data,
                        function (response) 
                        {
                            obj = JSON.parse(response);
                            if (obj.status == 'true') 
                            {
                                $('#ajax-contact-form').trigger("reset");
                                var url= obj.login_redirect;
                                window.location.href = url;
                            }
                            else 
                            {
                                $('#common-alert').empty();
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                // swal({
                                //             title: obj.title,
                                //             text: obj.message,
                                //             type: "error",
                                //         });
                            }
                        });       
            }     
        }
    });

//image upload
function readURL(input) 
{

    if (input.files && input.files[0]) 
    {
        var reader = new FileReader();
        reader.onload = function(e) 
        {
           $("#p_image_val").val(e.target.result);
        }
        reader.readAsDataURL(input.files[0]);
    }
}

$("#chooseFile").change(function() 
{
  readURL(this);
});



//login
 $("#login_form").validate({
        rules: {
            email: {
              required: true
                        },
            pass: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) {
            var post = {};
            form_data = $(form).serialize();
            if (post) {
                $('.loading').show();
                $.post(ajaxurl, 'action=salon_login&' + form_data,
                        function (response,status,headers) {
                            var obj = $.parseJSON(response);
                            if(headers.status== 200)
                            {
                                  if (obj.status == 'success') {
                                        setTimeout(function() {
                                            var url= obj.login_redirect;
                                            window.location.href = url; 
                                        }, 1000);
                                    }
                                    else if (obj.status == 'failed') {
                                        $('.loading').hide();
                                        // swal({
                                        //     title: obj.title,
                                        //     text: obj.message,
                                        //     confirmButtonColor: "#16A12E",
                                        //     type: "error",
                                        //     confirmButtonText: "Ok"
                                        // });
                                        $('#common-alert').show();
                                        $('#common_alert_text').html(obj.title);
                                        $('#common_alert_desc').html(obj.message);

                                    } else {
                                        $('.loading').hide();
                                        // swal({
                                        //     title: obj.title,
                                        //     text: obj.message,
                                        //     confirmButtonColor: "#16A12E",
                                        //     type: "info",
                                        //     confirmButtonText: "Ok"
                                        // });
                                        $('#common-alert').show();
                                        $('#common_alert_text').html(obj.title);
                                        $('#common_alert_desc').html(obj.message);
                                    }
                            }
                          else
                          {
                            // swal({
                            //         title: "Invalid",
                            //         text: "Unable to process the request",
                            //         type: "error"
                            //     });
                            $('#common-alert').show();
                            $('#common_alert_text').html('Invalid');
                            $('#common_alert_desc').html('Unable to process the request');
                          }
                        }
                );
            }
        }    
    });


//FORGOT

 $("#forgot_form").validate({
        rules: {
            forgot_email: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) {
            var post = {};
            form_data = $(form).serialize();
            if (post) {
                $.post(ajaxurl, 'action=forgot_password&' + form_data,
                        function (response) {
                           var obj = $.parseJSON(response);
                            if (obj.status == 'success') {
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     type: "success",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                               setTimeout(function() {
                                    var url= obj.login_redirect;
                                    window.location.href = url; 
                                }, 2000); 
                            }
                            else if (obj.status == 'failed') {
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                    var url= obj.login_redirect;
                                    window.location.href = url; 
                                }, 2000);
                            } else {
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "info",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                            }
                        }
                );
            }
        }
    });


//reset password
$("#reset_form").validate({
        rules: {
            new_password: {
              required: true
                        },
            cnfm_password: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) {
            var button = $('.forgot-btn');
           button.prop('disabled', true);
            var post = {};
            form_data = $(form).serialize();
            if (post) {
                $.post(ajaxurl, 'action=reset_pass&' + form_data,
                        function (response) {
                           var obj = $.parseJSON(response);
                            if (obj.status == 'true') {
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     type: "success",
                                //     showConfirmButton: false  
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                    var url= obj.login_redirect;
                                    window.location.href = url; 
                                }, 2000);

                                
                            }
                            else {
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "info",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                var url= obj.login_redirect;
                                window.location.href = url; 
                            }
                        }
                );
            }
        }
    });


//update profile
$("#updateform").validate({
        rules: {
            saloon_name: {
              required: true
            },
            manager_name: {
              required: true
                        },
            start_time: {
              required: true
                        },
            end_time: {
              required: true
                        },
            available_for:{
              required: true
                        },
            email: {
              required: true
                        },
            phone: {
              required: true
                        },
            address: {
              required: true
                        },
            city: {
              required: true
                        },
            zip_code: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $('.loading').show();
                $.post(ajaxurl, 'action=update_profile&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                            if (obj.status == 'success') {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     type: "success",
                                //     confirmButtonText: "Ok" 
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                location.reload();
                            }
                            else {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                            }
                        });       
            }     
        }
    });





//reset password profile
$("#reset-profile-password").validate({
        rules: {
            current_pass: {
              required: true
            },
            new_pass: {
              required: true
                        },
            cnfm_pass: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $('.loading').show();
                $.post(ajaxurl, 'action=reset_profile_pass&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                            console.log(obj);
                            if (obj.status == 'true') {
                                $('.loading').hide();
                                document.getElementById("reset-profile-password").reset();
                                $(".oldpasscondition" ).remove();
                                $('#current_pass').removeClass('invalid');
                                // swal({
                                //     title: obj.title,
                                //     text:  obj.message,
                                //     type: "success",
                                //     confirmButtonText: "Ok" 
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                location.reload();
                            }
                            else if(obj.status == 'failed'){
                                $('.loading').hide();
                                $('#current_pass').focusout(function(event) 
                                {
                                    $('#current_pass').removeClass('invalid');
                                    $( ".oldpasscondition" ).remove();
            
                                });
                                $('#current_pass').addClass('invalid');
                                $('#current_pass').after('<label class="oldpasscondition">Current password does not match</label>');
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                            }
                            else
                            {
                                $('.loading').hide();
                                document.getElementById("reset-profile-password").reset();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                            }
                        });       
            }     
        }
    });

//add close date
$("#add_close_form").validate({
        rules: {
            start_date: {
              required: true
            },
            end_date: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=add_closed_date&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                            if (obj.status == 'success') {
                                $('.loading').show();
                                // swal({
                                //     title: obj.title,
                                //     text:  obj.message,
                                //     type: "success",
                                //     showConfirmButton: false  
                                // });
                                setTimeout(function() {
                                    $('.loading').hide();
                                var url = window.location.href;  
                                var url = url.replace( "#/", "" );  
                                if (url.indexOf('?') > -1){
                                    url += '&clsdt=1'
                                }else{
                                url += '?clsdt=1'
                                }
                            window.location.href = url;
                                }, 2000);
                                   
                            }
                            else {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&clsdt=1'
                                }else{
                                   new_url += '?clsdt=1'
                                }
                                window.location.href = new_url;
                                 }, 2000);
                            }
                        });       
            }     
        }
    });



//edit close date
$("#edit_close_form").validate({
        rules: {
            startdate: {
              required: true
            },
            enddate: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=edit_closed_date&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                            if (obj.status == 'success') {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text:  obj.message,
                                //     type: "success",
                                //     showConfirmButton: false  
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&clsdt=1'
                                }else{
                                   new_url += '?clsdt=1'
                                }
                                window.location.href = new_url;
                                 }, 3000);
                            }
                            else {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&clsdt=1'
                                }else{
                                   new_url += '?clsdt=1'
                                }
                                window.location.href = new_url;
                                 }, 3000);
                            }
                        });       
            }     
        }
    });


//delete close date
$("#delete_close_form").validate({
    
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=delete_closed_date&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                            if (obj.status == 'success') {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text:  obj.message,
                                //     type: "success",
                                //     showConfirmButton: false  
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&clsdt=1'
                                }else{
                                   new_url += '?clsdt=1'
                                }
                                window.location.href = new_url;
                                }, 2000);
                            }
                            else {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&clsdt=1'
                                }else{
                                   new_url += '?clsdt=1'
                                }
                                window.location.href = new_url;
                            }
                        });       
            }     
        }
    });



//add staff
$("#add_staff_form").validate({
        rules: {
            staff_first_name: {
              required: true
            },
            staff_second_name: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=add_staff&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                            if (obj.status == 'success') {
                                $('.loading').show();
                                // swal({
                                //     title: obj.title,
                                //     text:  obj.message,
                                //     type: "success",
                                //     showConfirmButton: false  
                                // });
                                setTimeout(function() {
                                $('.loading').hide();
                                var url = window.location.href;  
                                var url = url.replace( "#/", "" );  
                                if (url.indexOf('?') > -1){
                                    url += '&adstf=1' 
                                }else{
                                url += '?adstf=1'
                                }
                            window.location.href = url;
                                }, 1000);
                                   
                            }
                            else {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&adstf=1'
                                }else{
                                   new_url += '?adstf=1'
                                }
                                window.location.href = new_url;
                                 }, 2000);
                            }
                        });       
            }     
        }
    });



//delete staff
$("#delete_staff_form").validate({
    
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=delete_staff&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                            if (obj.status == 'success') {
                                $('.loading').show();
                                // swal({
                                //     title: obj.title,
                                //     text:  obj.message,
                                //     type: "success",
                                //     showConfirmButton: false  
                                // });
                                setTimeout(function() {
                                    $('.loading').hide();
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&adstf=1'
                                }else{
                                   new_url += '?adstf=1'
                                }
                                window.location.href = new_url;
                                }, 2000);
                            }
                            else if(obj.status == 'nodelete')
                            {
                                // $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                 setTimeout(function() {  
                                    var url = window.location.href;
                                    var new_url = url.substring(0, url.indexOf('?'));
                                    if (new_url.indexOf('?') > -1){
                                       new_url += '&delstf=1'
                                    }else{
                                       new_url += '?delstf=1'
                                    } 
                                   window.location.href = new_url;
                                 }, 2000);
                            }
                            else {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&adstf=1'
                                }else{
                                   new_url += '?adstf=1'
                                }
                                window.location.href = new_url;
                            }
                        });       
            }     
        }
    });


//edit staff
$("#edit_staff_form").validate({
        rules: {
            staff_fname: {
              required: true
            },
            
        staff_sname: {
              required: true
                        }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=edit_staff&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                            if (obj.status == 'success') {
                                $('.loading').show();
                                // swal({
                                //     title: obj.title,
                                //     text:  obj.message,
                                //     type: "success",
                                //     showConfirmButton: false  
                                // });
                                setTimeout(function() {
                                $('.loading').hide();
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&adstf=1'
                                }else{
                                   new_url += '?adstf=1'
                                }
                                window.location.href = new_url;
                                }, 1000);
                            }
                            else {
                                $('.loading').hide();
                                // swal({
                                //     title: obj.title,
                                //     text: obj.message,
                                //     confirmButtonColor: "#16A12E",
                                //     type: "error",
                                //     confirmButtonText: "Ok"
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                var url = window.location.href;
                                var new_url = url.substring(0, url.indexOf('?'));
                                 if (new_url.indexOf('?') > -1){
                                   new_url += '&adstf=1'
                                }else{
                                   new_url += '?adstf=1'
                                }
                                window.location.href = new_url;
                                }, 1000);
                            }
                        });       
            }     
        }
    });


$("#staff_edithours_form").validate({
    
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=edit_staffhours&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                            $('#'+obj.identify).html(obj.start_time+' to '+ obj.end_time);
                            $('#'+obj.identify).attr("data-start",obj.start_time);
                            $('#'+obj.identify).attr("data-end",obj.end_time);
                            $("#edit-staff-hours").hide();

                        });       
            }     
        }
    });


//cancel appointment
$("#cancelappnt").validate({
    rules: {
            reason: {
              required: true
            }
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=deleteorder&' + form_data,
                        function (response) 
                        {
                            var obj = $.parseJSON(response);
                             if(obj.status=='success')
                             {
                              // swal({
                              //     title: obj.title,
                              //     text:  obj.message,
                              //     type: "success",
                              //     showConfirmButton: false  
                              //   });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.title);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                window.location.href = obj.new_url;
                                   }, 2000);
                             }
                        });       
            }     
        }
});

$("#delete_button").click(function(){
    var staff_date = $('#hidden_date').val();
    var staff_id = $('#hidden_id').val();
    var del_id = $('#hidden_identify').val();
    var d = new Date(staff_date);
    var month = d.getMonth()+1;
    var day = d.getDate();
    var output = d.getFullYear() + '-' +(month<10 ? '0' : '') + month + '-' +(day<10 ? '0' : '') + day;
    var data = {
            'action' : 'delete_staffhours',
            'data' : { 'date' :output,
                       'id':staff_id,
                    }
        };
    $.post(ajaxurl, data,
    function (response) 
    {
        $("#edit-staff-hours").hide();
        $('#'+del_id).html('<i data-nodelete="No" class="fa fa-plus"></i>');
    });
});


//Add Appointment
$("#appointweb").validate({
        rules: {
            cutfname: {
              required: true
            },
            mobnum: {
                          required: true
                        },
            // custgender: {
            //               required: true
            //             },
            // selectmultiple: {
            //               required: true
            //             },
          },
        errorPlacement: function(error, element) {
        },
        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            $('.loading').show();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=addappointment&' + form_data,
                        function (response) 
                        {
                             $('.loading').hide();
                            var obj = $.parseJSON(response);
                            if (obj.status == 'Success') {
                                var url = obj.urlredirect; 
                                // swal({
                                //     title: obj.status,
                                //     text:  'Appointment Added Successfully',
                                //     type: "success",
                                //     showConfirmButton: false  
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.status);
                                $('#common_alert_desc').html('Appointment Added Successfully');
                                setTimeout(function() {
                                window.location.href = url;
                                   }, 2000);
                                
                            }
                            else if(obj.status == 'failed') 
                            {
                                // swal({
                                //     title: obj.status,
                                //     text:  obj.message,
                                //     type: "error",
                                //     showConfirmButton: true  
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.status);
                                $('#common_alert_desc').html(obj.message);
                            }
                            else {
                                // swal({
                                //     title: obj.status,
                                //     text:  'Staff Not Available on the Selected Time',
                                //     type: "error",
                                //     showConfirmButton: true  
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.status);
                                $('#common_alert_desc').html('Staff Not Available on the Selected Time');
                            }

                        });       
            }     
        }
    });

//Reshedule Appointment
$("#resheduleweb").validate({

        submitHandler: function (form) 
        {
            form_data = $(form).serialize();
            //alert(form_data);
            $('.loading').show();
            if (form_data) 
            {
                $.post(ajaxurl, 'action=resheduleappointment&' + form_data,
                        function (response) 
                        {
                            $('.loading').hide();
                            var obj = $.parseJSON(response);
                            //alert(obj.status);
                            if (obj.status == 'success') {
                                var url = obj.urlredirect;
                                // swal({
                                //     title: obj.status,
                                //     text:  obj.message,
                                //     type: "success",
                                //     showConfirmButton: false  
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.status);
                                $('#common_alert_desc').html(obj.message);
                                setTimeout(function() {
                                    window.location.href = url;
                                }, 2000);
                            } else {
                                // swal({
                                //     title: obj.status,
                                //     text:  obj.message,
                                //     type: "error",
                                //     showConfirmButton: true  
                                // });
                                $('#common-alert').show();
                                $('#common_alert_text').html(obj.status);
                                $('#common_alert_desc').html(obj.message);
                            }

                        });       
            }     
        }
    });

} )( jQuery );

