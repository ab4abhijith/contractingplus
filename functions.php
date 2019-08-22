<?php
require 'WP_Mail.php';
error_reporting(NULL); 
//ini_set('display_errors', 1);

remove_role( 'subscriber' );
remove_role( 'editor' );
remove_role( 'contributor' );
remove_role( 'author' );


//Add role Customer
add_role('Customer',__( 'Customer' ),
    array(
        'read'         => true,  // true allows this capability
        'edit_posts'   => false,
    )
);


//Add role Saloon Manager
add_role('Saloon Manager', __('Saloon Manager'),
    array(
        'read'              => true, // Allows a user to read
        'create_posts'      => false, // Allows user to create new posts
        'edit_posts'        => false, // Allows user to edit their own posts
        'edit_others_posts' => false, // Allows user to edit others posts too
        'publish_posts'     => false, // Allows the user to publish posts
        'manage_categories' => false, // Allows user to manage post categories
        )
);


function wpse23007_redirect(){
  if( is_admin() && !defined('DOING_AJAX') && ( current_user_can('Saloon Manager') ) ){
    wp_logout();
    wp_redirect(home_url());
    exit;
  }
}
add_action('init','wpse23007_redirect');


add_action('after_setup_theme', 'remove_admin_bar');
 
function remove_admin_bar() {
if (!current_user_can('administrator') && !is_admin()) {
  show_admin_bar(false);
}
}


add_action('admin_head', 'my_custom_fonts');

function my_custom_fonts() {
  wp_enqueue_style( 'admin-style', get_template_directory_uri() . '/admin/css/admin-style.css',false,'1.1','all');
}


if(isset($_GET['searchquery'])) $searchquery = $_GET['searchquery'];
else $searchquery = 1;

if(isset($_POST['searchsubmit'])){ 
    $searchtext = $_POST['searchtext'];
    $salonlist = $_POST['salonsec'];
    
    $searchquery = $searchtext;

    $actual_link = "http://".$_SERVER[HTTP_HOST].$_SERVER[REQUEST_URI];

    //echo $actual_link;
    //exit;

  $urlpart =  explode("&",$actual_link);

  //echo $urlpart[1];
  //exit;

  if($urlpart[1]!='') {

    $urllink = $urlpart[0].'&searchquery='.$searchquery;
    header('location:'.$urllink);

  }

    //echo $searchtext.'------'.$salonlist;
    //exit;
}   

if(isset($_POST['approve'])){ //check if form was submitted
  $statusid = $_POST['statusid']; //get input text
  //$statusid = 654789; //get input text
  $userid = $_POST['userid']; //get input text
  $prev_value = $_POST['prevstatusid']; //get input text
  //$prev_value = 123456; //get input text
  //echo $userid.'<br>';
  $meta_key = 'saloon_status';

  //echo $urlpart[0];
  //exit;

  update_user_meta( $userid, $meta_key, $statusid, $prev_value );


  $salonname = $_POST['salonname'];

  //echo $salonname;
  //exit;

  $email = $_POST['salonemail'];

  $body = 'Hi '.$salonname.',<br><br>';
$body .= 'Congratulations! Your account has been activated by Beautue.<br><br>';
$body .= 'Please use the below link to login to your Beautue Account.<br>';
$body .= '<a href="get_permalink(35)">'.get_permalink(35).'</a><br><br>';
$body .= 'Please feel free to contact us,if you continue to face any problems.<br><br>';
$body .= 'Regards,<br>';
$body .= 'Beautue Team';

    $headers = array('Content-Type: text/html; charset=UTF-8','From: beautue@emvigotechnologies.com');

    $to = $email;

    $subject = 'Beautue Account Approval';

    $sent = wp_mail($to, $subject, $body, $headers);


    $actual_link = "http://".$_SERVER[HTTP_HOST].$_SERVER[REQUEST_URI];

  $urlpart =  explode("&",$actual_link);

  header('location:'.$urlpart[0]);

  $valmessage = "Success! Salon Updated";
  //echo $sortvalue;
  //exit;
}   

if(isset($_POST['reject'])){ //check if form was submitted
  $statusid = $_POST['statusid']; //get input text
  //$statusid = 654789; //get input text
  $userid = $_POST['userid']; //get input text
  $prev_value = $_POST['prevstatusid']; //get input text
  //$prev_value = 123456; //get input text
  //echo $userid.'<br>';
  $meta_key = 'saloon_status';

  update_user_meta( $userid, $meta_key, $statusid, $prev_value );

  $salonname = $_POST['salonname'];

  //$email = 'abhijith.mk@emvigotech.com';
  $email = $_POST['salonemail'];

   $body = 'Hi '.$salonname.',<br><br>';
$body .= 'Sorry, your account has been rejected by Beautue!<br><br>';
$body .= 'Kindly contact us in case of any queries.<br><br>';
$body .= 'Regards,<br>';
$body .= 'Beautue Team';


    $headers = array('Content-Type: text/html; charset=UTF-8','From: beautue@emvigotechnologies.com');

    $to = $email;

    $subject = 'Beautue Account Rejected';
    
    $sent = wp_mail($to, $subject, $body, $headers);


  $actual_link = "http://".$_SERVER[HTTP_HOST].$_SERVER[REQUEST_URI];

  $urlpart =  explode("&",$actual_link);

  header('location:'.$urlpart[0]);

  $valmessage = "Success! Salon Updated";
  //echo $sortvalue;
  //exit;
}   

if(isset($_POST['block'])){ //check if form was submitted
  $statusid = $_POST['statusid']; //get input text
  //$statusid = 654789; //get input text
  $userid = $_POST['userid']; //get input text
  $prev_value = $_POST['prevstatusid']; //get input text
  //$prev_value = 123456; //get input text
  //echo $userid.'<br>';
  $meta_key = 'saloon_status';

  update_user_meta( $userid, $meta_key, $statusid, $prev_value );

  $actual_link = "http://".$_SERVER[HTTP_HOST].$_SERVER[REQUEST_URI];

  $urlpart =  explode("&",$actual_link);

  header('location:'.$urlpart[0]);

  $valmessage = "Success! Salon Updated";
  //echo $sortvalue;
  //exit;
}   

if(isset($_POST['activate'])){ 

    //check if form was submitted
  $statusid = $_POST['statusid']; //get input text
  //$statusid = 654789; //get input text
  $userid = $_POST['userid']; //get input text
  $prev_value = $_POST['prevstatusid']; //get input text
  //$prev_value = 123456; //get input text
  //echo $userid.'<br>';
  $meta_key = 'saloon_status';

  update_user_meta( $userid, $meta_key, $statusid, $prev_value );


 $salonname = $_POST['salonname'];

  //echo $salonname;
  //exit;

  $email = $_POST['salonemail'];

  $body = 'Hi '.$salonname.',<br><br>';
$body .= 'Congratulations! Your account has been activated by Beautue.<br><br>';
$body .= 'Please use the below link to login to your Beautue Account.<br>';
$body .= '<a href="get_permalink(35)">'.get_permalink(35).'</a><br><br>';
$body .= 'Please feel free to contact us,if you continue to face any problems.<br><br>';
$body .= 'Regards,<br>';
$body .= 'Beautue Team';

    $headers = array('Content-Type: text/html; charset=UTF-8','From: beautue@emvigotechnologies.com');

    $to = $email;

    $subject = 'Beautue Account Approval';

    $sent = wp_mail($to, $subject, $body, $headers);


  $actual_link = "http://".$_SERVER[HTTP_HOST].$_SERVER[REQUEST_URI];

  $urlpart =  explode("&",$actual_link);

  header('location:'.$urlpart[0]);

  $valmessage = "Success! Salon Updated";
  //echo $sortvalue;
  //exit;

}   

include('api_code.php');
include('superadmin.php');


//Changes Rinu
include_once('libs/acf/repeater/acf-repeater.php');

