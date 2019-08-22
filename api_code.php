<?php
function get_nearsaloonlist() {

    //$inpsectok = 'b768a4ca09ae100bb10d7d5fa5b4ec68';  

    //$inpsectok = md5(date('Y-M-D').'beautueappsecuretoken');   

    $inpsectok = md5($_POST['securitytoken']);

    //return($_POST);
    //exit;

    $inptok = date('Y-M-D').'beautueappsecuretoken';
    //return($inptok);
    //exit;

    //return($_POST['securitytoken'].'-----'.$inptok);
    //exit;

    //$sectok = md5(uniqid(rand(), true));  
    $sectok = md5($inptok);    
    //echo $sectok;
    //exit;


    //return($inpsectok.'-----'.$sectok);
    //exit;

    if($sectok==$inpsectok) {

        $t=date('d-m-Y');
        //$curday = date("D",strtotime($t));

        $curday = date("l",strtotime($t));

        //echo $curday;
        //exit;

        $inputlatitide = $_POST['lattitude'];   // Device Location Lattitude 

        $inputlongitude = $_POST['longitude'];   // Device Location Lattitude 
        
        $inputservice = $_POST['serviceid']; // Selected Service

        $inputdate = date("Y-m-d"); // Selected Date 

        //echo $inputdate;
        //exit;

        

        //echo $inputlatitide.' '.$inputlongitude.' '.$inputdate.' '.$inputservice.' '.$inputsession;   
        //exit;

        $args = array(
            'role'    => 'Saloon Manager',
            'meta_key' => 'saloon_status', 
            'meta_value' => 2,
            'orderby' => 'user_registered',
            'order'   => 'DESC'
        );

        $users = get_users( $args );
        global $wpdb;
        $table_name = "saloon_service";
        $table_name1 = "saloon_closed_date";
        $results = $wpdb->get_results( "SELECT DISTINCT saloon_service.saloon_id FROM $table_name WHERE $table_name.service_id=$inputservice AND $table_name.saloon_id NOT IN(SELECT DISTINCT saloon_id FROM $table_name1 WHERE '$inputdate' between startdate and enddate)" );

        $i = 0;

        if(count($results)>0) { 
            foreach($results as $user_id){
 
                //print_r(get_user_meta ( $user_id->ID));
                //$sldid = $wpdb->get_results( "SELECT DISTINCT saloon_id FROM $table_name1 WHERE '$inputdate' between startdate and enddate" );
                //print_r($sldid);
                //exit;


               
            $t=date('d-m-Y');     

            $curday = date("D",strtotime($t)); 

            $daystartcol = strtolower($curday).'_start';
            $dayendcol = strtolower($curday).'_end';

            global $wpdb;
            $table_name1 = "saloon_service";
            $table_name = "services";
            $table_name2 = "gallery";
            $table_name3 = "saloon_working_days";

            $saloonid = $user_id->saloon_id;

            $chksaldet = $wpdb->get_results( "SELECT salwkgdys.*, GROUP_CONCAT(gal.image) as gallimg,serv.*, salserv.service_name FROM $table_name3 as salwkgdys 
                LEFT JOIN $table_name2 as gal 
                ON  salwkgdys.saloon_id = gal.saloon_id
                LEFT JOIN $table_name1 as serv 
                ON  salwkgdys.saloon_id = serv.saloon_id
                LEFT JOIN $table_name as salserv 
                ON  serv.service_id = salserv.id
                WHERE salwkgdys.saloon_id = $saloonid
                AND salwkgdys.$daystartcol <> '' 
                GROUP BY serv.id
                " );
            //print_r($wpdb->last_query);
            //exit;
            //echo count($chksaldet);
            //exit;
            if(count($chksaldet)>0) {



                $saloondat = get_user_meta ( $user_id->saloon_id);
                $userid = $user_id->saloon_id;
                $usrdet = get_userdata( $userid );

                $saladdress = $saloondat['address'][0].' '.$saloondat['city'][0];
                $salonname = $usrdet->display_name;
                $imageurl = get_site_url().'/wp-content/uploads/profile/'.$saloondat['profile_image'][0];

                $salcity = $saloondat['city'][0];
                $salzip = $saloondat['zip'][0];

                $address = $saladdress;

                //echo $address;
                //exit;
            
            //for($i=0;$i<2;$i++) { 

          
            /*$geocode_stats = file_get_contents("http://maps.googleapis.com/maps/api/geocode/json?latlng=".$inputlatitide.",".$inputlongitude."&sensor=false");
            $output_deals = json_decode($geocode_stats);

            $country = $output_deals->results[0]->address_components[5]->long_name;
            $countrycode = $output_deals->results[0]->address_components[5]->short_name;*/

            //echo $country;
            //exit;

            //$geocode_stats = file_get_contents("http://maps.googleapis.com/maps/api/geocode/json?latlng=".$inputlatitide.",".$inputlongitude."&sensor=false");
            //$output_deals = json_decode($geocode_stats);
            //$country = $output_deals->results[2]->address_components[4]->long_name;

            //echo $country." ".$countrycode;
            //exit;

            // Distance caluclator 

            //$address = 'Idaserril Chambers, Pottakuzhy Rd, Kochi, Kerala';
            //echo $address;
            //exit;

            $address = str_replace(" ", "+", $address);
            
            /*$geocode = file_get_contents('http://maps.google.com/maps/api/geocode/json?address='.$address.'&sensor=false');
            $output= json_decode($geocode);
            $lattitude = $output->results[0]->geometry->location->lat;
            $longitude = $output->results[0]->geometry->location->lng;*/

            $lattitude = get_user_meta($userid, 'salon_lattitude', true);
            $longitude = get_user_meta($userid, 'salon_longitude', true);

            //echo $lattitude.' '.$longitude;
            //exit;

        	//$lattitude = 9.9939185;
        	//$longitude = 76.2883014;  

            //echo $lattitude.'---'.$longitude;
            //exit;

            //print_r($distoutput_deals);
            //exit;

        	  $theta = $inputlongitude - $longitude;
    		  $dist = sin(deg2rad($inputlatitide)) * sin(deg2rad($lattitude)) +  cos(deg2rad($inputlatitide)) * cos(deg2rad($lattitude)) * cos(deg2rad($theta));
    		  $dist = acos($dist);
    		  $dist = rad2deg($dist);
    		  $miles = $dist * 60 * 1.1515;
    		  //$unit = strtoupper($unit);
    		  $unit = 'K';

    		  if ($unit == "K") {
    		    $saldistance = $miles * 1.609344;
    		  } else if ($unit == "N") {
    		      $saldistance = $miles * 0.8684;
    		    } else {
    		        $saldistance = $miles;
          		}

          	//echo $saldistance;
          	//exit;	

    	    // Distance Calculator Ends  


          	// List Saloon within 200 KM	

        	    if($saldistance<=200) {		

        		    $posts[$i]['SaloonId'] = $userid;   
        		    $posts[$i]['SaloonName'] = $salonname; 
        		    $posts[$i]['SaloonImageURl'] = $imageurl; 
        		    $posts[$i]['SaloonAddress'] = $saladdress; 
        		    $posts[$i]['SaloonDistance'] = round($saldistance,2).' KM';  

        		}
    	//}  
                $i++;   

            }     
            }

        }

        $dist = array();
        foreach ($posts as $key => $row)
        {
            $dist[$key] = $row['SaloonDistance'];
        }
        array_multisort($dist, SORT_ASC, $posts);

    	return $posts;
    } 

}

add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/getnearsaloonlist', array(
        'methods' => 'POST',
        'callback' => 'get_nearsaloonlist',
    ));
});


