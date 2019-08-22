<?php
if ( !is_user_logged_in() ) {
    //echo 'Welcome, registered user!';
    $url = get_permalink(35);
    //echo $url;
    //exit;
    //header('location:'.$url);
    if(!is_page(35) && !is_page(33) && !is_page(48) && !is_page(65)) {
    	header('Location: '.$url);
	    //wp_redirect( $url );
	    exit;
	}
} 
else 
{
	if(is_page(35) || is_page(33)) 
	{
		$url = get_permalink(50);
		//wp_logout();
    	header('Location: '.$url);
	    exit;
	}

}

?>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<link rel="shortcut icon" href="<?php echo get_template_directory_uri(); ?>/images/favicon.ico">
<title>BEAUTUE</title>
<?php wp_head(); ?>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/css/style.css" />
<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/css/bootstrap.min.css">
<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/css/normalize.css">
<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/css/font-awesome.css">
<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/css/bootstrap-datetimepicker.css">
<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/css/bootstrap-datetimepicker-standalone.css">
<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/css/sweetalert2.css">
<link href='https://fullcalendar.io/assets/demo-topbar.css' rel='stylesheet' />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.min.css">
<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/fonts/flat-icons/font/flaticon.css">

<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/js/scheduler.min.css" />

<link rel="stylesheet" type="text/css" media="screen" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.7.5/css/bootstrap-select.min.css">
</head>
<body>

  