//saloon registration
add_action('wp_ajax_register', 'register'); 
add_action('wp_ajax_nopriv_register', 'register'); 
function register()
{ 
    $email = $_POST['email'];
    $name_of_saloon = $_POST['saloon_name'];
    $password = $_POST['confirm_pass'];
    if ( email_exists( $email ) ) 
    {
        $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Email already Registered');
        die(json_encode($response)); 
    }
    else
    {
        $userdata = array(
            'user_pass'  => $password,
            'user_login' => $email,
            'user_email' => $email,
            'display_name' => $name_of_saloon
                    );    

        $user_id = wp_insert_user( $userdata );
        $user = new WP_User($user_id);
        $user->set_role('Saloon Manager');
        if(isset($user_id))
        {
               $image = $_POST['p_image_val'];
               //echo $image;
               //exit;
               $pos  = strpos($image, ';');
               $type = explode(':', substr($image, 0, $pos))[1];
               $type1 = substr($type, strrpos($type, '/') + 1);
               $uploaddir = wp_upload_dir();
               $img = base64_decode(preg_replace('#^data:image/\w+;base64,#i', '', $_POST['p_image_val']));
               file_put_contents($uploaddir['basedir'] . '/profile/user' . $user_id.'.'.$type1, $img);
               add_user_meta( $user_id, 'manager_name', $_POST['manager_name']);
               add_user_meta( $user_id, 'phone', $_POST['phone']);
               add_user_meta( $user_id, 'address', $_POST['address']);
               add_user_meta( $user_id, 'city', $_POST['city']);
               add_user_meta( $user_id, 'zip', $_POST['zip_code']);
               add_user_meta( $user_id, 'start_time', date("H:i", strtotime($_POST['start_time'])));
               add_user_meta( $user_id, 'close_time', date("H:i", strtotime($_POST['end_time'])));  
               add_user_meta( $user_id, 'available_for', $_POST['available_for']);   
               add_user_meta( $user_id, 'saloon_status', 0);    
               add_user_meta( $user_id, 'profile_image', 'user' . $user_id.'.'.$type1); 
               $saladdress = $_POST['address'].' '.$_POST['city'];
               $address = $saladdress;
               $address = str_replace(" ", "+", $address);
               $url = "http://maps.google.com/maps/api/geocode/json?address=$address&sensor=false";
               $ch = curl_init();
               curl_setopt($ch, CURLOPT_URL, $url);
               curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
               curl_setopt($ch, CURLOPT_PROXYPORT, 3128);
               curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
               curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
               $response = curl_exec($ch);
               curl_close($ch);
               $response_a = json_decode($response);
               $lattitude = $response_a->results[0]->geometry->location->lat;
               $longitude = $response_a->results[0]->geometry->location->lng;
                // $userid = $_POST['user-id'];
               if($lattitude=='' || $longitude=='') 
               {
                  $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Please try again!!');
                  die(json_encode($response));   
               }
               else 
               { 
                  add_user_meta($user_id, 'salon_lattitude', $lattitude);
                  add_user_meta($user_id, 'salon_longitude', $longitude);
               }
        }
        //mail to check email validity
         if ( $user_id && (!is_wp_error( $user_id )) ) 
         {
            $code = sha1( $user_id . time() );    
            global $wpdb;    
            $wpdb->update( 'wp_users',array('user_activation_key' => $code), array( 'ID' => $user_id ),array( '%s'));
            $activation_link = add_query_arg( array( 'key' => $code, 'user' => $user_id ), get_permalink(35));
            $body = 'Welcome to Beautue'.' '. $name_of_saloon . "<br><br>";
            $body .= 'BEAUTUE lets you search and discover the amazing Beauty Salons in your region when you need it' . "<br><br>";
            $body .= 'Please click here to verify your account.' . "<br><br>";
            $body .= '<a href="'.$activation_link.'">Click Here</a>'."<br><br>";
            $body .= 'So let’s get started and find your next beauty appointment.' . "<br><br>";
            $body .= 'Regards,' . "<br>";
            $body .= 'Beautue Team' . "<br>";
            $headers = array('Content-Type: text/html; charset=UTF-8');
            $to = $email;
            $subject = 'Beautue Account Confirmation';
            $sent = wp_mail($to, $subject, $body, $headers);
        }
        $login_url = get_permalink(35).'?message=true';
        $json_data = json_encode([ 'login_redirect' => $login_url, 'status' => 'true' ]);
        die($json_data);
    }
   
}    

 
//saloon login
add_action('wp_ajax_salon_login', 'salon_login');
add_action('wp_ajax_nopriv_salon_login', 'salon_login');
function salon_login() {
    try {
            $email = strtolower(trim($_POST['email']));
            $user = get_user_by('email', $email);
            if ($user) 
            {
                $status = get_user_meta( $user->ID, 'saloon_status',true);    
                if($status == 0)
                {//registered and email not verified
                    $response = array('status' => 'info', 'title' => 'Verify Email', 'message' => 'Please verify your account by clicking on the verification link sent to you via email.');
                    die(json_encode($response));
                }
                else if($status == 1)
                {//registered, email activated not approved by admin
                    $response = array('status' => 'info', 'title' => 'Account Review', 'message' => 'Your account is under review by Beautue. You will receive an email upon activation of your account.');
                    die(json_encode($response));
                }
                else if($status == 2)
                {//registered, email activated approved by admin
                    if (wp_check_password(trim($_POST['pass']), $user->data->user_pass, $user->ID)) 
                    {
                        wp_set_current_user($user->ID, $user->user_login);
                        wp_set_auth_cookie($user->ID);
                        do_action('wp_login', $user->user_login);
                        $response = array('status' => 'success', 'title' => 'Success', 'message' => 'You are logged in. Redirecting please wait...', 'login_redirect' => get_permalink(50));
                        die(json_encode($response));
                    } 
                    else 
                    {
                        $response = array('status' => 'failed', 'title' => 'Password incorrect', 'message' => 'The password you entered is incorrect.');
                        die(json_encode($response));
                    } 
                }
                else if($status == 3)
                {//blocked user
                    $response = array('status' => 'info', 'title' => 'Account Blocked', 'message' => 'Your account has been blocked by Beautue. Kindly contact Admin@beautue.com.');
                    die(json_encode($response));
                }
                else
                {//rejected user
                    $response = array('status' => 'info', 'title' => 'Account Rejected', 'message' => 'Your account has been Rejected by Beautue. Kindly contact Admin@beautue.com.');
                    die(json_encode($response));
                }
                
            } 
            else 
            {
                $response = array('status' => 'info', 'title' => 'User Not Registered', 'message' => 'The email address that you`ve entered doesn`t match any account.');
                die(json_encode($response));
            }
        } 
    catch (Exception $e) 
    {
        $response = array('status' => 'failed', 'title' => 'Error', 'message' => 'An unexpected error occurred.');
        die(json_encode($response));
    }
}

//forgot password from login page
add_action('wp_ajax_forgot_password', 'forgot_password');
add_action('wp_ajax_nopriv_forgot_password', 'forgot_password');
function forgot_password() 
{
        $email = $_POST['forgot_email'];
        if(email_exists($email))
        {
            $user = get_user_by('email', $email);
            $status = get_user_meta( $user->ID, 'saloon_status',true); 
            if($status == 0)
            {//registered and email not verified
                $response = array('status' => 'info', 'title' => 'Verify Email', 'message' => 'Please verify your account by clicking on the verification link sent to you via email.');
                die(json_encode($response));
            }
            else if($status == 1)
            {//registered, email activated not approved by admin
                $response = array('status' => 'info', 'title' => 'Account Review', 'message' => 'Your account is under review by Beautue. You will receive an email upon activation of your account.');
                die(json_encode($response));
            }
            else if($status == 2)
            {//registered, email activated approved by admin
               $code = sha1( $user->ID . time() );    
               global $wpdb;    
               $wpdb->update( 'wp_users',array('user_activation_key' => $code), array( 'ID' => $user->ID ),array( '%s'));
               $activation_link = add_query_arg( array( 'key' => $code, 'user' => $user->ID ), get_permalink(48));
               $body = 'Hi'.' '. $user->display_name. ",<br><br>";
               $body .= 'We have received a request to reset your Beautue password.' . "<br><br>";
               $body .= 'Please use the below link to reset your password' . "<br><br>";
               $body .= '<a href="'.$activation_link.'">Click Here</a>'."<br><br>";
               $body .= 'Please feel free to contact us,if you continue to face any problems.' . "<br><br>";
               $body .= 'Regards,' . "<br>";
               $body .= 'Beautue Team' . "<br>";
               $headers = array('Content-Type: text/html; charset=UTF-8');
               $to = $email;
               $subject = 'Beautue Reset Account Password';
               $sent = wp_mail($to, $subject, $body, $headers);
               $response = array('status' => 'success', 'title' => 'Success', 'message' => 'A Password reset link has been sent to your registered email address. Thank you!', 'login_redirect' => get_permalink(35));
               die(json_encode($response));
            }
            else if($status == 3)
            {//blocked user
                $response = array('status' => 'info', 'title' => 'Account Blocked', 'message' => 'Your account has been blocked by Beautue. Kindly contact Admin@beautue.com.');
                die(json_encode($response));
            }
            else
            {//rejected user
                $response = array('status' => 'info', 'title' => 'Account Rejected', 'message' => 'Your account has been Rejected by Beautue. Kindly contact Admin@beautue.com.');
                die(json_encode($response));
            }
        }
        else
        {
            $response = array('status' => 'failed', 'title' => 'Not Valid', 'message' => 'The email address that you`ve entered is not registered with us. ', 'login_redirect' => get_permalink(35));
            die(json_encode($response));
        }
}

//reset password from login page
add_action('wp_ajax_reset_pass', 'reset_pass');
add_action('wp_ajax_nopriv_reset_pass', 'reset_pass');
function reset_pass()
{
        global $wpdb;
        $resetQuery = $wpdb->update('wp_users',array('user_pass' => wp_hash_password($_POST['cnfm_password']),'user_activation_key' => ''), array( 'id' => $_POST['user_id'], 'user_activation_key' => $_POST['user_key'] ));
        
        if($_POST['custurl']==0) $url = get_permalink(35);
        else $url = get_permalink(65);

        if($resetQuery == 0)
        {
          $response = array('status' => 'false', 'title' => 'Error', 'message' => 'Please try Again', 'login_redirect' => $url );
          die(json_encode($response));
        }
        else
        {
          $response = array('status' => 'true', 'title' => 'Success', 'message' => 'Password Changed Successfully.', 'login_redirect' => $url );
          die(json_encode($response));
        }
}



//reset password from login page
add_action('wp_ajax_reset_profile_pass', 'reset_profile_pass');
add_action('wp_ajax_nopriv_reset_profile_pass', 'reset_profile_pass');
function reset_profile_pass()
{
    
    if(wp_check_password($_POST['current_pass'],$_POST['hidden_pass'])) 
    { 
        global $wpdb;
        $resetQuery = $wpdb->update('wp_users',array('user_pass' => wp_hash_password($_POST['cnfm_pass'])), array( 'id' => $_POST['hidden_id']));
        if($resetQuery == 0)
        {
            $response = array('status' => 'false', 'title' => 'Error', 'message' => 'Something went wrong please try again');
            die(json_encode($response));
        }
        else
        {
            $response = array('status' => 'true', 'title' => 'Success', 'message' => 'Password Changed Successfully.');
          die(json_encode($response));
        }
    } 
    else 
    {     
        $response = array('status' => 'failed', 'title' => 'Error', 'message' => 'Password does not match');
        die(json_encode($response));
    }
}