function get_saloonlist() {

    // Input Parameters  

    //$inpsectok = 'b768a4ca09ae100bb10d7d5fa5b4ec68';    
    //$inpsectok = md5(date('Y-M-D').'beautueappsecuretoken'); 

    $inpsectok = md5($_POST['securitytoken']);

    //return($inpsectok);
    //exit;

    $inptok = date('Y-M-D').'beautueappsecuretoken';
    //echo $inptok;
    //exit;

    //$sectok = md5(uniqid(rand(), true));  
    $sectok = md5($inptok);    
    //echo $sectok;
    //exit;
    //echo 'asdasdadasdsaas';
    //echo $sectok.' '.$inpsectok;
    //exit;

    if($sectok==$inpsectok) {  

        $t=date('d-m-Y');
        $curday = date("D",strtotime($t));  

        //echo 'fguykgukgukg';

        //$inputlatitide = 10.0037024; // Device Location Lattitude   
        $inputlatitide = $_POST['lattitude'];   // Device Location Lattitude 
        //$inputlongitude = 76.2824009; // Device Location Longitude
        $inputlongitude = $_POST['longitude'];   // Device Location Lattitude 
        //$inputdate = date('Y/m/d'); // Selected Date   
        $inputdate = $_POST['inputdate']; // Selected Date    
        //$inputservice = 1;  // Selected Service  
        $inputservice = $_POST['serviceid']; // Selected Service
        //$inputsession = 1; // Selected Section Morning, Afternoon or Evening
        $inputsession = $_POST['session']; // Selected Section Morning, Afternoon or Evening
     
        //echo $inputlatitide.' '.$inputlongitude.' '.$inputdate.' '.$inputservice.' '.$inputsession;   
        //exit;
 

        $args = array(
            'role'    => 'Saloon Manager',
            'meta_key' => 'saloon_status', 
            'meta_value' => 2,
            'orderby' => 'user_registered',
            'order'   => 'DESC'
        );

        $users = get_users( $args );
        global $wpdb;
        $table_name = "saloon_service";
        $table_name1 = "saloon_closed_date";
        $results = $wpdb->get_results( "SELECT DISTINCT saloon_service.saloon_id FROM $table_name WHERE $table_name.service_id=$inputservice AND $table_name.saloon_id NOT IN(SELECT DISTINCT saloon_id FROM $table_name1 WHERE '$inputdate' between startdate and enddate)" );


       //echo $wpdb->last_query;
       //exit;

        $i = 0;

        if(count($results)>0) { 
            foreach($results as $user_id){
    
            $t = date("d-m-Y", strtotime($inputdate));
            $curday = date("D",strtotime($t)); 
            //echo $t;
            //echo $curday;
            //exit;

            $daystartcol = strtolower($curday).'_start';
            $dayendcol = strtolower($curday).'_end';

            $table_name1 = "saloon_service";
            $table_name = "services";
            $table_name2 = "gallery";
            $table_name3 = "saloon_working_days";

            $saloonid = $user_id->saloon_id;

            $chksaldet = $wpdb->get_results( "SELECT salwkgdys.*, GROUP_CONCAT(gal.image) as gallimg,serv.*, salserv.service_name FROM $table_name3 as salwkgdys 
                LEFT JOIN $table_name2 as gal 
                ON  salwkgdys.saloon_id = gal.saloon_id
                LEFT JOIN $table_name1 as serv 
                ON  salwkgdys.saloon_id = serv.saloon_id
                LEFT JOIN $table_name as salserv 
                ON  serv.service_id = salserv.id
                WHERE salwkgdys.saloon_id = $saloonid
                AND salwkgdys.$daystartcol <> '' 
                GROUP BY serv.id
                " );

             //echo $wpdb->last_query;
             //exit;

            if(count($chksaldet)>0) {

                $saloondat = get_user_meta ( $user_id->saloon_id);
                $userid = $user_id->saloon_id;
                $usrdet = get_userdata( $userid );

                $saladdress = $saloondat['address'][0].' '.$saloondat['city'][0];
                $salonname = $usrdet->display_name;
                $imageurl = get_site_url().'/wp-content/uploads/profile/'.$saloondat['profile_image'][0];

                $salcity = $saloondat['city'][0];
                $salzip = $saloondat['zip'][0];

                //$address = $salonname.' '.$saladdress.' '.$salcity.' '.$salzip;
                $address = $saladdress;
            
           
            /*$geocode_stats = file_get_contents("http://maps.googleapis.com/maps/api/geocode/json?latlng=".$inputlatitide.",".$inputlongitude."&sensor=false");
            $output_deals = json_decode($geocode_stats);

           
            $country = $output_deals->results[0]->address_components[5]->long_name;
            $countrycode = $output_deals->results[0]->address_components[5]->short_name;*/

         
            /*$address = str_replace(" ", "+", $address);

            $geocode = file_get_contents('http://maps.google.com/maps/api/geocode/json?address='.$address.'&sensor=false');

            $output= json_decode($geocode);

          
            $lattitude = $output->results[0]->geometry->location->lat;
            $longitude = $output->results[0]->geometry->location->lng;*/

            $lattitude = get_user_meta($userid, 'salon_lattitude', true);
            $longitude = get_user_meta($userid, 'salon_longitude', true);

           
              $theta = $inputlongitude - $longitude;
              $dist = sin(deg2rad($inputlatitide)) * sin(deg2rad($lattitude)) +  cos(deg2rad($inputlatitide)) * cos(deg2rad($lattitude)) * cos(deg2rad($theta));
              $dist = acos($dist);
              $dist = rad2deg($dist);
              $miles = $dist * 60 * 1.1515;
              //$unit = strtoupper($unit);
              $unit = 'K';

              if ($unit == "K") {
                $saldistance = $miles * 1.609344;
              } else if ($unit == "N") {
                  $saldistance = $miles * 0.8684;
                } else {
                    $saldistance = $miles;
                }

            //echo $saldistance;
            //exit;    

            // Distance Calculator Ends  


            // List Saloon within 5 KM  

            if($saldistance<=200) {        

                $posts[$i]['SaloonId'] = $userid;   
                $posts[$i]['SaloonName'] = $salonname; 
                $posts[$i]['SaloonImageURl'] = $imageurl; 
                $posts[$i]['SaloonAddress'] = $saladdress; 
                $posts[$i]['SaloonDistance'] = round($saldistance,2).' KM';  

            }
                $i++;        
            }
        }
        }

        $dist = array();
        foreach ($posts as $key => $row)
        {
            $dist[$key] = $row['SaloonDistance'];
        }
        array_multisort($dist, SORT_ASC, $posts);

    	return $posts;
    }

}

add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/getsaloonlist', array(
        'methods' => 'POST',
        'callback' => 'get_saloonlist',
    ));
});

