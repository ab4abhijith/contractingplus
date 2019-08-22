#USE kappamap_angelshaveNew_April04;

SET SQL_SAFE_UPDATES = 0;
SET SESSION group_concat_max_len = 5000000;
DROP PROCEDURE IF EXISTS GetAllSubscriptions;
DELIMITER //
CREATE PROCEDURE GetAllSubscriptions()
 BEGIN
 
 DECLARE tmpSQL VARCHAR(65535);
DECLARE bigSQL VARCHAR(65535);


SET tmpSQL='';

DROP TABLE IF EXISTS newsubscriptiontable;

SELECT 
    GROUP_CONCAT(DISTINCT concat ('MAX(CASE WHEN pm1.meta_key =''' ,meta_key,''' then pm1.meta_value ELSE NULL END) as ', meta_key)
        ORDER BY Post_type ASC
        SEPARATOR ',') into tmpSQL
FROM wp_posts p inner join wp_postmeta pm1 ON ( pm1.post_id = p.ID) 
 WHERE post_type='shop_subscription' AND (meta_key = '_customer_user' or 
meta_key = '_billing_period' or 
meta_key = '_billing_interval' or 
meta_key = '_schedule_next_payment' or 
meta_key = '_paid_date' or 
meta_key = '_completed_date' or 
meta_key = '_order_total' or
meta_key = '_schedule_start' or
meta_key = '_schedule_trial_end');
 
SET @bigSQL='';
SET @bigSQL = concat('CREATE TABLE newsubscriptiontable as SELECT p.ID as postid, p.post_date as purchasedate, ', REPLACE( tmpSQL,'-','_'),
 ' FROM wp_posts p LEFT JOIN   wp_postmeta pm1 ON ( pm1.post_id = p.ID)',  ' WHERE p.post_type in(''shop_subscription'')
    GROUP BY postid;'); 
  
PREPARE stmt1 FROM @bigSQL; 
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1; 

select * from newsubscriptiontable;

DROP TABLE IF EXISTS newusertable;

SELECT 
    GROUP_CONCAT(DISTINCT concat ('MAX(CASE WHEN usrmt.meta_key =''' ,meta_key,''' then usrmt.meta_value ELSE NULL END) as ', meta_key)
        ORDER BY ID ASC
        SEPARATOR ',') into tmpSQL
FROM wp_users u inner join wp_usermeta usrmt ON ( usrmt.user_id = u.ID) 
 WHERE (meta_key = 'first_name' or 
meta_key = 'last_name' or 
meta_key = 'nickname' or 
meta_key = 'billing_first_name' or 
meta_key = 'billing_last_name' or 
meta_key = 'billing_address_1' or
meta_key = 'billing_email' or 
meta_key = 'billing_phone' or 
meta_key = 'billing_postcode' or
meta_key = 'billing_city' or
meta_key = 'billing_state' or
meta_key = 'billing_country' or
meta_key = 'shipping_first_name' or 
meta_key = 'shipping_last_name' or 
meta_key = 'shipping_address_1' or
meta_key = 'shipping_city' or 
meta_key = 'shipping_state' or 
meta_key = 'shipping_phone' or 
meta_key = 'shipping_country' or 
meta_key = 'wp_capabilities');
 
SET @bigSQL='';
SET @bigSQL = concat('CREATE TABLE newusertable as SELECT u.ID as userid, u.user_email as useremail, ', REPLACE( tmpSQL,'-','_'), ' FROM wp_users u 
LEFT JOIN   wp_usermeta usrmt ON ( usrmt.user_id = u.ID)',  'WHERE u.ID in (select _customer_user from newsubscriptiontable) GROUP BY ID;'); 
  
PREPARE stmt1 FROM @bigSQL; 
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1; 

select * from newusertable;

alter table newusertable add index(userid);

drop table if exists comusersubscribe;

create table comusersubscribe as select newusertable.*, newsubscriptiontable.* from newusertable 
    inner join newsubscriptiontable on newusertable.userid = newsubscriptiontable._customer_user group by newsubscriptiontable._customer_user;

select * from comusersubscribe;




    END //
 DELIMITER ;
 
 
CALL GetAllSubscriptions(); 
SET SQL_SAFE_UPDATES = 1;