//update profile
add_action('wp_ajax_update_profile', 'update_profile');
add_action('wp_ajax_nopriv_update_profile', 'update_profile');
function update_profile()
{
        $update = wp_update_user( array( 'ID' => $_POST['user-id'], 'display_name'=> $_POST['saloon_name']) );
        $image = $_POST['p_image_val'];
                
                $saladdress = $_POST['address'].' '.$_POST['city'];
                $address = $saladdress;

                $address = str_replace(" ", "+", $address);

                  $url = "http://maps.google.com/maps/api/geocode/json?address=$address&sensor=false";
                  $ch = curl_init();
                  curl_setopt($ch, CURLOPT_URL, $url);
                  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                  curl_setopt($ch, CURLOPT_PROXYPORT, 3128);
                  curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
                  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
                  $response = curl_exec($ch);
                  curl_close($ch);
                  $response_a = json_decode($response);
                  $lattitude = $response_a->results[0]->geometry->location->lat;
                  $longitude = $response_a->results[0]->geometry->location->lng;

                  $userid = $_POST['user-id'];

                  if($lattitude=='' || $longitude=='') {

                      $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Please try again!!');
                      die(json_encode($response));
                      
                  }
                  else { 

                      $havemeta = get_user_meta($userid, 'salon_lattitude', true);
                      if ($havemeta) { 
                        update_user_meta($userid, 'salon_lattitude', $lattitude);
                      } else {
                        add_user_meta($userid, 'salon_lattitude', $lattitude);
                      }

                      $checkmeta = get_user_meta($userid, 'salon_longitude', true);
                      if ($checkmeta) { 
                        update_user_meta($userid, 'salon_longitude', $longitude);
                      } else {
                        add_user_meta($userid, 'salon_longitude', $longitude);
                      }

                  }

        if($image)  
        {
            $pos  = strpos($image, ';');
            $type = explode(':', substr($image, 0, $pos))[1];
            $type1 = substr($type, strrpos($type, '/') + 1);
            $uploaddir = wp_upload_dir();
            $img = base64_decode(preg_replace('#^data:image/\w+;base64,#i', '', $_POST['p_image_val']));
            file_put_contents($uploaddir['basedir'] . '/profile/user' . $_POST['user-id'].'.'.$type1, $img);
            update_user_meta($_POST['user-id'], 'profile_image', 'user' . $_POST['user-id'].'.'.$type1);
        }
        update_user_meta($_POST['user-id'], 'manager_name', $_POST['manager_name']);
        update_user_meta($_POST['user-id'], 'phone', $_POST['phone']);
        update_user_meta($_POST['user-id'], 'address', $_POST['address']);
        update_user_meta($_POST['user-id'], 'city', $_POST['city']);
        update_user_meta($_POST['user-id'], 'zip', $_POST['zip_code']);
        update_user_meta($_POST['user-id'], 'start_time', date("H:i", strtotime($_POST['start_time'])));
        update_user_meta($_POST['user-id'], 'close_time', date("H:i", strtotime($_POST['end_time'])));  
        update_user_meta($_POST['user-id'], 'available_for', $_POST['available_for']);     
         
        if ( is_wp_error( $update ) ) 
        {
            $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Please try again!!');
            die(json_encode($response));
        } 
        else 
        {
            $response = array('status' => 'success', 'title' => 'Success', 'message' => 'Profile Updated Successfully.');
            die(json_encode($response));
        }   
    
}


//add closed date
add_action('wp_ajax_add_closed_date', 'add_closed_date');
add_action('wp_ajax_nopriv_add_closed_date', 'add_closed_date');
function add_closed_date()
{
    global $wpdb;
    $current_user = wp_get_current_user(); 
    $salonid = $current_user->ID;
    $date_from = $_POST['start_date'];   
    $date_from = strtotime($date_from); 
    $date_to = $_POST['end_date'];  
    $date_to = strtotime($date_to);   
    for ($i=$date_from; $i<=$date_to; $i+=86400) 
    {  
        $clddate[] = date("Y-m-d", $i);  
    }  
    $availchk_result = $wpdb->get_results( "SELECT `date` FROM orders WHERE saloon_id = $salonid AND `date` IN ('" . implode("','", $clddate) . "')",ARRAY_N );      
    if(!empty($availchk_result))
    { 
        $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Appointments already Added');
        die(json_encode($response));
    }
    else
    {
        $closed_dates =  $wpdb->get_results( "SELECT startdate, enddate FROM saloon_closed_date WHERE '".date("Y-m-d", strtotime($_POST['start_date']))."' between startdate and enddate OR '".date("Y-m-d", strtotime($_POST['end_date']))."' between startdate and enddate OR startdate between '".date("Y-m-d", strtotime($_POST['start_date']))."' and '".date("Y-m-d", strtotime($_POST['end_date']))."' OR enddate between '".date("Y-m-d", strtotime($_POST['start_date']))."' and '".date("Y-m-d", strtotime($_POST['end_date']))."' AND `saloon_id`=".$salonid);
        if(count($closed_dates)>0)
        {
            $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Closed Date Already Added!!');
            die(json_encode($response));
        }   
        else
        { 
          $id = $wpdb->insert('saloon_closed_date', array( 'saloon_id' => $_POST['closed_hidden_id'], 'startdate' => date("Y-m-d", strtotime($_POST['start_date'])),'enddate' => date("Y-m-d", strtotime($_POST['end_date'])),'description' => $_POST['desc'] ),array('%d','%s','%s','%s'));
          if(isset($id))
          {
              $response = array('status' => 'success', 'title' => 'Success', 'message' => 'Closed Date Added Successfully');
              die(json_encode($response));
          }
          else
          {
              $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Something went Wrong please try again!!');
              die(json_encode($response));
          }
        }
    }
}

//edit closed date
add_action('wp_ajax_edit_closed_date', 'edit_closed_date');
add_action('wp_ajax_nopriv_edit_closed_date', 'edit_closed_date');
function edit_closed_date()
{
    global $wpdb;
    $current_user = wp_get_current_user(); 
    $salonid = $current_user->ID;
    $closed_dates =  $wpdb->get_results( "SELECT startdate, enddate FROM saloon_closed_date WHERE '".date("Y-m-d", strtotime($_POST['startdate']))."' between startdate and enddate OR '".date("Y-m-d", strtotime($_POST['enddate']))."' between startdate and enddate OR startdate between '".date("Y-m-d", strtotime($_POST['startdate']))."' and '".date("Y-m-d", strtotime($_POST['enddate']))."' OR enddate between '".date("Y-m-d", strtotime($_POST['startdate']))."' and '".date("Y-m-d", strtotime($_POST['end_date']))."' AND `saloon_id`=".$salonid);
    // $closed_dates =  $wpdb->get_results( "SELECT startdate, enddate FROM saloon_closed_date WHERE '".date("Y-m-d", strtotime($_POST['startdate']))."' between startdate and enddate OR '".date("Y-m-d", strtotime($_POST['enddate']))."' between startdate and enddate");
    if(count($closed_dates)>0)
    {
        $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Closed Date Already Added!!');
        die(json_encode($response));
        
    }
    else
    {
        $update_edit = $wpdb->update('saloon_closed_date',array('startdate'=> date("Y-m-d", strtotime($_POST['startdate'])),'enddate'=> date("Y-m-d", strtotime($_POST['enddate'])),'description'=> $_POST['desc_closedate']),array( 'id' => $_POST['id'] ));
        if(isset($update_edit))
        {
            $response = array('status' => 'success', 'title' => 'Success', 'message' => 'Profile Updated Successfully.');
            die(json_encode($response));
        }
        else
        {
            $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Something went Wrong please try again!!');
            die(json_encode($response));
        }
    }
}

//delete closed date
add_action('wp_ajax_delete_closed_date', 'delete_closed_date');
add_action('wp_ajax_nopriv_delete_closed_date', 'delete_closed_date');
function delete_closed_date()
{
    global $wpdb;
    $delete = $wpdb->delete( 'saloon_closed_date', array( 'id' => $_POST['delete_id'] ) );
    if(isset($delete))
    {
        $response = array('status' => 'success', 'title' => 'Success', 'message' => 'Deleted Successfully.');
        die(json_encode($response));
    }
    else
    {
        $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Something went Wrong please try again!!');
        die(json_encode($response));
    }
}



//add staff
add_action('wp_ajax_add_staff', 'add_staff');
add_action('wp_ajax_nopriv_add_staff', 'add_staff');
function add_staff()
{
    global $wpdb;
    $status =0;
    if($_POST['staff_status'] == 'on')
    { 
        $status=1;
    }
    $id = $wpdb->insert('saloon_staff', array( 'saloon_id' => $_POST['staff_add_id'], 'firstname' => $_POST['staff_first_name'],'lastname' => $_POST['staff_second_name'],'mobile' => $_POST['staff_mobile'],'email' => $_POST['staff_email'],'notes' => $_POST['staff_notes'],'joindate' => date("Y-m-d"),'status' => $status ),array('%d','%s','%s','%d','%s','%s','%s','%d'));
    if(isset($id))
    {
        $response = array('status' => 'success', 'title' => 'Success', 'message' => 'Staff added successfully');
        die(json_encode($response));
    }
    else
    {
        $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Something went Wrong please try again!!');
        die(json_encode($response));
    }
}


//delete staff
add_action('wp_ajax_delete_staff', 'delete_staff');
add_action('wp_ajax_nopriv_delete_staff', 'delete_staff');
function delete_staff()
{
    global $wpdb;
    $checkorder = $wpdb->get_results("SELECT * FROM orders WHERE staff_id = ".$_POST['staff_delete_id'] );
    if($checkorder)
    {
        $response = array('status' => 'nodelete', 'title' => 'Cannot be Deleted', 'message' => 'Staff has Upcoming Appointments');
        die(json_encode($response));
    }
    else
    {
        // $delete = $wpdb->delete( 'saloon_staff', array( 'staff_id' => $_POST['staff_delete_id'] ) );
        $delete = $wpdb->update('saloon_staff',array('curr_stat'=> 1),array( 'staff_id' => $_POST['staff_delete_id'] ));
        if(isset($delete))
        {
            $response = array('status' => 'success', 'title' => 'Success', 'message' => 'Staff Deleted Successfully.');
            die(json_encode($response));
        }
        else
        {
            $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Something went Wrong please try again!!');
            die(json_encode($response));
        }
    }
}