function get_saloondetails() {

    //$inpsectok = 'b768a4ca09ae100bb10d7d5fa5b4ec68';    

    //$inpsectok = md5(date('Y-M-D').'beautueappsecuretoken');  

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';
    //echo $inptok;
    //exit;

    //$sectok = md5(uniqid(rand(), true));  
    $sectok = md5($inptok);    
    //echo $sectok;
    //exit;


    if($sectok==$inpsectok) {    

        // Input Parameters   

        //$saloonid = 1; // Saloon Id
        $saloonid = $_POST['saloonid']; // Saloon Id
        $totalservicetime = 30; // Total Service time in minute  
        $inputdate = $_POST['inputdate']; // Selected Date  
        //$totalservicetime = $_POST['totalservicetime']; // Total Service time in minute  
        //$session = 1; // Morning, Afternoon or Evening   
        $session = $_POST['session']; // Morning, Afternoon or Evening   

                $saloondat = get_user_meta ( $saloonid );
                $usrdet = get_userdata( $saloonid );

                //print_r($saloondat);
                //exit;
                 	
                $saladdress = $saloondat['address'][0].' '.$saloondat['city'][0];
                $salonname = $usrdet->display_name;
                $imageurl = get_site_url().'/wp-content/uploads/profile/'.$saloondat['profile_image'][0];
                $salcity = $saloondat['city'][0];
                $salzip = $saloondat['zip'][0];

                $salavailabltychk = $saloondat['available_for'][0];

                if($salavailabltychk==0) $availfor = 'Unisex';
                if($salavailabltychk==1) $availfor = 'Ladies';
                if($salavailabltychk==2) $availfor = 'Gents';


             //echo $inputdate;
             //exit;   

            //$t=date('d-m-Y');
            if(isset($inputdate)) $t=$inputdate;
            else $t=date('d-m-Y');     
            //$t=$inputdate;

            //echo $t;
            //exit;

            $curday = date("D",strtotime($t)); 

            //echo $curday;
            //exit;

            //if($curday=='Thu') $curday = 'Thr';

            //echo $curday;
            //exit;

            $daystartcol = strtolower($curday).'_start';
            $dayendcol = strtolower($curday).'_end';

            //echo $daystartcol.' '.$dayendcol;
            //exit;

            //echo $curday;
            //exit;

        global $wpdb;
        $table_name1 = "saloon_service";
        $table_name = "services";
        $table_name2 = "gallery";
        $table_name3 = "saloon_working_days";

        $results = $wpdb->get_results( "SELECT salwkgdys.*, GROUP_CONCAT(gal.image) as gallimg,serv.*, salserv.service_name FROM $table_name3 as salwkgdys 
            LEFT JOIN $table_name2 as gal 
            ON  salwkgdys.saloon_id = gal.saloon_id
            LEFT JOIN $table_name1 as serv 
            ON  salwkgdys.saloon_id = serv.saloon_id
            LEFT JOIN $table_name as salserv 
            ON  serv.service_id = salserv.id
            WHERE salwkgdys.saloon_id = $saloonid
            GROUP BY serv.id
            " );

        //echo $wpdb->last_query;
        //exit;

        $ser = 0;
        foreach($results as $resval) {
            $gallery = $resval->gallimg;

            //if($resval->service_id!=$_POST['services']) {
            
                $serviceslist[$ser]['ServicesList'] = $resval->service_name; 
                $serviceslist[$ser]['ServicesId'] = $resval->service_id;

                            $str_time = $resval->Duration;

                            $str_time = preg_replace("/^([\d]{1,2})\:([\d]{2})$/", "00:$1:$2", $str_time);

                            sscanf($str_time, "%d:%d:%d", $hours, $minutes, $seconds);

                            $time_hours = $hours + $minutes / 60 + $seconds / 3600;  

                                      $minstr_time = preg_replace("/^([\d]{1,2})\:([\d]{2})$/", "00:$1:$2", $str_time);

                                      sscanf($minstr_time, "%d:%d:%d", $hours, $minutes, $seconds);

                                      //$time_hours = $hours + $minutes / 60 + $seconds / 3600;
                                      $time_min = $hours * 60 + $minutes + $seconds / 60;

                            $ms = $time_hours * 3600000;


                            $hours = floor($time_min / 60);
                            $minutes = ($time_min % 60);
                            //echo $hours;
                            //exit;
                            if($hours>0) {
                                if($$minutes>0) {
                                    $format = '%02d hr %02d min';
                                    $tm = sprintf($format, $hours, $minutes);    
                                } else {
                                    $format = '%02d hr';
                                    $tm = sprintf($format, $hours);
                                }
                            } else  {
                                $format = '%02d min';
                                $tm = sprintf($format, $minutes);
                            }

                $serviceslist[$ser]['ServiceTime'] = $tm; 
                $serviceslist[$ser]['ServiceTimeMillisec'] = $ms; 

                $salstarttime = $resval->$daystartcol;
                $salendtime = $resval->$dayendcol;

                if($resval->service_id==$_POST['services']) {
                    $shftpos = $ser;
                }

                $ser++;

            //} 
            /*else {
                    $serviceslist[$ser]['ServicesList'] = $resval->service_name; 
                    $serviceslist[$ser]['ServicesId'] = $resval->service_id;

                            $str_time = $resval->Duration;

                            $str_time = preg_replace("/^([\d]{1,2})\:([\d]{2})$/", "00:$1:$2", $str_time);

                            sscanf($str_time, "%d:%d:%d", $hours, $minutes, $seconds);

                            $time_hours = $hours + $minutes / 60 + $seconds / 3600;  

                                      $minstr_time = preg_replace("/^([\d]{1,2})\:([\d]{2})$/", "00:$1:$2", $str_time);

                                      sscanf($minstr_time, "%d:%d:%d", $hours, $minutes, $seconds);

                                      //$time_hours = $hours + $minutes / 60 + $seconds / 3600;
                                      $time_min = $hours * 60 + $minutes + $seconds / 60;

                            $ms = $time_hours * 3600000;


                            $hours = floor($time_min / 60);
                            $minutes = ($time_min % 60);
                            //echo $hours;
                            //exit;
                            if($hours>0) {
                                if($$minutes>0) {
                                    $format = '%02d hr %02d min';
                                    $tm = sprintf($format, $hours, $minutes);    
                                } else {
                                    $format = '%02d hr';
                                    $tm = sprintf($format, $hours);
                                }
                            } else  {
                                $format = '%02d min';
                                $tm = sprintf($format, $minutes);
                            }

                $serviceslist[$ser]['ServiceTime'] = $tm; 
                $serviceslist[$ser]['ServiceTimeMillisec'] = $ms; 

                $salstarttime = $resval->$daystartcol;
                $salendtime = $resval->$dayendcol;
            }*/

            //$ser++;

        }
            //print_r($serviceslist);

            $b = array_slice($serviceslist,$shftpos);
            //print_r($b);
            $bb = array_slice($serviceslist,0,$shftpos);
            //print_r($bb);
            //$b += array_slice($serviceslist,0,$shftpos);
            $serviceslist = array_merge($b,$bb);
            //$serviceslist = $b;
       
        //$out = array_splice($serviceslist, $shftval, 1);
        //$serviceslist = array_splice($serviceslist, $shftval, 0, $out);

        
        //echo $salstarttime.' '.$salendtime;
        //exit;

        $galcount = explode(',',$gallery);

        //echo $gallery;
        //exit;
        //echo count($galcount);
        //exit;
        if($gallery!='') {
            for($j=0;$j<count($galcount);$j++) {
                $galimageurl = get_site_url().'/wp-content/uploads/gallery/'.$galcount[$j];
            	$galleryimg[$j]['Image'] = $galimageurl; 
            }   
        } 

        //$starttime = 10 * 60;
        //$endtime = 20 * 60;

        //echo $salendtime;
        //exit;

         if($session==1) {
            $starttime = strtotime($salstarttime);
            $endtime = strtotime("16:00");
        }

        if($session==2) {
            $starttime = strtotime("12:00");
            $endtime = strtotime($salendtime);
        }

        if($session==3)  {
            $starttime = strtotime("16:00");
            $endtime = strtotime($salendtime);
        }

        //$starttime = strtotime("10:00");
        //$endtime = strtotime("20:00");

        $datetime2 = $starttime;
        $datetime1 = $endtime;

        $interval  = abs($datetime2 - $datetime1);

        $minutes   = round($interval / 60);

        //echo $minutes.'<br>';

        //$totalservice = floor($minutes / $totalservicetime);
        $totalservice = floor($minutes / $totalservicetime);


        $tim = 0;

        for($chktime=$starttime;$chktime<$endtime;$chktime=strtotime($servicetime)) {


            $servicetime = date("H:i", strtotime('+'.$totalservicetime.' minutes', $starttime));

            $timestart = date("H:i", $starttime);

            
            $timelist[$tim]['timeslots'] = $timestart.'-'.$servicetime; 

            $starttime = date("H:i", strtotime('+30 minutes', $starttime));

            $starttime = strtotime($starttime);

            $tim++;
            
        }    

        for($i=0;$i<1;$i++) {

                $posts[$i]['Id'] = $saloonid;   
                $posts[$i]['Name'] = $salonname; 
                $posts[$i]['ImageURl'] = $imageurl; 
                $posts[$i]['Address'] = $saladdress; 
                $posts[$i]['AvailableFor'] = $availfor;
                $posts[$i]['Gallery'] = $galleryimg; 
                $posts[$i]['Services'] = $serviceslist;  
                $posts[$i]['TimeSlot'] = $timelist; 
    	}  

    	return $posts;
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/getsaloondetails', array(
        'methods' => 'POST',
        'callback' => 'get_saloondetails',
    ));
});




function get_servicelist() {


    //$inpsectok = 'b768a4ca09ae100bb10d7d5fa5b4ec68';    

    //$inpsectok = md5(date('Y-M-D').'beautueappsecuretoken');  

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';
    //echo $inptok;
    //exit;

    //$sectok = md5(uniqid(rand(), true));  
    $sectok = md5($inptok);    
    //echo $sectok;
    //exit;


    if($sectok==$inpsectok) {    

                    global $wpdb;

                    $table_name = "services";

                    $results = $wpdb->get_results( "SELECT * FROM $table_name" );
                    
                    //print_r($results);

                    $i=0;

                    if(count($results)>0) {

                        foreach($results as $values) {
                             $posts[$i]['Id'] = $values->id;   
                             $posts[$i]['Title'] = $values->service_name;

                             $i++; 
                        }
                    }

        

      return $posts;
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/getservicelist', array(
        'methods' => 'POST',
        'callback' => 'get_servicelist',
    ));
});

function get_customersignup() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);    

    if($sectok==$inpsectok) {  

        if(isset($_POST['id'])) {
                $id = $_POST['id'];
                //echo $id;
                //exit;
                $name = $_POST['name'];
                $username = preg_replace('/\s+/', '', strtolower($name));
                $imageurl = $_POST['imageurl'];
                $email = $_POST['email'];

                if (email_exists($email )) 
                {
                	$poststatus = 401;
                	$posts[0]['status'] = false;
                    $posts[0]['message'] = 'Email Already Exists';
                }
                else
                {
                    $user_query = get_users( array(
                                "meta_key" => "loginkey",
                                "meta_value" => $id,
                                "fields" => "ID"
                            ));

                $userid = $user_query[0];

                if ($userid) {
                	$poststatus = 401;
                	$posts[0]['status'] = false;
                    $posts[0]['message'] = 'Facebook Customer Already Registered';
                }
                else {
                    $password = $id;
                    $platform = 'fb';
                    $userdata = array(
                        'user_pass'  => $password,
                        'user_login' => $email,
                        'user_email' => $email,
                        'display_name' => $name,
                    );  
                    $user_id = wp_insert_user( $userdata );
                    $user = new WP_User($user_id);
                    $user->set_role('Customer');
                    if(isset($user_id))
                    {
                        add_user_meta( $user_id, 'loginplatform', $platform);
                        add_user_meta( $user_id, 'loginkey', $id);
                        add_user_meta( $user_id, 'saloon_status', 2);
                    }
                    $poststatus = 200;
                    $posts[0]['status'] = true;
                    $posts[0]['message'] = 'Facebook Customer Successfully Registered';
                }    
            }
        } 
        else {
                $name = $_POST['name'];
                $email = $_POST['email'];
                $password = $_POST['password'];
                $phone = $_POST['mobile'];
                $gender = $_POST['gender'];
                $DOB = $_POST['dob'];

                //echo $name.' '.$email.' '.$password.' '.$phone.' '.$gender.' '.$DOB;
                //echo email_exists( $email );
                //exit;

                if (email_exists($email )) 
                {
                    //echo "email already exists";
                    //exit;
                    $poststatus = 401;
                    $posts[0]['status'] = false;
                    $posts[0]['message'] = 'Email Already Exists';
                }
                else
                {
                    $userdata = array(
                        'user_pass'  => $password,
                        'user_login' => $email,
                        'user_email' => $email,
                        'display_name' => $name,
                    );  
                    $user_id = wp_insert_user( $userdata );
                    $user = new WP_User($user_id);
                    $user->set_role('Customer');
                    if(isset($user_id))
                    {
                        add_user_meta( $user_id, 'phone', $phone);
                        add_user_meta( $user_id, 'dob', $DOB);
                        add_user_meta( $user_id, 'gender', $gender);
                        add_user_meta( $user_id, 'saloon_status', 0);
                    }

                            $deviceid = $_POST['deviceid'];
                            $havemeta = get_user_meta($user_id, 'deviceid', true);
                            if(isset($havemeta)){
                                update_user_meta($userID, 'deviceid', $deviceid, $havemeta);
                            } else {
                                add_user_meta( $userID, 'deviceid', $deviceid);
                            }

                    //echo $user_id;
                    //exit;
                    //mail to check email validity
                     if ( $user_id && (!is_wp_error( $user_id )) ) 
                     {
                        $code = sha1( $user_id . time() );    
                        //echo $code;
                        //exit;
                        global $wpdb;    
                        $wpdb->update( 'wp_users',array('user_activation_key' => $code), array( 'ID' => $user_id ),array( '%s'));
                        $activation_link = add_query_arg( array( 'key' => $code, 'user' => $user_id ), get_permalink(65));
                        $body = 'Welcome to Beautue -'.' '. $name . "<br><br>";
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
                    //$login_url = get_permalink(35).'?message=true';
                    //$json_data = json_encode([ 'login_redirect' => $login_url, 'status' => 'true' ]);
                    //die($json_data);
                     $poststatus = 200;
                     $posts[0]['status'] = true;
                     $posts[0]['message'] = 'Email Activation Link Sent';
                } 
        }

      return new WP_REST_Response($posts,$poststatus);
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customersignup', array(
        'methods' => 'POST',
        'callback' => 'get_customersignup',
    ));
});