//edit staff details
add_action('wp_ajax_edit_staff', 'edit_staff');
add_action('wp_ajax_nopriv_edit_staff', 'edit_staff');
function edit_staff()
{
    global $wpdb;
    $status =0;
    if($_POST['stf_status'] == 'on')
    {
        $status=1;
    }
    $update_edit = $wpdb->update('saloon_staff',array('firstname'=> $_POST['staff_fname'],'lastname'=> $_POST['staff_sname'],'mobile'=> $_POST['staff_mob'],'email'=> $_POST['stf_email'],'notes'=> $_POST['stf_notes'],'status'=> $status),array( 'staff_id' => $_POST['staff_edit_id'] ));
    if(isset($update_edit))
    {
        $response = array('status' => 'success', 'title' => 'Success', 'message' => 'Staff Profile Updated Successfully.');
        die(json_encode($response));
    }
    else
    {
        $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Something went Wrong please try again!!');
        die(json_encode($response));
    }
}

function order()
{
    global $wpdb;
    $table_name = 'orders';
    if(isset($_GET['staff_id'])) {
      $staffid = $_GET['staff_id'];
      //echo $staffid;
      //exit;
      $results = $wpdb->get_results("SELECT * FROM $table_name WHERE staff_id = $staffid");
      //echo $wpdb->last_query;
      //exit;
    } else {
      $results = $wpdb->get_results('SELECT * FROM '.$table_name.' WHERE order_status = 1' );
    }
    $array = json_decode(json_encode($results), True);
    foreach ( $array as $result )
    {
        $saloon_id=$result['saloon_id'];
        $service_id=$result['service_id'];
        $customer_id=$result['customer_id'];
        $order_date = date('Y-m-d', strtotime( $result['date'] ));
        $service_start_time = $order_date .' '. $result['start_time'];
        $endtime = date('H:i:s',strtotime('+1 seconds', strtotime($result['end_time'])));
        $service_end_time = $order_date .' '. $result['end_time'];
        //$service_end_time = $order_date .' '. $endtime;
        //die($result['end_time']);
        $total_time = date_create($result['start_time'])->diff(date_create($result['end_time']))->format('%H:%i:%s');
        $order_status = $result['order_status'];
    }
    //get ordered services
    $serialize_service = unserialize($service_id);

     $service_name[] = '';

    foreach ( $serialize_service as $service ) 
    {
         $service =  $wpdb->get_results( 'SELECT * FROM `services` WHERE `id` = '.$service , ARRAY_A);

         foreach ($service as $item) 
         {
            $service_color_code = $wpdb->get_results( 'SELECT `colorcode` FROM `saloon_service` WHERE `service_id` = '.$item['id']);
            $service_name[] = $item['service_name'].'<p>'.$service_color_code[0]->colorcode.'</p>';  
         }  
    }
    //customer details
    $customer_info = get_userdata($customer_id);
    $customer_phone = get_user_meta( $customer_id, 'phone' , true );
    $customer_details = $customer_info->display_name."\n\n".$customer_phone."\n\n".$total_time;

    //color details
    $service_color =  $wpdb->get_results( 'SELECT `colorcode` FROM `saloon_service` WHERE `saloon_id` = '.$saloon_id );
    $color_code = $service_color[0]->colorcode;
    //json array
    if($order_status == 1)
    {
        $json_output =json_encode(array("title"=>$customer_details,"start"=>$service_start_time,"end"=>$service_end_time,"color"=>'#ff9779',"service_name"=>$service_name,"resourceIds"=>'10'));
    }
    return $json_output;
}
add_action( 'init', 'order' );


 // for($i = 0; $i < 7; $i++) 
 //                    {
 //                        $ts = strtotime($year.'W'.$week.$i);
 //                        $wrkdates[]= date('Y-m-d',$ts);
 //                    }
 //                    $staff_working_daysss = $wpdb->get_results( "SELECT staff_working_days.* FROM `staff_working_days` JOIN `saloon_staff` ON staff_working_days.staff_id = saloon_staff.staff_id WHERE saloon_staff.saloon_id =".$salonid." AND `currdate` IN ('" . implode("','", $wrkdates) . "')", ARRAY_A);
                    



//staff workingdays
                 function staff_working_days() {

                    $current_user = wp_get_current_user(); 
                    $salonid = $current_user->ID;
                    global $wpdb;
                    $staff =  $wpdb->get_results( 'SELECT `firstname`,`lastname`,`staff_id` FROM `saloon_staff` WHERE `saloon_id` = '.$salonid.' AND `status`= 1' , ARRAY_A);
                    $saloon_working_days =  $wpdb->get_results( 'SELECT * FROM `saloon_working_days` WHERE `saloon_id` = '.$salonid , ARRAY_A);
                    $date = date("Y/m/d", strtotime($_POST['date']) );
                    $ts = strtotime($date);
                    $year = date('o', $ts);
                    $week = date('W', $ts);
                    $start_week = date("d", strtotime('sunday last week', strtotime($date)));
                    $end_week = date("d M, Y", strtotime('saturday this week', strtotime($date)));
                    $j=0;
                    $saloon_closed_days =  $wpdb->get_results( 'SELECT * FROM `saloon_closed_date` WHERE `saloon_id` = '.$salonid , ARRAY_A);
                        foreach ($saloon_closed_days as $clddays) 
                        {
                            $period = new DatePeriod(new DateTime($clddays['startdate']), new DateInterval('P1D'), new DateTime($clddays['enddate'].'+1 day'));
                            foreach ($period as $closeddate) 
                            {
                                $closed_dates[] = $closeddate->format("Y-m-d");
                            }   
                        }
                    foreach ($staff as $item) 
                    {
                         $days[0] = 'sun';
                         $days[1] = 'mon';
                         $days[2] = 'tue';
                         $days[3] = 'wed';
                         $days[4] = 'thu';
                         $days[5] = 'fri';
                         $days[6] = 'sat';
                         foreach ($saloon_working_days as $items) 
                         {
                            for($i = 0; $i < 7; $i++) 
                            {

                                $ts = strtotime($year.'W'.$week.$i);
                                $dates = date('Y-m-d',$ts);
                                $start= $dates[0];
                                $staff_working_days = $wpdb->get_results( "SELECT * FROM `staff_working_days` WHERE `staff_id` = '".$item['staff_id']."' AND `currdate` = '".$dates."'", ARRAY_A);
                                if (in_array($dates, $closed_dates)) 
                                  {
                                    $items[$days[$i].'_start'] = '';
                                    $items[$days[$i].'_end'] = '';
                                  }
                                else
                                {
                                    if(count($staff_working_days)>0)
                                    { 
                                      $items[$days[$i].'_start'] = date("H:i",strtotime($staff_working_days[0]['start_time']));
                                      $items[$days[$i].'_end'] = date("H:i",strtotime($staff_working_days[0]['end_time']));
                                    }
                                }
                                  if($items[$days[$i].'_start'] == '' || $items[$days[$i].'_end'] == '')
                                  {
                                        $status='closed';
                                        $result[$j][$i]['date'] = date("D d M Y", $ts);
                                        $result[$j][$i]['content'] = $status;
                                  } 
                                else{
                                        if($staff_working_days[0]['status'] == 1){
                                            $result[$j][$i]['date'] = date("D d M Y", $ts);
                                            $result[$j][$i]['content'] = 'deleteplus';
                                        }
                                        else
                                        {
                                        $result[$j][$i]['date'] = date("D d M Y", $ts);
                                        $result[$j][$i]['content'] = date("g:i a",strtotime($items[$days[$i].'_start'])).' to '.date("g:i a",strtotime($items[$days[$i].'_end']));
                                        }
                                    } 
                            }
                         }
                         $j++;
                    } 

$response = array('saloon_id' => $salonid, 'result' => $result, 'staff_details' => $staff,'saloon_workingdays' => $saloon_working_days, 'selected_date' =>$_POST['date'],'start_week'=>$start_week,'end_week'=>$end_week);
die(json_encode($response));
}
 add_action('wp_ajax_staff_working_days', 'staff_working_days');
 add_action('wp_ajax_nopriv_staff_working_days', 'staff_working_days');








//staff working timeing select box
function staff_working_time() {

    $current_user = wp_get_current_user(); 
    $salonid = $current_user->ID; 
    global $wpdb;
    $get_staff_time = $wpdb->get_results( "SELECT `".$_POST['data']['day']."_start`,`".$_POST['data']['day']."_end` FROM `saloon_working_days` WHERE `saloon_id` = ".$salonid );
    foreach($get_staff_time as $val) {
        $startday = $_POST['data']['day']."_start";
        $endday = $_POST['data']['day']."_end";
        $start = $val->$startday;
        $end = $val->$endday;
    }
    if(isset($get_staff_time)){
        
                          $tStart = strtotime($start);
                          $tEnd = strtotime($end);
                          $tNow = $tStart;
                          $strt_time = date("g:i a",strtotime($_POST['data']['startTime']));
                          $starttimeexplode = explode(":",$strt_time);
                          $selval = '<select class="form-control strtsel" name="start" id="start">';
                          $selval .= '<option value="'.$_POST['data']['startTime'].'" selected>'.$starttimeexplode[0].':'.$starttimeexplode[1].'</option>';
                          while($tNow <= $tEnd){ 
                            $selval .= '<option value="'.date("H:i:s",$tNow).'">'.date("g:i a",$tNow).'</option>';
                            $tNow = strtotime('+30 minutes',$tNow);
                        }
                        $selval .= '</select>';
                        $end_time = date("g:i a",strtotime($_POST['data']['endTime']));
                        $endtimeexplode = explode(":", $end_time);
                        $endselval = '<select class="form-control endsel" name="end" id="end">';
                        $endselval .= '<option value="'.$_POST['data']['endTime'].'" selected>'.$endtimeexplode[0].':'.$endtimeexplode[1].'</option>';
                         $tNow = $tEnd;
                          while($tNow >= $tStart){ 
                            $endselval .= '<option value="'.date("H:i:s",$tNow).'" >'.date("g:i a",$tNow).'</option>';
                           $tNow = strtotime('-30 minutes',$tNow);
                        }
                        $endselval .= '</select>';


        $response = array('status' => 'success', 'start_time' => $selval, 'end_time' => $endselval);
        die(json_encode($response));
    }
    
}
 add_action('wp_ajax_staff_working_time', 'staff_working_time');
 add_action('wp_ajax_nopriv_staff_working_time', 'staff_working_time');





 //edit staff hours
 function edit_staffhours() {
     
     global $wpdb;
     $staff_working_dates =  $wpdb->get_results( "SELECT * FROM `staff_working_days` WHERE `staff_id` = ".$_POST['hidden_id']." AND `currdate` = '".date("Y-m-d", strtotime($_POST['hidden_date']))."'");
     if($staff_working_dates)
     {

        $update_data = $wpdb->update('staff_working_days',array('start_time' => date("H:i", strtotime($_POST['start'])),'end_time' => date("H:i", strtotime($_POST['end'])),'status'=>0), array( 'id' => $staff_working_dates[0]->id,'staff_id' => $_POST['hidden_id'], 'currdate' => date("Y-m-d", strtotime($_POST['hidden_date']))));
        $response = array('start_time' => date("g:i a", strtotime($_POST['start'])), 'end_time' => date("g:i a", strtotime($_POST['end'])),'identify' =>$_POST['hidden_identify']);
        die(json_encode($response));
     }
     else
     {
        $insert_data = $wpdb->insert('staff_working_days', array('staff_id' => $_POST['hidden_id'], 'currdate' => date("Y-m-d", strtotime($_POST['hidden_date'])),'start_time' => date("H:i:s", strtotime($_POST['start'])),'end_time' => date("H:i:s", strtotime($_POST['end'])),'status' =>0),array('%d','%s','%s','%s','%d'));
        $response = array('start_time' => date("g:i a", strtotime($_POST['start'])), 'end_time' => date("g:i a", strtotime($_POST['end'])),'identify' =>$_POST['hidden_identify']);
        die(json_encode($response));
     }
}
 add_action('wp_ajax_edit_staffhours', 'edit_staffhours');
 add_action('wp_ajax_nopriv_edit_staffhours', 'edit_staffhours');