function get_customersignin() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) { 

        if(isset($_POST['id'])) {

                $id = $_POST['id'];
                //echo $id;
                //exit;
                $name = $_POST['name'];
                $username = preg_replace('/\s+/', '', strtolower($name));
                $imageurl = $_POST['profile_image'];
                $email = $_POST['email'];

                if (email_exists($email)) 
                {
                    //$user_query = get_user_meta( get_user_by_meta_data('loginkey', '$id')->ID, 'loginkey', true );;
                    $user_query = get_users( array(
                                    "meta_key" => "loginkey",
                                    "meta_value" => $id,
                                    "fields" => "ID"
                                ));

                    $userid = $user_query[0];

                    if ($userid) 
                    {
                            $deviceid = $_POST['deviceid'];
                            $userID = $userid;
                            $havemeta = get_user_meta($userID, 'deviceid', true);
                            //echo $havemeta;
                            //exit;
                            if(isset($havemeta)){
                                update_user_meta($userID, 'deviceid', $deviceid, $havemeta);
                            } else {
                                add_user_meta( $userID, 'deviceid', $deviceid);
                            }

                            $user_info = get_userdata($userID);


                            $user_info = get_userdata($userID);

                            $userimage = get_user_meta($userID, 'profile_image', true); 
                            if($userimage) {
                                $uploaddir = wp_upload_dir();
                                $target_dir = $uploaddir['baseurl'] . '/profile/';
                                $imgfulurl = $target_dir.$userimage;
                                //$image = file_get_contents($imageurl);
                                //file_put_contents($imgfulurl, $image); //Where to save the image on your server
                                //update_user_meta($userID, 'profile_image', $userimage, $userimage);

                            } else {
                                $imageurl = 'facebookimage';
                                $imgfulurl = $imageurl;
                                /*$uploaddir = wp_upload_dir();
                                $target_dir = $uploaddir['baseurl'] . '/profile/';
                                $userimage = 'user'.$userID.'.jpg';
                                $imgfulurl = $target_dir.$userimage;
                                $image = file_get_contents($imageurl);
                                file_put_contents($imgfulurl, $image); //Where to save the image on your server
                                add_user_meta( $userID, 'profile_image', $userimage);*/
                            }

                            $custdet = get_user_meta ( $userid );

                            $mobile = $custdet['phone'][0];
                            $gender = $custdet['gender'][0]; 
                            $dob = $custdet['dob'][0];

                            //$imageurl = 'facebookimage';


                    	$poststatus = 200;
                    	$posts[0]['status'] = true;
                        $posts[0]['message'] = 'Sucess';
                        $posts[0]['userid'] = $userid;
                        $posts[0]['name'] = $user_info->display_name;
                        $posts[0]['profimage'] = $imgfulurl;
                            $posts[0]['mobile'] = $mobile;
                            $posts[0]['gender'] = $gender;
                            $posts[0]['dob'] = $dob;

                    } else {

                    	$poststatus = 401;
                    	$posts[0]['status'] = false;
                        $posts[0]['message'] = 'User Already Registered';

                    }

                } else {
                    
                    $user_query = get_users( array(
                                "meta_key" => "loginkey",
                                "meta_value" => $id,
                                "fields" => "ID"
                            ));

                    $userid = $user_query[0];

                    if ($userid) {
                        $poststatus = 401;
                        $posts[0]['status'] = false;
                        $posts[0]['message'] = 'Facebook Customer Already Registered';
                    }
                    else {
                        $password = $id;
                        $platform = 'fb';
                        $userdata = array(
                            'user_pass'  => $password,
                            'user_login' => $email,
                            'user_email' => $email,
                            'display_name' => $name,
                        );  
                        $user_id = wp_insert_user( $userdata );
                        $user = new WP_User($user_id);
                        $user->set_role('Customer');
                        if(isset($user_id))
                        {
                            add_user_meta( $user_id, 'loginplatform', $platform);
                            add_user_meta( $user_id, 'loginkey', $id);
                            add_user_meta( $user_id, 'saloon_status', 2);
                        }


                            $custdet = get_user_meta ( $user_id );

                            $mobile = $custdet['phone'][0];
                            $gender = $custdet['gender'][0]; 
                            $dob = $custdet['dob'][0];

                            $imageurl = 'facebookimage';

                        $poststatus = 200;
                        $posts[0]['status'] = true;
                        $posts[0]['message'] = 'Sucess';
                        $posts[0]['userid'] = $user_id;
                        $posts[0]['name'] = $name;
                        $posts[0]['profimage'] = $imageurl;
                            $posts[0]['mobile'] = $mobile;
                            $posts[0]['gender'] = $gender;
                            $posts[0]['dob'] = $dob;

                        /*$poststatus = 200;
                        $posts[0]['status'] = true;
                        $posts[0]['message'] = 'Facebook Customer Successfully Sign In';*/
                    }        
                }
                
        }
        else {  

                $email = $_POST['email'];

                
                $email = strtolower(trim($_POST['email']));

                //echo $email;
                //exit;
                $user = get_user_by('email', $email);

                //echo $user;
                //exit;

                if($user) 
                {
                    $status = get_user_meta( $user->ID, 'saloon_status',true);    
                    if($status == 0)
                    {
                    	$poststatus = 401;
                    	$posts[0]['status'] = false;
                        $posts[0]['message'] = 'Please verify your Account';
                    }
                    else if($status == 2)
                    {
                        if (wp_check_password(trim($_POST['password']), $user->data->user_pass, $user->ID)) 
                        {
                            $deviceid = $_POST['deviceid'];
                            $userID = $user->ID;
                            $havemeta = get_user_meta($userID, 'deviceid', true);
                            //echo $havemeta;
                            //exit;
                            if(isset($havemeta)){
                                update_user_meta($userID, 'deviceid', $deviceid, $havemeta);
                            } else {
                                add_user_meta( $userID, 'deviceid', $deviceid);
                            }
                            
                            $user_info = get_userdata($userID);

                            $userimage = get_user_meta($userID, 'profile_image', true); 
                            if($userimage) {
                                $uploaddir = wp_upload_dir();
                                $target_dir = $uploaddir['baseurl'] . '/profile/';
                                $imgfulurl = $target_dir.$userimage;
                            }

                            $user_id =  $user->ID; 

                            $custdet = get_user_meta ( $user_id );

                            $mobile = $custdet['phone'][0];
                            $gender = $custdet['gender'][0]; 
                            $dob = $custdet['dob'][0];
        

                        	$poststatus = 200;
                        	$posts[0]['status'] = true;
                            $posts[0]['message'] = 'Sucess';
                            $posts[0]['userid'] = $user->ID;
                            $posts[0]['name'] = $user_info->display_name;
                            $posts[0]['profimage'] = $imgfulurl;
                            $posts[0]['mobile'] = $mobile;
                            $posts[0]['gender'] = $gender;
                            $posts[0]['dob'] = $dob;
                        } 
                        else 
                        {
                        	$poststatus = 401;
                        	$posts[0]['status'] = false;
                            $posts[0]['message'] = 'Password Incorrect';
                        } 
                    } 
                    else 
                    {
                    	$poststatus = 401;
                    	$posts[0]['status'] = false;
                        $posts[0]['message'] = 'Email Not Activated';
                    }
                } else {
                	$poststatus = 401;
                	$posts[0]['status'] = false;
                     $posts[0]['message'] = 'User Not Registered';
                }
        }

      //return $posts;
      return new WP_REST_Response($posts,$poststatus);

    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customersignin', array(
        'methods' => 'POST',
        'callback' => 'get_customersignin',
    ));
});

function get_customerforgotpasss() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {   

                $email = $_POST['email'];

                
                $email = strtolower(trim($_POST['email']));

                if(email_exists($email))
                {
                    $user = get_user_by('email', $email);
                    $status = get_user_meta( $user->ID, 'saloon_status',true); 
                    if($status == 0)
                    {
                    	$poststatus = 401;
                        $posts[0]['status'] = false;	
                        $posts[0]['message'] = 'Email not Verified';
                    }
                    else if($status == 2)
                    {
                       $code = sha1( $user->ID . time() );    
                       global $wpdb;    
                       $wpdb->update( 'wp_users',array('user_activation_key' => $code), array( 'ID' => $user->ID ),array( '%s'));
                       $activation_link = add_query_arg( array( 'key' => $code, 'user' => $user->ID ), get_permalink(48).'?cust=1');
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
                       $poststatus = 200;
                       $posts[0]['status'] = true;
                       $posts[0]['message'] = 'Email Sent';
                    } else {
                    	$poststatus = 401;
                        $posts[0]['status'] = false;	
                        $posts[0]['message'] = 'Email Does Not Exist';
                    }
                }
                else
                {
                	$poststatus = 401;
                	$posts[0]['status'] = false;
                    $posts[0]['message'] = 'Not Valid Email';
                }

        return new WP_REST_Response($posts,$poststatus);
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customerforgotpasss', array(
        'methods' => 'POST',
        'callback' => 'get_customerforgotpasss',
    ));
});

function get_customeredit() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {

            $user_id =  $_POST['userid']; 

            /*$imageurl = $_FILES['image']; 

            //print_r( $imageurl );
            //exit;

            $image = $imageurl['name'];

            $type1 = $imageurl['type'];

            $img = $imageurl['tmp_name'];

            $imgtemp = $imageurl['tmp_name'];

                 
               $uploaddir = wp_upload_dir();

               $temp = explode(".", $image);
            
                $newfilename = 'user'.$user_id.'.'.end($temp);

               $target_dir = $uploaddir['basedir'] . '/profile/';

               $target_file = $target_dir . $newfilename;

               //file_put_contents($uploaddir['basedir'] . '/profile/user' . $user_id.'.'.$type1, $img);

               move_uploaded_file($imgtemp, $target_file);

               //exit;

               $havemeta = get_user_meta($user_id, 'profile_image', true); 

               if($havemeta) {

                    update_user_meta( $user_id, 'profile_image', $newfilename);

               } else {

                    add_user_meta( $user_id, 'profile_image', $newfilename); 

                }*/

            $name = $_POST['name'];
            //$email = $_POST['email'];
            //$password = $_POST['password'];
            $phone = $_POST['mobile'];
            $gender = $_POST['gender'];
            $DOB = $_POST['dob'];

            //update_user_meta( $user_id, $meta_key, $meta_value, $prev_value );

            update_user_meta( $user_id, 'phone', $phone);
            update_user_meta( $user_id, 'dob', $DOB);
            update_user_meta( $user_id, 'gender', $gender);

            wp_update_user( array( 'ID' => $user_id, 'display_name'=> $name) );

            $poststatus = 200;
            $posts[0]['status'] = true;
            $posts[0]['message'] = 'Updated user Data';

        return $posts;
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customeredit', array(
        'methods' => 'POST',
        'callback' => 'get_customeredit',
    ));
});


function get_customerimageupload() {

    $inpsectok = md5($_POST['securitytoken']);
    //$inpsectok = md5(date('Y-M-D').'beautueappsecuretoken');

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {


            if($_POST['userid']!='') {

                $user_id =  $_POST['userid'];
                //$user_id =  55;

                //print_r($_FILES['image']);
                //exit;

                //return $_FILES['file'];

                //exit;

                if(isset($_FILES['file'])) {

                    header('Access-Control-Allow-Origin: *');

                    $imageurl = $_FILES['file']; 

                    $image = $imageurl['name'];

                    $type1 = $imageurl['type'];

                    $img = $imageurl['tmp_name'];

                    $imgtemp = $imageurl['tmp_name'];

                    $datetime = date('Y-m-d H:i:s');

                    $timestamp = strtotime($datetime);

                     
                   $uploaddir = wp_upload_dir();

                   $temp = explode(".", $image);
                
                    $newfilename = 'user'.$user_id.$timestamp.'.'.end($temp);

                   $target_dir = $uploaddir['basedir'] . '/profile/';

                   $target_file = $target_dir . $newfilename;

                   move_uploaded_file($imgtemp, $target_file);

                   /*$imageurl = $_POST['image'];

                   $imagesplit = explode( ',', $imageurl );

                   $image = $imagesplit[1];
                   
                   $pos  = strpos($imageurl, ';');
                   $type = explode(':', substr($imageurl, 0, $pos))[1];
                   $type1 = substr($type, strrpos($type, '/') + 1);
                   $uploaddir = wp_upload_dir();
                   $img = base64_decode(preg_replace('#^data:image/\w+;base64,#i', '', $imageurl));
                   file_put_contents($uploaddir['basedir'] . '/profile/user' . $user_id.'.'.$type1, $img);*/

                   /*$pos  = strpos($imageurl, ';');
                   $type = explode(':', substr($imageurl, 0, $pos))[1];
                   $type1 = substr($type, strrpos($type, '/') + 1);

                    $image_parts = explode(";base64,", $imageurl);
                    $image_type_aux = explode("image/", $image_parts[0]);
                    $image_type = $image_type_aux[1];
                    $image_base64 = base64_decode($image_parts[1]);

                    echo $image_base64;
                    exit;

                    $uploaddir = wp_upload_dir();

                    //$file = 'MyFsssssssssssile.jpg';
                    $file = $uploaddir['basedir'] . '/profile/user' . $user_id.'.'.$type1;
                    file_put_contents($file, $image_base64);*/

                   //$newfilename = 'user' . $user_id.'.'.$type1;

                   //echo $newfilename;
                   //exit;

                   $havemeta = get_user_meta($user_id, 'profile_image', true); 

                   if($havemeta) {

                        update_user_meta( $user_id, 'profile_image', $newfilename);

                   } else {

                        add_user_meta( $user_id, 'profile_image', $newfilename); 

                    }

                                $userimage = get_user_meta($user_id, 'profile_image', true); 
                                if($userimage) {
                                    $uploaddir = wp_upload_dir();
                                    $target_dir = $uploaddir['baseurl'] . '/profile/';
                                    $imgfulurl = $target_dir.$userimage;
                                }

                    $poststatus = 200;
                    $posts[0]['status'] = true;
                    $posts[0]['message'] = 'Updated user Image';
                    $posts[0]['profileimage'] = $imgfulurl;

                } else {
                    $poststatus = 404;
                    $posts[0]['status'] = false;
                }

            } else {
                $poststatus = 404;
                $posts[0]['status'] = false;
            }

         return new WP_REST_Response($posts,$poststatus);
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customerimageupload', array(
        'methods' => 'POST',
        'callback' => 'get_customerimageupload',
    ));
});

function get_customerdetails() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {

            $user_id =  $_POST['userid']; 

            $custdet = get_user_meta ( $user_id );
            $usrdet = get_userdata( $user_id );

            //print_r($custdet);

            $name = $usrdet->display_name;
            $email = $usrdet->user_email;

            $loginkey = get_user_meta( $user->ID, 'loginkey',true);  

            if($loginkey) {
                $mobile = '';
                $gender = '';
                $dob = '';
            }
            else {
                $mobile = $custdet['phone'][0];
                $gender = $custdet['gender'][0]; 
                $dob = $custdet['dob'][0];
            }

                $havemeta = get_user_meta($user_id, 'profile_image', true); 

                $uploaddir = wp_upload_dir();

                //print_r($uploaddir);
                //exit;

               $target_dir = $uploaddir['baseurl'] . '/profile/';

            //echo $mobile;
            //exit;

                            $userimage = get_user_meta($user_id, 'profile_image', true); 
                            if($userimage) {
                                $uploaddir = wp_upload_dir();
                                $target_dir = $uploaddir['baseurl'] . '/profile/';
                                $imgfulurl = $target_dir.$userimage;
                            }

            $posts[0]['name'] = $name;
            $posts[0]['email'] = $email;
            $posts[0]['mobile'] = $mobile;
            $posts[0]['gender'] = $gender;
            $posts[0]['dob'] = $dob;
            $posts[0]['profileimage'] = $imgfulurl;

        return $posts;
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customerdetails', array(
        'methods' => 'POST',
        'callback' => 'get_customerdetails',
    ));
});