//delete staff hours
function delete_staffhours() {
  global $wpdb;
  $staff_working_dates =  $wpdb->get_results( "SELECT * FROM `staff_working_days` WHERE `staff_id` = ".$_POST['data']['id']." AND `currdate` = '".date("Y-m-d", strtotime($_POST['data']['date']))."'");
  if($staff_working_dates)
  {
      $updates = $wpdb->update('staff_working_days', array('status' => 1), array('staff_id' => $_POST['data']['id'],'currdate' => date("Y-m-d", strtotime($_POST['data']['date']))));  
      die("updated");
  }
  else
  {
      $insert_data = $wpdb->insert('staff_working_days', array('staff_id' => $_POST['data']['id'], 'currdate' => date("Y-m-d", strtotime($_POST['data']['date'])),'status' =>1),array('%d','%s','%d'));
      die("inserted");
  }
}
 add_action('wp_ajax_delete_staffhours', 'delete_staffhours');
 add_action('wp_ajax_nopriv_delete_staffhours', 'delete_staffhours');




//load resources
function selectchange()
{
    global $wpdb;
    if($_POST['selectedValue']=='0')
    {
      die('no staff');
    }
    if($_POST['selectedValue']=='allstaff')
    {
        $current_user = wp_get_current_user(); 
        $salonid = $current_user->ID; 
        $staff =  $wpdb->get_results( "SELECT * FROM `saloon_staff` WHERE `saloon_id` = $salonid  AND `status`= 1 AND `curr_stat`= 0");
        foreach ($staff as $values) 
        {
            $resource_json[]= array("title"=>$values->firstname.' '.$values->lastname,"id"=>$values->staff_id);
        }
        die(json_encode($resource_json));
    }
    else
    {
        $staff =  $wpdb->get_results( 'SELECT * FROM `saloon_staff` WHERE `staff_id` ='. $_POST['selectedValue']);
        foreach ($staff as $values) 
        {
            $resource_json[]= array("title"=>$values->firstname.' '.$values->lastname,"id"=>$values->staff_id);
        }
        die (json_encode($resource_json));
    }
}
add_action('wp_ajax_selectchange', 'selectchange');
add_action('wp_ajax_nopriv_selectchange', 'selectchange');


//load events
function eventsajax()
{
    global $wpdb;
    $current_user = wp_get_current_user(); 
    $salonid = $current_user->ID;

    $saloon_closed_days =  $wpdb->get_results( 'SELECT * FROM `saloon_closed_date` WHERE `saloon_id` = '.$salonid , ARRAY_A);
    foreach ($saloon_closed_days as $clddays) 
    {
      $period = new DatePeriod(new DateTime($clddays['startdate']), new DateInterval('P1D'), new DateTime($clddays['enddate'].'+1 day'));
      foreach ($period as $closeddate) 
      {
          $closed_dates[] = $closeddate->format("Y-m-d");
      }   
    }
    if($_POST['selectedValue']=='0')
    {
      die('no staff');
    }
    if($_POST['selectedValue']=='allstaff')
    {
        $table_name = 'orders';
        $results = $wpdb->get_results("SELECT * FROM $table_name WHERE saloon_id = ".$salonid);
        $array = json_decode(json_encode($results), true);
        
        foreach ( $array as $result )
        {
            $order_id=$result['id'];
            $saloon_id=$result['saloon_id'];
            $staff_id=$result['staff_id'];
            $service_id=$result['service_id'];
            $customer_id=$result['customer_id'];
            $order_date = date('Y-m-d', strtotime( $result['date'] ));
            $service_start_time = $order_date .' '. $result['start_time'];
            //$service_end_time = $order_date .' '. $result['end_time'];
            $endtime = date('H:i:s',strtotime('+1 seconds', strtotime($result['end_time'])));
            $service_end_time = $order_date .' '. $endtime;

            $total_time = date_create($result['start_time'])->diff(date_create($result['end_time']))->format('%H:%i:%s');
            $order_status = $result['order_status'];
        // } 
        //get ordered services
        $serialize_service = unserialize($service_id);
        $service_name ='';
        foreach ( $serialize_service as $service ) 
        {
             $service =  $wpdb->get_results( 'SELECT * FROM `services` WHERE `id` = '.$service , ARRAY_A);
             foreach ($service as $item) 
             {
                $service_color_code = $wpdb->get_results( 'SELECT `colorcode` FROM `saloon_service` WHERE `service_id` = '.$item['id']);
                $service_name .= '<p>'.$item['service_name'].'</p>';  
             }  
        }
        //customer details
        if($result['order_type'] == 1)
         {
            //web
            $custdet=$wpdb->get_results( "SELECT * FROM customer_web WHERE cust_id = ".$customer_id); 
            $customer_details = $custdet[0]->cust_firstname.' '.$custdet[0]->cust_lastname;
         }
         else
         {
            //App
            $custdet = get_userdata($customer_id);
            $customer_details = $custdet->display_name;
         }
            
        //json array
        if($order_status == 1)
        {
          $json_output[] =array('title'=>$service_name,'start'=>$service_start_time,'end'=>$service_end_time,'resourceIds'=>[$staff_id],'service_name'=>$customer_details,'orderid'=>$order_id);
        }
      }
        die(json_encode($json_output));
    }
    else
    {
      $table_name = 'orders';
      $results = $wpdb->get_results("SELECT * FROM $table_name WHERE staff_id = ".$_POST['selectedValue']);
      $array = json_decode(json_encode($results), True);
      $saloon_closed_days =  $wpdb->get_results( 'SELECT * FROM `saloon_closed_date` WHERE `saloon_id` = '.$salonid , ARRAY_A);

                        foreach ($saloon_closed_days as $clddays) 
                        {
                            $period = new DatePeriod(new DateTime($clddays['startdate']), new DateInterval('P1D'), new DateTime($clddays['enddate'].'+1 day'));
                            
                            foreach ($period as $closeddate) 
                            {
                                $closed_dates[] = $closeddate->format("Y-m-d");
                            }   
                        }
      foreach ( $array as $result )
      {
          $order_id=$result['id'];
          $saloon_id=$result['saloon_id'];
          $staff_id=$result['staff_id'];
          $service_id=$result['service_id'];
          $customer_id=$result['customer_id'];
          $order_date = date('Y-m-d', strtotime( $result['date'] ));
          $service_start_time = $order_date .' '. $result['start_time'];
          //$service_end_time = $order_date .' '. $result['end_time'];
          $endtime = date('H:i:s',strtotime('+1 seconds', strtotime($result['end_time'])));
          $service_end_time = $order_date .' '. $endtime;
          $total_time = date_create($result['start_time'])->diff(date_create($result['end_time']))->format('%H:%i:%s');
          $order_status = $result['order_status'];
      
      //get ordered services
      $serialize_service = unserialize($service_id);
       $service_name ='';
      foreach ( $serialize_service as $service ) 
      {
           $service =  $wpdb->get_results( 'SELECT * FROM `services` WHERE `id` = '.$service , ARRAY_A);
          
           foreach ($service as $item) 
           {
              $service_color_code = $wpdb->get_results( 'SELECT `colorcode` FROM `saloon_service` WHERE `service_id` = '.$item['id']);
              $service_name .= '<p>'.$item['service_name'].'</p>';   
           }
      }
      //customer details
      if($result['order_type'] == 1)
         {
            //web
            $custdet=$wpdb->get_results( "SELECT * FROM customer_web WHERE cust_id = ".$customer_id); 
            $customer_details = $custdet[0]->cust_firstname.' '.$custdet[0]->cust_lastname.'</br>'.$custdet[0]->cust_mobile;
         }
         else
         {
            //App
            $custdet = get_userdata($customer_id);
            $phone = get_user_meta( $customer_id,'phone',true );
            $customer_details = $custdet->display_name.'<br>'.$phone;
         }
      //json array
      if($order_status == 1)
      {
        $json_output[] =array('title'=>$service_name,'start'=>$service_start_time,'end'=>$service_end_time,'resourceId'=>$_POST['selectedValue'],'service_name'=>$customer_details,'orderid'=>$order_id,'closed_date'=>$closed_dates);
      }
    }
      die(json_encode($json_output));
      }
  }
add_action('wp_ajax_eventsajax', 'eventsajax');
add_action('wp_ajax_nopriv_eventsajax', 'eventsajax');




//Delete Order

function deleteorder()
{
   global $wpdb;
   $updates = $wpdb->update('orders', array('order_status' => 0), array('id' => $_POST['orderid']));  
   $wpdb->insert( 'reshdul_cancel_orders', array('order_id' => $_POST['orderid'], 'reason' => $_POST['reason'],'orderstat'=>1),array('%d','%s' ,'%d'));
   
   $cancelnotification = $wpdb->insert( 'notification', array(
                          'order_id' => $_POST['orderid'],
                          'notif_date' => date('Y-m-d'),
                          'admin_read' => 0,
                          'customer_read' => 0,
                          'current_status' => 0,
                          'web_appstatus' =>1
                      ));

   $emaildet=$wpdb->get_results( "SELECT service_id,date,start_time,customer_id,saloon_id,order_type FROM orders WHERE id = ".$_POST['orderid']);   
   if($emaildet[0]->order_type == 1)
   {
      //web
      $custdet=$wpdb->get_results( "SELECT * FROM customer_web WHERE cust_id = ".$emaildet[0]->customer_id); 
      $custname=$custdet[0]->cust_firstname.' '.$custdet[0]->cust_lastname;
      $custemail=$custdet[0]->cust_email;
   }
   else
   {

      //App
      $custdet = get_userdata( $emaildet[0]->customer_id);
      $custname= $custdet->display_name;
      $custemail= $custdet->user_email;
   }

   $saloondet =get_userdata( $emaildet[0]->saloon_id);
   $serialize_service = unserialize($emaildet[0]->service_id);
   $service_names ='';
   foreach ( $serialize_service as $service ) 
   {
           $servicename =  $wpdb->get_results( 'SELECT * FROM `services` WHERE `id` = '.$service , ARRAY_A);
           foreach ($servicename as $item) 
           {
              $service_names .=$item['service_name'].' ,';
           }
       
    }
    $body = 'Hi'.' '.$custname ."<br><br>";
            $body .= $saloondet->display_name.' has cancelled your '.$service_names.'appointments on ' .date('l, d-m-Y',strtotime($emaildet[0]->date)) .' at '. date('H.i',strtotime($emaildet[0]->start_time)).'.'. "<br><br>";
            $body .= 'Salon`s Comment : '.$_POST['reason']."<br><br>";
            $body .= 'We apologize for inconvenience caused to you.' . "<br><br>";
            $body .= 'Regards,' . "<br>";
            $body .= 'Beautue Team' . "<br>";
            $headers = array('Content-Type: text/html; charset=UTF-8');
            $to = $custemail;
            $subject = 'Beautue Appointment Cancellation';
            // print_r($body);
            $sent = wp_mail($to, $subject, $body, $headers);



$user_id = $emaildet[0]->customer_id;
if(isset($user_id)) {
    $userID = $user_id;
} else {
    $userID = 0;
}

$havemeta = get_user_meta($userID, 'deviceid', true);

if(isset($havemeta)) {

    // API access key from Google FCM App Console
    define( 'API_ACCESS_KEY', 'AAAAU9VLlNM:APA91bFeRKU6OkQutQ8Dr3zsipcSKCkSiSoiCs0mqCVGVvxMsjNH5VOhMorDNzl9SfE8qEmZzNP1v0bVcA3Xie2FfVjiwux7KxD0WEU4e4a7wrSYXz9O5iUJmfKmx0FVNpdzrr7allsb' );

    // generated via the cordova phonegap-plugin-push using "senderID" (found in FCM App Console)
    // this was generated from my phone and outputted via a console.log() in the function that calls the plugin
    // my phone, using my FCM senderID, to generate the following registrationId 
    $singleID = $havemeta; 

    $registrationIDs = array(
         'AAAAU9VLlNM:APA91bFeRKU6OkQutQ8Dr3zsipcSKCkSiSoiCs0mqCVGVvxMsjNH5VOhMorDNzl9SfE8qEmZzNP1v0bVcA3Xie2FfVjiwux7KxD0WEU4e4a7wrSYXz9O5iUJmfKmx0FVNpdzrr7allsb'
    ) ;

    // prep the bundle
    // to see all the options for FCM to/notification payload: 
    // https://firebase.google.com/docs/cloud-messaging/http-server-ref#notification-payload-support
    

    // 'vibrate' available in GCM, but not in FCM
    $fcmMsg = array(
        'body' => 'Your booking is resheduled for '.$service_names.' appointments on ' .date('l, d-m-Y',strtotime($emaildet[0]->date)) .' at '. date('H.i',strtotime($emaildet[0]->start_time)).'.'.' to '.date('l, d-m-Y',strtotime($custdate)).' at '.date("H:i",strtotime($starttimesal)),
        'title' => 'Beautue Appointment Booking Resheduled',
        'sound' => "default",
            'color' => "#203E78" 
    );
    // I haven't figured 'color' out yet.  
    // On one phone 'color' was the background color behind the actual app icon.  (ie Samsung Galaxy S5)
    // On another phone, it was the color of the app icon. (ie: LG K20 Plush)

    // 'to' => $singleID ;  // expecting a single ID
    // 'registration_ids' => $registrationIDs ;  // expects an array of ids
    // 'priority' => 'high' ; // options are normal and high, if not set, defaults to high.
    $fcmFields = array(
        'to' => $singleID,
        'priority' => 'high',
        'notification' => $fcmMsg
    );

    $headers = array(
        'Authorization: key=' . API_ACCESS_KEY,
        'Content-Type: application/json'
    );
     
    $ch = curl_init();
    curl_setopt( $ch,CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send' );
    curl_setopt( $ch,CURLOPT_POST, true );
    curl_setopt( $ch,CURLOPT_HTTPHEADER, $headers );
    curl_setopt( $ch,CURLOPT_RETURNTRANSFER, true );
    curl_setopt( $ch,CURLOPT_SSL_VERIFYPEER, false );
    curl_setopt( $ch,CURLOPT_POSTFIELDS, json_encode( $fcmFields ) );
    $result = curl_exec($ch );
    curl_close( $ch );
    //echo $result . "\n\n";

} 



   $response = array('status' => 'success', 'title' => 'Success', 'message' => 'Appointment Cancelled.','new_url'=>get_permalink(60));
  die(json_encode($response));
  
}
add_action('wp_ajax_deleteorder', 'deleteorder');
add_action('wp_ajax_nopriv_deleteorder', 'deleteorder');


//Add Appointment
function addappointment()
{
    
    $custdate = $_POST['custdate'];
    $cutfname = $_POST['cutfname'];
    $mobnum = $_POST['mobnum'];
    $custgender = $_POST['custgender'];
    $custemail = $_POST['custemail'];
    $servicedet = $_POST['selectmultiple'];
    $staffid = $_POST['staffid'];
    $serviceid = serialize($servicedet);
    $servicecheck = unserialize($serviceid);
    $timeduration = $_POST['timeduration'];
    // $timestart = $_POST['timestart'];
    $timestart = date("H:i:s",strtotime($_POST['timestart']));
    $notes = $_POST['notes'];

    $secs = strtotime($timeduration)-strtotime("00:00:00");
    $timeend = date("H:i:s",strtotime($timestart)+$secs);
    
    $timeendplus = date("H:i:s", strtotime('-1 seconds', strtotime($timeend)));

    $apnt_datetime = $custdate.' '.$timestart;

    $curDateTime = date("Y-m-d H:i:s");

    // if($apnt_datetime < $curDateTime){
    //     $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Appointment not allowed for past days');
    //     die(json_encode($response));
    // }
   $current_user = wp_get_current_user(); 
   $salonid = $current_user->ID; 

   $saloondat = get_user_meta ( $salonid ); 
   $usrdet = get_userdata( $salonid ); 
   $saladdress = $saloondat['address'][0]; 
   $salonname = $usrdet->display_name; 
   $salcity = $saloondat['city'][0]; 
   $salzip = $saloondat['zip'][0]; 
   $saloonaddress = $salonname.' '.$saladdress.' '.$salcity.' '.$salzip; 
   //echo $timeend; 
   //exit;    
   global $wpdb;
    $tablename = 'saloon_staff';
    $tablename1 = 'services';
    $staffname = $wpdb->get_results( "SELECT firstname, lastname from $tablename WHERE staff_id = $staffid" );
    foreach($staffname as $stfn) {
      $stafulname = $stfn->firstname.' '.$stfn->lastname;
    }

    $totalservice='';
    foreach($servicedet as $serval) {
      $servicename = $wpdb->get_results( "SELECT service_name from $tablename1 WHERE id = $serval" );
      foreach ($servicename as $serval) {
          $totalservice .= $serval->service_name.', ';
      }
    }

    $totalservice = rtrim($totalservice,', ');


    $tablesel = 'orders';
    //$availchk = $wpdb->get_results( "SELECT * FROM $tablesel WHERE saloon_id = $salonid AND staff_id = $staffid AND `date` = '$custdate' AND ('$timestart' between start_time and end_time OR '$timeend' between start_time and end_time) AND " );
    $availchk = $wpdb->get_results( "SELECT * FROM $tablesel WHERE saloon_id = $salonid AND order_status = 1 AND staff_id = $staffid AND `date` = '$custdate' AND ('$timestart' between start_time and end_time OR '$timeendplus' between start_time and end_time)" );
    
    // echo $wpdb->last_query;

    if(count($availchk)>0) {
        $json_output = array('status'=>'error');
        die(json_encode($json_output));

    } else {

      $curday = date('D',strtotime($custdate));

      $curdayname = strtolower($curday).'_end';

      $tabsalwork = ' saloon_working_days';

      $curdayendtime = $wpdb->get_results( "SELECT * FROM $tabsalwork WHERE saloon_id = $salonid" );
      
      foreach($curdayendtime as $endtm) {
        $endtm = $endtm->$curdayname;
      }
      if($timeend > $endtm) {
            $starttimestamp = strtotime($timeend);
            $endtimestamp = strtotime($endtm);
            $difference = abs($endtimestamp - $starttimestamp)/60;
            $json_output = array('status'=>'error');
            die(json_encode($json_output));
        }
        else {

          $table_name = "customer_web";
           
                    $wpdb->insert( $table_name, array(
                        'cust_firstname' => $cutfname,
                        'cust_mobile' => $mobnum,
                        'cust_gender' => $custgender,
                        'cust_email' => $custemail
                    ));

               $lastid = $wpdb->insert_id; 
            if($lastid) {     

            $table_name = "orders";
            
                      $insertorder = $wpdb->insert( $table_name, array(
                          'saloon_id' => $salonid,
                          'service_id' => $serviceid,
                          'staff_id' => $staffid,
                          'date' => $custdate,
                          'customer_id' => $lastid,
                          'start_time' => $timestart,
                          'end_time' => $timeendplus,
                          'order_status' => 1,
                          'order_type' => 1,
                          'order_notes' => $notes
                      ));  

                      $ordr_id = $wpdb->insert_id; 

              $insertnotification = $wpdb->insert( 'notification', array(
                          'order_id' => $ordr_id,
                          'notif_date' => date('Y-m-d'),
                          'admin_read' => 0,
                          'customer_read' => 0,
                          'current_status' => 1,
                          'web_appstatus' =>1
                      ));
          }   
          if($insertorder) {

            $table_custweb = "customer_web";
            $table_usrweb = "customer_web";
            $results = $wpdb->get_results( "SELECT $table_custweb.cust_email FROM $table_custweb where cust_email = '$custemail' UNION SELECT $table_usrweb.user_email FROM $table_usrweb where user_email = '$custemail'" );
        
                   if(count($results)!=0) {
                       $email = WP_Mail::init()
                      ->to($custemail)
                      ->subject('Welcome to Beautue')
                      ->template(get_template_directory() .'/template_parts/emailer_unregistered.php')
                      ->send();
                    }

                $email = WP_Mail::init()
                  ->to($custemail)
                  ->subject('Appointment Booked')
                  ->template(get_template_directory() .'/template_parts/emailer.php', [
                      'name' => $cutfname,
                      'When' => $custdate.'|'.date('H:i',strtotime($timestart)).' to '.date('H:i',strtotime($timeend)),
                      'What' => $totalservice,
                      'Where'=> $saloonaddress,
                      'With'=>  $stafulname,
                  ])
                  ->send();
                          

            $json_output = array('status'=>'Success','urlredirect'=>get_permalink(60));
          
          }
           die(json_encode($json_output));
      }
    }


}
add_action('wp_ajax_addappointment', 'addappointment');
add_action('wp_ajax_nopriv_addappointment', 'addappointment');


//Reshedule Appointment
function resheduleappointment()
{
  // print_r($_POST);
  // die($_POST);
    $current_user = wp_get_current_user();
    $txt_comment = $_POST['txtaracommentbox'];
    $salonid = $current_user->ID;
    $orderid = $_POST['orderid'];
    $custdate = date('Y/m/d',strtotime($_POST['date']));
    $curDate = date("Y-m-d");
    $myDate = date("Y-m-d", strtotime($custdate));
    
    $curDateTime = date("H:i");
    $timestart = $_POST['starttime'];
    if($myDate < $curDate){
        $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Appointment not allowed for past days');
        die(json_encode($response));
    }
    
    // print_r($timestart);
    // print_r($curDateTime);
    if($curDateTime > $timestart[0])
    {
        $response = array('status' => 'failed', 'title' => 'Failed', 'message' => 'Appointment not allowed for past time');
        die(json_encode($response));
    }
    $servicedetid = $_POST['serviceid'];
    $servicedelid = $_POST['servicedelid'];
    $servicedet = array_diff($servicedetid, $servicedelid);
    $servicedelids = $_POST['servicedelids'];
    foreach ( $servicedelids as $servicedelt ) 
     {
        if($servicedelt!='')
        {
          $sevdel[]=$servicedelt;
        }
    }
    $staffid = $_POST['staffid'];
    $serviceid = serialize($servicedet);
    $servicecheck = unserialize($serviceid);
    global $wpdb;
    $wpdb->insert( 'reshdul_cancel_orders', array('order_id' => $orderid, 'reason' => $txt_comment,'orderstat'=>3),array('%d','%s' ,'%d'));
    $emaildet=$wpdb->get_results( "SELECT service_id,date,start_time,customer_id,saloon_id,order_type FROM orders WHERE id = ".$orderid);   
     if($emaildet[0]->order_type == 1)
     {
        //web
        $custdet=$wpdb->get_results( "SELECT * FROM customer_web WHERE cust_id = ".$emaildet[0]->customer_id); 
        $custname=$custdet[0]->cust_firstname.' '.$custdet[0]->cust_lastname;
        $custemail=$custdet[0]->cust_email;
     }
     else
     {
        //App
        $custdet = get_userdata( $emaildet[0]->customer_id);
        $custname= $custdet->display_name;
        $custemail= $custdet->user_email;
     }
     $service_names ='';
     foreach ( $servicecheck as $service ) 
     {
             $servicename =  $wpdb->get_results( 'SELECT * FROM `services` WHERE `id` = '.$service , ARRAY_A);
             foreach ($servicename as $item) 
             {
                $service_names .=$item['service_name'].' ,';
             }
         
      }

      $delservice_name ='';
     foreach ( $sevdel as $delservice ) 
     {
             $servicename =  $wpdb->get_results( 'SELECT * FROM `services` WHERE `id` = '.$delservice , ARRAY_A);
             foreach ($servicename as $item) 
             {
                $delservice_name .= $item['service_name'].' ,';
             }
         
      }
      $saloondet =get_userdata( $salonid);
    $durationdet = '00:00:00';
    foreach ( $servicedet as $service ) 
    {
         $servicedetals = $wpdb->get_results( "SELECT * FROM `saloon_service` WHERE `service_id` = $service AND `saloon_id` = $salonid");
         foreach($servicedetals as $items) 
         {
            $time = $items->Duration;
            list($hour, $minute, $seconds) = explode(':', $time);
            $minutes += $hour * 60;
            $minutes += $minute;
        }
    }
    $hours = floor($minutes / 60);
    $minutes -= $hours * 60;
    $timeduration = sprintf('%02d:%02d', $hours, $minutes);
    //$timestartplus = date("H:i", strtotime('+1 minutes', strtotime($timestart)));
    $starttimesal = $timestart[0];
    $timestart = date("H:i:s",strtotime($starttimesal));
    $secs = strtotime($timeduration)-strtotime("00:00:00");
    $timeend = date("H:i:s",strtotime($starttimesal)+$secs);
    $timeendplus = date("H:i:s", strtotime('-1 seconds', strtotime($timeend)));
    //echo $timeendplus;
    //exit;

    $tablesel = 'orders';

    $curday = date('D',strtotime($custdate));

    $curdayname = strtolower($curday).'_end';

    $tabsalwork = ' saloon_working_days';

    $curdayendtime = $wpdb->get_results( "SELECT * FROM $tabsalwork WHERE saloon_id = $salonid" );

    foreach($curdayendtime as $endtm) {
      $endtm = $endtm->$curdayname;
    }
    //exit;
    $availchk = $wpdb->get_results( "SELECT * FROM $tablesel WHERE id <> $orderid AND saloon_id = $salonid AND order_status = 1 AND staff_id = $staffid AND `date` = '$custdate' AND ('$timestart' between start_time and end_time OR '$timeendplus' between start_time and end_time)" );
    
    //echo $wpdb->last_query;
    //exit;

    if(count($availchk)>0) 
    {
        $json_output = array('status'=>'error','message'=>'Staff Not Available on the Selected Time');
        die(json_encode($json_output));
    } 
    else 
    {   
        if($timeend > $endtm) {
            $starttimestamp = strtotime($timeend);
            $endtimestamp = strtotime($endtm);
            $difference = abs($endtimestamp - $starttimestamp)/60;
            
            //echo $difference;
            //exit;
            
            $json_output = array('status'=>'error','message'=>'Staff Not Available on the Selected Time.
              Please Remove Service to Free up '.$difference.' Minutes');
            die(json_encode($json_output));
        } else {

            $table_name = "orders";

            // echo $serviceid.'='.$starttimesal.'='.$timeendplus.'='.$staffid.'='.$orderid;
            // exit;
            
            $updateorder = $wpdb->update($table_name, array(
            'service_id' => $serviceid,
            'start_time' => $starttimesal,
            'end_time' => $timeendplus,
            'staff_id' => $staffid,
            'date'=>$custdate
            ), 
             array(
                'id' => $orderid
            ));

             // $reschle_notification = $wpdb->get_results( "SELECT * FROM notification WHERE order_id = $orderid" );
             
          if($updateorder) {

                      $insertnotification = $wpdb->insert( 'notification', array(
                          'order_id' => $orderid,
                          'notif_date' => date('Y-m-d'),
                          'admin_read' => 0,
                          'customer_read' => 0,
                          'current_status' => 2,
                          'web_appstatus' =>1
                      ));




                              $body = 'Hi'.' '.$custname ."<br><br>";
                              $body .= $saloondet->display_name.' has rescheduled your '.rtrim($service_names,', ').' appointments on ' .date('l, d-m-Y',strtotime($emaildet[0]->date)) .' at '. date('H.i',strtotime($emaildet[0]->start_time)).'.'.' to '.date('l, d-m-Y',strtotime($custdate)).' at '.date("H:i",strtotime($starttimesal)). "<br><br>";
                              $body .= 'Salon`s Comment : '.$_POST['txtaracommentbox']."<br><br>";
                              if($delservice_name)
                              {
                                $body .= 'Deleted Services : '.rtrim($delservice_name,', ')."<br><br>";
                              }
                              $body .= 'We apologize for inconvenience caused to you.' . "<br><br>";
                              $body .= 'Regards,' . "<br>";
                              $body .= 'Beautue Team' . "<br>";
                              $headers = array('Content-Type: text/html; charset=UTF-8');
                              $to = $custemail;
                              $subject = 'Beautue Appointment Reschedule';
                              $sent = wp_mail($to, $subject, $body, $headers);


$user_id = $emaildet[0]->customer_id;
if(isset($user_id)) {
    $userID = $user_id;
} else {
    $userID = 0;
}

$havemeta = get_user_meta($userID, 'deviceid', true);

if(isset($havemeta)) {

    // API access key from Google FCM App Console
    define( 'API_ACCESS_KEY', 'AAAAU9VLlNM:APA91bFeRKU6OkQutQ8Dr3zsipcSKCkSiSoiCs0mqCVGVvxMsjNH5VOhMorDNzl9SfE8qEmZzNP1v0bVcA3Xie2FfVjiwux7KxD0WEU4e4a7wrSYXz9O5iUJmfKmx0FVNpdzrr7allsb' );

    // generated via the cordova phonegap-plugin-push using "senderID" (found in FCM App Console)
    // this was generated from my phone and outputted via a console.log() in the function that calls the plugin
    // my phone, using my FCM senderID, to generate the following registrationId 
    $singleID = $havemeta; 

    $registrationIDs = array(
         'AAAAU9VLlNM:APA91bFeRKU6OkQutQ8Dr3zsipcSKCkSiSoiCs0mqCVGVvxMsjNH5VOhMorDNzl9SfE8qEmZzNP1v0bVcA3Xie2FfVjiwux7KxD0WEU4e4a7wrSYXz9O5iUJmfKmx0FVNpdzrr7allsb'
    ) ;

    // prep the bundle
    // to see all the options for FCM to/notification payload: 
    // https://firebase.google.com/docs/cloud-messaging/http-server-ref#notification-payload-support
    

    // 'vibrate' available in GCM, but not in FCM
    $fcmMsg = array(
        'body' => 'Your booking is resheduled for '.$service_names.' appointments on ' .date('l, d-m-Y',strtotime($emaildet[0]->date)) .' at '. date('H.i',strtotime($emaildet[0]->start_time)).'.'.' to '.date('l, d-m-Y',strtotime($custdate)).' at '.date("H:i",strtotime($starttimesal)),
        'title' => 'Beautue Appointment Booking Resheduled',
        'sound' => "default",
            'color' => "#203E78" 
    );
    // I haven't figured 'color' out yet.  
    // On one phone 'color' was the background color behind the actual app icon.  (ie Samsung Galaxy S5)
    // On another phone, it was the color of the app icon. (ie: LG K20 Plush)

    // 'to' => $singleID ;  // expecting a single ID
    // 'registration_ids' => $registrationIDs ;  // expects an array of ids
    // 'priority' => 'high' ; // options are normal and high, if not set, defaults to high.
    $fcmFields = array(
        'to' => $singleID,
        'priority' => 'high',
        'notification' => $fcmMsg
    );

    $headers = array(
        'Authorization: key=' . API_ACCESS_KEY,
        'Content-Type: application/json'
    );
     
    $ch = curl_init();
    curl_setopt( $ch,CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send' );
    curl_setopt( $ch,CURLOPT_POST, true );
    curl_setopt( $ch,CURLOPT_HTTPHEADER, $headers );
    curl_setopt( $ch,CURLOPT_RETURNTRANSFER, true );
    curl_setopt( $ch,CURLOPT_SSL_VERIFYPEER, false );
    curl_setopt( $ch,CURLOPT_POSTFIELDS, json_encode( $fcmFields ) );
    $result = curl_exec($ch );
    curl_close( $ch );
    //echo $result . "\n\n";

} 


            $json_output = array('status'=>'success','urlredirect'=>get_permalink(60), 'message'=>'Appointment Rescheduled Successfully');
          
          } else {
            $json_output = array('status'=>'error','message'=>'No Changes are made to update');
          }
          // return $json_output; 
          die(json_encode($json_output));
        }
    }


}
add_action('wp_ajax_resheduleappointment', 'resheduleappointment');
add_action('wp_ajax_nopriv_resheduleappointment', 'resheduleappointment');



///closed date Appointments 
function closedateappointment()
{
  global $wpdb;
  $dates=$_POST['data']['date'];
  // $day=$_POST['data']['currentday'];
  $current_user = wp_get_current_user(); 
  $salonid = $current_user->ID; 
  // $today_start=$day.'_start';
  // $today_end=$day.'_end';
  // $seldaytime =$wpdb->get_results( 'SELECT '.$today_start.','.$today_end.' FROM `saloon_working_days` WHERE `saloon_id` = '.$salonid);
  // $mintime=$seldaytime[0]->$today_start;
  // $maxtime=$seldaytime[0]->$today_end;
  $saloon_closed_days =  $wpdb->get_results( 'SELECT * FROM `saloon_closed_date` WHERE `saloon_id` = '.$salonid , ARRAY_A);
  $date=date('Y-m-d',strtotime($dates));
  $ts = strtotime($date);
  $year = date('o', $ts);
  $week = date('W', $ts);
  $days[0] = 'sun';
  $days[1] = 'mon';
  $days[2] = 'tue';
  $days[3] = 'wed';
  $days[4] = 'thu';
  $days[5] = 'fri';
  $days[6] = 'sat';
  foreach ($saloon_closed_days as $clddays) 
  {
      $period = new DatePeriod(new DateTime($clddays['startdate']), new DateInterval('P1D'), new DateTime($clddays['enddate'].'+1 day'));                  
      foreach ($period as $closeddate) 
      {
          $closed_dates[] = $closeddate->format("Y-m-d");
      }   
  }
  $saloon_working_days =  $wpdb->get_results( 'SELECT * FROM `saloon_working_days` WHERE `saloon_id` = '.$salonid , ARRAY_A);                  
  foreach ($saloon_working_days as $items) 
  {
      for($i = 0; $i < 7; $i++) 
      {
         $flag=1;
         $ts = strtotime($year.'W'.$week.$i);
         $weekdays = date('Y-m-d',$ts);
         if (in_array($weekdays, $closed_dates)) 
         {
              $datess[] =$weekdays;
              $flag=0;
          }
          else
          {
              $wrkdays = $items[$days[$i].'_start'];
              if($wrkdays=='')
              {
                  $datess[] =$weekdays;
              }
              $flag=0;
            }
          
      }
   }
  if($flag==0)
  {
    $json_output = array('status'=>'closed','closeddate'=>$datess);
              die(json_encode($json_output));  
  }
  
}
add_action('wp_ajax_closedateappointment', 'closedateappointment');
add_action('wp_ajax_nopriv_closedateappointment', 'closedateappointment');




///open dates Appointments 
function opendateappointment()
{
  $dates=$_POST['data']['date'];
  global $wpdb;
  $current_user = wp_get_current_user(); 
  $salonid = $current_user->ID; 
  $date=date('Y-m-d',strtotime($dates));
  $ts = strtotime($date);
  $year = date('o', $ts);
  $week = date('W', $ts);
  $days[0] = 'sun';
  $days[1] = 'mon';
  $days[2] = 'tue';
  $days[3] = 'wed';
  $days[4] = 'thu';
  $days[5] = 'fri';
  $days[6] = 'sat';
  $saloon_closed_days =  $wpdb->get_results( 'SELECT * FROM `saloon_closed_date` WHERE `saloon_id` = '.$salonid , ARRAY_A);
  foreach ($saloon_closed_days as $clddays) 
  {
       $period = new DatePeriod(new DateTime($clddays['startdate']), new DateInterval('P1D'), new DateTime($clddays['enddate'].'+1 day'));
       foreach ($period as $closeddate) 
        {
            $closed_dates[] = $closeddate->format("Y-m-d");
        }
  }
  $saloon_working_days =  $wpdb->get_results( 'SELECT * FROM `saloon_working_days` WHERE `saloon_id` = '.$salonid , ARRAY_A);                  
  foreach ($saloon_working_days as $items) 
  {
      for($i = 1; $i <= 7; $i++) 
      {
          $ts = strtotime($year.'W'.$week.$i);
          $weekdays = date('Y-m-d',$ts);
          $wrkdays = $items[$days[$i].'_start'];
          if($wrkdays=='')
          {
              $datess[] =$weekdays;
          }
      }
  }
  $result = array_merge($datess,$closed_dates);
  if (in_array($dates, $result)) 
  {
      // $json_output = array('status'=>'closed','closeddate'=>$closed_dates,'mintime'=>$mintime,'maxtime'=>$maxtime);
    $json_output = array('status'=>'closed','closeddate'=>$closed_dates);
      die(json_encode($json_output));
  }
  else
  {
      // $json_output = array('status'=>'open','mintime'=>$mintime,'maxtime'=>$maxtime);
      $json_output = array('status'=>'open');
      die(json_encode($json_output));
  }
  }
add_action('wp_ajax_opendateappointment', 'opendateappointment');
add_action('wp_ajax_nopriv_opendateappointment', 'opendateappointment');



function genderchange()
{
  global $wpdb;
  $current_user = wp_get_current_user(); 
  $salonid = $current_user->ID; 
  $salonservstat = $_POST['data']['value'];
  $salonunisexstat = $_POST['data']['unisex_val'];
  $serv =  array($salonservstat,$salonunisexstat);
  $services =  $wpdb->get_results( "SELECT services.id,services.service_name,saloon_service.rate,saloon_service.Duration FROM services INNER JOIN saloon_service ON services.id = saloon_service.service_id WHERE saloon_id = $salonid AND saloon_service.Available_for IN(".implode(',',$serv).")", ARRAY_A );                    
  foreach ( $services as $values ) 
  { 
    $availserv[] = $values;
  }
  die(json_encode($availserv));
}
add_action('wp_ajax_genderchange', 'genderchange');
add_action('wp_ajax_nopriv_genderchange', 'genderchange');
?>