function get_availabletimeslot() {

  $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {

            $services =  $_POST['services']; 
            $session =  $_POST['session']; 
            $date =  date('Y-m-d',strtotime($_POST['date'])); 
            $salonid =  $_POST['salonid']; 
            $servicestime =  $_POST['servicestime']; 

            global $wpdb;
            $tablename = 'saloon_staff';
            $tablename1 = 'staff_working_days';

            $tableworkingdays = 'saloon_working_days';
            //$tablecloseddate = 'saloon_closed_date';
            $curday =  date('D',strtotime($date));
            $daystartcol = strtolower($curday).'_start';
            $dayendcol = strtolower($curday).'_end';

            $salontime = $wpdb->get_results( "SELECT $daystartcol, $dayendcol FROM $tableworkingdays WHERE saloon_id = $salonid" );

            $salstarttime = $salontime[0]->$daystartcol;
            $salendtime = $salontime[0]->$dayendcol;

            //$arrayservices = explode(',', $services);

            $miliseconds = $servicestime;

            // echo $miliseconds;
            // exit;

            $seconds= $miliseconds/1000;
            //for seconds
            if($seconds> 0)
            {
                $sec= "" . ($seconds%60);
            if($seconds % 60 <10)
            {
                $sec= "0" . ($seconds%60);
            }
            }
            //for mins
            if($seconds > 60)
            {
                $mins= "". floor($seconds/60%60);
            if(($seconds/60%60)<10)
            {
                $mins= "0" . $mins;
            }
            }
            else
            {
                $mins= "00";
            }
            //for hours
            if($seconds/60 >= 60)
            {
                $hours= "". floor($seconds/60/60);
                if(($seconds/60/60) < 10)
                {
                    $hours= "0" . $hours;
                }
            }
            else
            {
                $hours= "00";
            }

            $servendtm = "" . $hours . ":" . $mins . ":" . $sec;
            // print_r($servendtm);
            // exit;
            $tim = 0;

            $icnt = 0;

            $tmminutes = $miliseconds / 60000;
            $totalservicetime = $tmminutes;

            $starttime = strtotime($salstarttime);
            $endtime = strtotime($salendtime);
            // print_r($starttime);
            // print_r($endtime);
            // exit;
            if($session==1) {
                $starttime = strtotime($salstarttime);
                if($endtime>strtotime("16:00")) {
                    $endtime = strtotime("16:00");
                }
            }

            if($session==2) {
                $starttime = strtotime("12:00");
                $endtime = strtotime($salendtime);
            }

            if($session==3)  {
                $starttime = strtotime("16:00");
                $endtime = strtotime($salendtime);
            }
            

            //echo $starttime.'='.$endtime.'===='.$totalservicetime;
            $satffquery = $wpdb->get_results( "SELECT staff_id FROM $tablename WHERE saloon_id = $salonid AND staff_id NOT IN(SELECT staff_id FROM $tablename1 WHERE currdate = '$date')" );
            if($satffquery)
            {
            for($chktime=$starttime;$chktime<$endtime;$chktime=strtotime($servicetime)) {

                $servicetime = date("H:i", strtotime('+'.$totalservicetime.' minutes', $starttime));

                $timestart = date("H:i", $starttime);
                $tmstart = date("H:i:s", $starttime);

                // echo $timestart;
                //exit;

                foreach($satffquery as $staff) {
                    $stfid = $staff->staff_id;
                    $tableorder = 'orders';
                    $timeendplus = date("H:i:s", strtotime('-1 seconds', strtotime($servicetime)));
                    $staffavailability = $wpdb->get_results( "SELECT * FROM $tableorder WHERE saloon_id = $salonid AND order_status = 1 AND staff_id = $stfid AND `date` = '$date' AND ('$tmstart' between start_time and end_time OR '$timeendplus' between start_time and end_time)" );
                    //echo  $wpdb->last_query;
                    //exit;  
                    
                    if(count($staffavailability)==0) {

                        if(!in_array($timestart, $tmchk)) {
                             $timelist[$tim]['timeslots'] = $timestart.'-'.$servicetime; 
                             $timelist[$tim]['staffid'] = $stfid; 
                             $tim++;
                         }

                         $tmchk[$icnt] = $timestart;

                        $icnt++;
                    }
                }

                // print_r($tmchk);
                // exit;
                
                //$timelist[$tim]['timeslots'] = $timestart.'-'.$servicetime; 

                $starttime = date("H:i", strtotime('+30 minutes', $starttime));

                $starttime = strtotime($starttime);
                
            }    
            
            $posts[0]['TimeSlot'] = $timelist;
            return $posts;
    }
    else
    {
        $poststatus = 401;
        $posts[0]['status'] = false;
        $posts[0]['message'] = 'No Staff Available';
        return $posts;
    }

    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/availabletimeslot', array(
        'methods' => 'POST',
        'callback' => 'get_availabletimeslot',
    ));
});

function get_customeraddappointment() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {

            $user_id =  $_POST['userid']; 
            $salonid =  $_POST['salonid']; 
            $bookdate =  date("Y-m-d",strtotime($_POST['date'])); 
            $services =  $_POST['services']; 
            $arrayservices = explode(',', $services);
            $serviceid = serialize($arrayservices);
            $ordernotes =  $_POST['order_notes']; 
            $starttime =  date("H:i:s",strtotime($_POST['starttime']));
            $duration =  $_POST['duration'];
            $endtime =  $_POST['endtime'];
            $timeendplus = date("H:i:s", strtotime('-1 seconds', strtotime($endtime)));
            // $staffid =  $_POST['staffid'];
            global $wpdb;
            $tableorder = 'orders';
            // $staffavail =array();
            $staffavail = $wpdb->get_results( "SELECT staff_id FROM saloon_staff WHERE saloon_id = $salonid",ARRAY_N);
            $staffavail_array = array();
            $final_array = array();
            foreach ($staffavail as $res){
                $staffavail_array[] = $res[0];
            }
            if(!empty($staffavail))
            {     
                // $availchk_result = $wpdb->get_results( "SELECT DISTINCT staff_id FROM $tableorder WHERE saloon_id = $salonid AND order_status = 1 AND staff_id IN ('" . implode("','", $staffavail_array) . "') AND `date` = '$bookdate' AND ('$starttime' between start_time and end_time OR '$timeendplus' between start_time and end_time)",ARRAY_N );      
                $availchk_result = $wpdb->get_results( "SELECT DISTINCT staff_id FROM $tableorder WHERE saloon_id = $salonid AND order_status = 1 AND staff_id IN ('" . implode("','", $staffavail_array) . "') AND `date` = '$bookdate' AND (start_time <='$starttime' and end_time >= '$timeendplus')",ARRAY_N );      
            }
            // else
            // {
            //     $poststatus = 404;
            //     $posts[0]['message'] = 'Sorry Staff not Yet Added';
            // }
            foreach ($availchk_result as $ress)
            {
                $final_array[] = $ress[0];
            }
            $result = array_diff($staffavail_array,$final_array);
            $stf_id = current($result);
            if(count($result) == 0) {
            	$poststatus = 404;
                $posts[0]['message'] = 'Sorry Staff not Available for the selected Time';
            } else {
               // print_r($availchk);
               // exit;
                $tablename = 'saloon_staff';
                $tablename1 = 'services';
                $staffname = $wpdb->get_results( "SELECT firstname, lastname from $tablename WHERE staff_id = $stf_id" );
                foreach($staffname as $stfn) {
                  $stafulname = $stfn->firstname.' '.$stfn->lastname;
                }
                foreach($arrayservices as $serval) {
                  $servicename = $wpdb->get_results( "SELECT service_name from $tablename1 WHERE id = $serval" );
                  foreach ($servicename as $serval) {
                      $totalservice .= $serval->service_name.', ';
                  }
                }

                $totalservice = rtrim($totalservice,', ');

               $saloondat = get_user_meta ( $salonid ); 
               $usrdet = get_userdata( $salonid ); 
               $saladdress = $saloondat['address'][0]; 
               $salonname = $usrdet->display_name; 
               $salcity = $saloondat['city'][0]; 
               $salzip = $saloondat['zip'][0]; 
               $saloonaddress = $salonname.' '.$saladdress.' '.$salcity.' '.$salzip; 

               $custdat = get_user_meta ( $user_id ); 
               $custdet = get_userdata( $user_id ); 
               $cutfname = $custdet->display_name; 
               $custemail = $custdet->user_email; 
               // print_r($bookdate);
               // exit;
               $insertorder = $wpdb->insert( $tableorder, array(
                          'saloon_id' => $salonid,
                          'service_id' => $serviceid,
                          'staff_id' => $stf_id,
                          'date' => $bookdate,
                          'customer_id' => $user_id,
                          'start_time' => $starttime,
                          'end_time' => $timeendplus,
                          'order_status' => 1,
                          'order_type' => 0,
                          'order_notes' => $ordernotes
                ));  
                $ordr_id = $wpdb->insert_id; 
              $insertnotification = $wpdb->insert( 'notification', array(
                          'order_id' => $ordr_id,
                          'notif_date' => date('Y-m-d'),
                          'admin_read' => 0,
                          'customer_read' => 0,
                          'current_status' => 1,
                          'web_appstatus' =>0
                      ));
                  if($insertorder >0) {
                        $email = WP_Mail::init()
                          ->to($custemail)
                          ->subject('Thanks for Booking')
                          ->template(get_template_directory() .'/template_parts/emailer.php', [
                              'name' => $cutname,
                              'When' => $bookdate.'|'.date('H:i',strtotime($starttime)).' to '.date('H:i',strtotime($endtime)),
                              'What' => $totalservice,
                              'Where'=> $saloonaddress,
                              'With'=>  $stafulname,
                          ])
                          ->send();


//echo $user_id;
//exit;

if(isset($user_id)) {
    $userID = $user_id;
} else {
    $userID = 0;
}

$havemeta = get_user_meta($userID, 'deviceid', true);
//echo $havemeta;
//exit;

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
        'body' => 'Thanks for booking your '.$totalservice.' appointments on '.$bookdate.' from '.$starttime.' to '.$endtime.' at '.$saloonaddress,
        'title' => 'Beautue Appointment Booking',
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

                                  
                        $poststatus = 200;  
                        $posts[0]['status'] = true;
                        $posts[0]['message'] = 'Successfully Booked';
                        $posts[0]['email'] = $custemail;
                  
                  }
            }

        return $posts;
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customeraddappointment', array(
        'methods' => 'POST',
        'callback' => 'get_customeraddappointment',
    ));
});


function get_customerappoinmentdetails() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {

            $user_id =  $_POST['userid']; 
            
            //echo $user_id;
            //exit;

            global $wpdb;

    $results = $wpdb->get_results(" 
	SELECT orders.id as appid, orders.saloon_id as salonid, notification.id as notifid, notification.customer_read as readstat,notification.current_status as currstat,orders.date as orderdate,orders.start_time as starttime,orders.end_time as endtime,orders.order_status as orderstat,orders.service_id as serviceid,orders.order_notes as ordernotes,saloon_staff.firstname as staffname,saloon_staff.lastname as staflname,wp_users.display_name as customername,wp_users.user_email as customeremail
    FROM orders
    JOIN notification
    ON notification.order_id = orders.id
    JOIN saloon_staff
    ON orders.staff_id = saloon_staff.staff_id
    JOIN wp_users
    ON orders.customer_id = wp_users.ID
    WHERE orders.customer_id = $user_id
    AND orders.order_type = 0 AND notification.web_appstatus = 0 ORDER BY notification.notif_date DESC");


            if(count($results)>0) {
            	$res = 0;
            	foreach ($results as $key => $value) {
            		//echo $value->appid.' '.$value->salonid.' ';
                    $salonid = $value->salonid;
            		$serviceid = $value->serviceid;
            		$arrayservices = unserialize($serviceid);

	                $tablename1 = 'services';
                    $totalservice ='';
	                foreach($arrayservices as $serval) {
	                  $servicename = $wpdb->get_results( "SELECT service_name from $tablename1 WHERE id = $serval" );
	                  foreach ($servicename as $servals) {
	                      $totalservice .= $servals->service_name.', ';
	                  }
	                }
                    // print_r($totalservice);
                    $cancelnotes = $wpdb->get_results( "SELECT reason from `reshdul_cancel_orders` WHERE order_id =".$value->appid );
                    // $totalservice = rtrim($totalservice,', ');
                    // print_r($totalservice);

	                   $saloondat = get_user_meta ( $salonid ); 
		               $usrdet = get_userdata( $salonid ); 
		               $saladdress = $saloondat['address'][0]; 
		               $salonname = $usrdet->display_name; 
		               $salcity = $saloondat['city'][0]; 
		               $salzip = $saloondat['zip'][0]; 
		               $saloonaddress = htmlspecialchars_decode($salonname).' '.$saladdress.' '.$salcity.' '.$salzip; 

		               $posts[$res]['appointmentid'] = $value->appid;
		               $posts[$res]['salonid'] = $value->salonid;
                       $posts[$res]['notifid'] = $value->notifid;
		               $posts[$res]['salonname'] = htmlspecialchars_decode($salonname);
		               $posts[$res]['salonaddress'] = $saloonaddress;
		               $posts[$res]['appointmentdate'] = $value->orderdate;
		               $posts[$res]['appointmentstarttime'] = date('H:i',strtotime($value->starttime));
		               $timeendplus = date("H:i:s", strtotime('+1 seconds', strtotime($value->endtime)));
		               $posts[$res]['appointmentendtime'] = date('H:i',strtotime($timeendplus));
                       $posts[$res]['services'] = rtrim($totalservice,', ');
		               $posts[$res]['appointmentnotes'] = $value->ordernotes;
                       $posts[$res]['read'] = $value->readstat;
                       if($cancelnotes[0]->reason)
                       {
                       $posts[$res]['cancellednotes'] = $cancelnotes[0]->reason;
                        }
                        else
                        {
                             $posts[$res]['cancellednotes'] = 'NULL';
                        }

		            $starttm = date('H:i',strtotime($value->starttime));

                    date_default_timezone_set('Asia/Kolkata');
                    $curt = date('Y-m-d H:i:s');
                    
                    $curttm = date('H:i',strtotime($curt));

                    //echo $curt.'|||'.$starttm.'===='.$curttm.'  ';
                     if($value->currstat==0)
                       {
                          $odrstat = 'Cancelled';
                       }
                       else if($value->currstat==1)
                       {
                          $odrstat = 'Booked';
                       } 
                       else
                       {
                            $odrstat = 'Rescheduled';
                       }
                       $posts[$res]['orderstatus'] = $odrstat;

                    if(date('d-m-Y',strtotime($value->orderdate)) < date('d-m-Y')) {
                      if($value->orderstat==1)
                       {
                          $appntstat = 'Completed';
                       }
                       else
                       {
                          $appntstat = 'Cancelled';
                       } 
                     } 
                        else {
                        if($value->orderstat==0)
                         {
                            $appntstat = 'Cancelled';
                         } else {
                            if($starttm<=$curttm) {
                              $appntstat = 'Completed';
                            }
                            else {
                              $appntstat = 'Opened';
                            }
                          }
                     }
		               
		               
		               $posts[$res]['appointmentstatus'] = $appntstat;


		               $res++;
                    }
            	
                    // print_r($posts);
                    // exit;
            	 $poststatus = 200;

            } else {
            	$poststatus = 404;
            	$posts[0]['status'] = false;
            	$posts[0]['message'] = 'Sorry No booking yet to display';
               
            }

        }

        return $posts;
    // }

}


    add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customerappoinmentdetails', array(
        'methods' => 'POST',
        'callback' => 'get_customerappoinmentdetails',
    ));
});

function get_customerappoinmenthistory() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {

            $user_id =  $_POST['userid']; 
    
            $curdate = date('Y-m-d');

            global $wpdb;

            $results = $wpdb->get_results(" 
    SELECT orders.id as appid, orders.saloon_id as salonid,orders.date as orderdate,orders.start_time as starttime,orders.end_time as endtime,orders.order_status as orderstat,orders.service_id as serviceid,orders.order_notes as ordernotes,saloon_staff.firstname as staffname,saloon_staff.lastname as staflname,wp_users.display_name as customername,wp_users.user_email as customeremail
    FROM   orders
    JOIN wp_users
    ON orders.customer_id = wp_users.ID
    JOIN saloon_staff
    ON orders.staff_id = saloon_staff.staff_id
    JOIN reshdul_cancel_orders
    ON orders.id = reshdul_cancel_orders.order_id
    WHERE orders.customer_id = $user_id
    AND orders.order_type = 0 AND (orders.date<'$curdate' OR orders.order_status = 0) ORDER BY orders.date DESC, reshdul_cancel_orders.cancel_reschedule_date DESC");

            // echo $wpdb->last_query;
            // exit;

         
            if(count($results)>0) {
                $res = 0;
                foreach ($results as $key => $value) {
                    //echo $value->appid.' '.$value->salonid.' ';
                    $salonid = $value->salonid;
                    $serviceid = $value->serviceid;
                    $arrayservices = unserialize($serviceid);

                    $tablename1 = 'services';

                    foreach($arrayservices as $serval) {
                      $servicename = $wpdb->get_results( "SELECT service_name from $tablename1 WHERE id = $serval" );
                      foreach ($servicename as $serval) {
                          $totalservice .= $serval->service_name.', ';
                      }
                    }
                    $totalservice = rtrim($totalservice,', ');


                       $saloondat = get_user_meta ( $salonid ); 
                       $usrdet = get_userdata( $salonid ); 
                       $saladdress = $saloondat['address'][0]; 
                       $salonname = $usrdet->display_name; 
                       $salcity = $saloondat['city'][0]; 
                       $salzip = $saloondat['zip'][0]; 
                       $saloonaddress = htmlspecialchars_decode($salonname).' '.$saladdress.' '.$salcity.' '.$salzip; 

                       $posts[$res]['appointmentid'] = $value->appid;
                       $posts[$res]['salonid'] = $value->salonid;
                       $posts[$res]['salonname'] = htmlspecialchars_decode($salonname);
                       $posts[$res]['salonaddress'] = $saloonaddress;
                       $posts[$res]['appointmentdate'] = $value->orderdate;
                       $posts[$res]['appointmentstarttime'] = date('H:i',strtotime($value->starttime));
                       $timeendplus = date("H:i:s", strtotime('+1 seconds', strtotime($value->endtime)));
                       $posts[$res]['appointmentendtime'] = date('H:i',strtotime($timeendplus));
                       $posts[$res]['appointmentnotes'] = $value->ordernotes;

                    $starttm = date('H:i',strtotime($value->starttime));

                    date_default_timezone_set('Asia/Kolkata');
                    $curt = date('Y-m-d H:i:s');
                    
                    $curttm = date('H:i',strtotime($curt));

                    //echo $curt.'|||'.$starttm.'===='.$curttm.'  ';

                    if(date('d-m-Y',strtotime($value->orderdate)) < date('d-m-Y')) {
                      if($value->orderstat==1)
                       {
                          $odrstat = 'Completed';
                       }
                       else
                       {
                          $odrstat = 'Cancelled';
                       } 
                     } else {
                        if($value->orderstat==0)
                         {
                            $odrstat = 'Cancelled';
                         } else {
                            if($starttm<=$curttm) {
                              $odrstat = 'Completed';
                            }
                            else {
                              $odrstat = 'Opened';
                            }
                          }
                     }
                       
                       
                       $posts[$res]['appointmentstatus'] = $odrstat;


                       $res++;

                }

                 $poststatus = 200;

            } else {
                $poststatus = 404;
                $posts[0]['status'] = false;
                $posts[0]['message'] = 'Sorry No booking yet to display';
               
            }

        return $posts;
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customerappoinmenthistory', array(
        'methods' => 'POST',
        'callback' => 'get_customerappoinmenthistory',
    ));
});

function get_customerupcomingappoinment() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {

            $user_id =  $_POST['userid']; 

            $curdate = date('Y-m-d');

                    date_default_timezone_set('Asia/Kolkata');
                    $curt = date('Y-m-d H:i:s');
                    
                    $curttm = date('H:i:s',strtotime($curt));
            
            //echo $curdate;
            //exit;

            global $wpdb;

            $results = $wpdb->get_results(" 
	SELECT orders.id as appid, orders.saloon_id as salonid,orders.date as orderdate,orders.start_time as starttime,orders.end_time as endtime,orders.order_status as orderstat,orders.service_id as serviceid,orders.order_notes as ordernotes,saloon_staff.firstname as staffname,saloon_staff.lastname as staflname,wp_users.display_name as customername,wp_users.user_email as customeremail
    FROM   orders
    JOIN wp_users
    ON orders.customer_id = wp_users.ID
    JOIN saloon_staff
    ON orders.staff_id = saloon_staff.staff_id
    WHERE orders.customer_id = $user_id
    AND orders.order_type = 0 AND orders.order_status = 1 AND orders.date >= '$curdate' ORDER BY orders.date DESC,orders.start_time ASC
   ");

            // echo $wpdb->last_query;
            // exit;

         
            if(count($results)>0) {
            	$res = 0;
            	foreach ($results as $key => $value) {
            		//echo $value->starttime;
            		//echo '----'.$curttm;	
            		//exit;	

            		
	            		//echo $value->appid.' '.$value->salonid.' ';
	            		$salonid = $value->salonid;
	            		$serviceid = $value->serviceid;
	            		$arrayservices = unserialize($serviceid);

		                $tablename1 = 'services';

		                foreach($arrayservices as $serval) {
		                  $servicename = $wpdb->get_results( "SELECT service_name from $tablename1 WHERE id = $serval" );
		                  foreach ($servicename as $serval) {
		                      $totalservice .= $serval->service_name.', ';
		                  }
		                }
		                $totalservice = rtrim($totalservice,', ');


		                   $saloondat = get_user_meta ( $salonid ); 
			               $usrdet = get_userdata( $salonid ); 
			               $saladdress = $saloondat['address'][0]; 
			               $salonname = $usrdet->display_name; 
			               $salcity = $saloondat['city'][0]; 
			               $salzip = $saloondat['zip'][0]; 
			               $saloonaddress = htmlspecialchars_decode($salonname).' '.$saladdress.' '.$salcity.' '.$salzip; 

			               $posts[$res]['appointmentid'] = $value->appid;
			               $posts[$res]['salonid'] = $value->salonid;
			               $posts[$res]['salonname'] = htmlspecialchars_decode($salonname);
			               $posts[$res]['salonaddress'] = $saloonaddress;
			               $posts[$res]['appointmentdate'] = $value->orderdate;
			               $posts[$res]['appointmentstarttime'] = date('H:i',strtotime($value->starttime));
			               $timeendplus = date("H:i:s", strtotime('+1 seconds', strtotime($value->endtime)));
			               $posts[$res]['appointmentendtime'] = date('H:i',strtotime($timeendplus));
			               $posts[$res]['appointmentnotes'] = $value->ordernotes;

			            $starttm = date('H:i',strtotime($value->starttime));

	                    date_default_timezone_set('Asia/Kolkata');
	                    $curt = date('Y-m-d H:i:s');
	                    
	                    $curttm = date('H:i',strtotime($curt));

	                    //echo $curt.'|||'.$starttm.'===='.$curttm.'  ';

	                    if(date('d-m-Y',strtotime($value->orderdate)) < date('d-m-Y')) {
	                      if($value->orderstat==1)
	                       {
	                          $odrstat = 'Completed';
	                       }
	                       else
	                       {
	                          $odrstat = 'Cancelled';
	                       } 
	                     } else {
	                        if($value->orderstat==0)
	                         {
	                            $odrstat = 'Cancelled';
	                         } else {
                                 if(date('d-m-Y',strtotime($value->orderdate)) == date('d-m-Y')) {   
    	                            if($starttm<=$curttm) {
    	                              $odrstat = 'Completed';
    	                            }
    	                            else {
    	                              $odrstat = 'Opened';
    	                            }
    	                          }
                                  else {
                                    $odrstat = 'Opened';
                                  }
                              }
	                     }
			               
			               
			               $posts[$res]['appointmentstatus'] = $odrstat;

			               $res++;
			        
            	}

            	 $poststatus = 200;

            } else {
            	$poststatus = 404;
            	$posts[0]['status'] = false;
            	$posts[0]['message'] = 'Sorry No booking yet to display';
               
            }

        return $posts;
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customerupcomingappoinment', array(
        'methods' => 'POST',
        'callback' => 'get_customerupcomingappoinment',
    ));
});


function get_customerappoinmentdelete() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {

            $appointmentid =  $_POST['appointmentid']; 

            $customernotes =  $_POST['customernotes']; 

            global $wpdb;
			   $updates = $wpdb->update('orders', array('order_status' => 0), array('id' => $appointmentid));  
			   $wpdb->insert( 'reshdul_cancel_orders', array('order_id' => $appointmentid, 'reason' => $customernotes,'orderstat'=>2),array('%d','%s' ,'%d'));
			   $cancelnotification = $wpdb->insert( 'notification', array(
                          'order_id' => $appointmentid,
                          'notif_date' => date('Y-m-d'),
                          'admin_read' => 0,
                          'customer_read' => 0,
                          'current_status' => 0,
                          'web_appstatus' =>0
                      ));
			   $emaildet=$wpdb->get_results( "SELECT service_id,date,start_time,customer_id,saloon_id,order_type FROM orders WHERE id = ".$appointmentid);   
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
			   $service_name ='';
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
			            $body .= 'We Apologize for inconvenience caused to you.' . "<br><br>";
			            $body .= 'Regards,' . "<br>";
			            $body .= 'Beautue Team' . "<br>";
			            $headers = array('Content-Type: text/html; charset=UTF-8');
			            $to = $custemail;
			            $subject = 'Beautue Appointment Cancellation';
			            $sent = wp_mail($to, $subject, $body, $headers);


if(isset($_POST['customerid'])) {
    $userID = $_POST['customerid'];
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
        'body' => $saloondet->display_name.' has cancelled your '.$service_names.'appointments on ' .date('l, d-m-Y',strtotime($emaildet[0]->date)) .' at '. date('H.i',strtotime($emaildet[0]->start_time)),
        'title' => 'Beautue Appointment Cancellation',
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
			  
			  	$poststatus = 200;
            	$posts[0]['status'] = true;
            	$posts[0]['message'] = 'Appointment Cancelled';

        return $posts;
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customerappoinmentdelete', array(
        'methods' => 'POST',
        'callback' => 'get_customerappoinmentdelete',
    ));
});

function get_customerreadstatus() {

    $inpsectok = md5($_POST['securitytoken']);

    $inptok = date('Y-M-D').'beautueappsecuretoken';

    $sectok = md5($inptok);   

    if($sectok==$inpsectok) {

            $notifid =  $_POST['notifid']; 

            global $wpdb;

               $updates = $wpdb->update('notification', array('customer_read' => 1), array('id' => $notifid));  

                $poststatus = 200;
                $posts[0]['status'] = true;
                $posts[0]['message'] = 'Appointment Read by Customer';

        return $posts;
    }

}


add_action( 'rest_api_init', function () {
        register_rest_route( 'myroutes', '/customerreadstatus', array(
        'methods' => 'POST',
        'callback' => 'get_customerreadstatus',
    ));
});


?>