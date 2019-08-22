#USE kappamap_angelshaveNew_April05;

SET SQL_SAFE_UPDATES = 0;
SET SESSION group_concat_max_len = 5000000;
DROP PROCEDURE IF EXISTS GetAllSubscriptions;
DELIMITER //
CREATE PROCEDURE GetAllSubscriptions()
 BEGIN
 
 DECLARE tmpSQL VARCHAR(65535);
DECLARE bigSQL VARCHAR(65535);

#CREATE INDEX idxCopy_wp_posts_Order on Copy_wp_posts_Order (ID);
#CREATE INDEX idxCopy_wp_postsMeta_Order on Copy_wp_postmeta_Order (post_id);
#CREATE INDEX idxCopy_wp_posts_Order1 on Copy_wp_posts_Order (post_type);
#CREATE INDEX idxCopy_wp_posts_Order2 on Copy_wp_postmeta_Order (meta_key);
#CREATE INDEX idxCopy_wp_usermeta_Userid on Copy_wp_usermeta (user_id);
#CREATE INDEX idxCopy_wp_users_ID on Copy_wp_users (ID);

SET tmpSQL='';

#select * from wp_posts inner join wp_postmeta where wp_posts.ID = wp_postmeta.post_id and wp_posts.post_type='shop_subscription';

DROP TABLE IF EXISTS comsubscriptiontable;
/*
ALTER TABLE Copy_wp_posts_Order drop index idxCopy_wp_posts_Order;
ALTER TABLE Copy_wp_postmeta_Order drop index idxCopy_wp_postmeta_Order;
ALTER TABLE Copy_wp_posts_Order drop index idxCopy_wp_postType;
*/
CREATE INDEX idxCopy_wp_posts_Order on  Copy_wp_posts_Order(ID);
CREATE INDEX idxCopy_wp_postmeta_Order on  Copy_wp_postmeta_Order(post_id);
CREATE INDEX idxCopy_wp_postType  on  Copy_wp_posts_Order(post_type);


SELECT 
    GROUP_CONCAT(DISTINCT concat ('MAX(CASE WHEN pm1.meta_key =''' ,meta_key,''' then pm1.meta_value ELSE NULL END) as ', meta_key)
        ORDER BY Post_type ASC
        SEPARATOR ',') into tmpSQL
FROM Copy_wp_posts_Order p inner join Copy_wp_postmeta_Order pm1 ON ( pm1.post_id = p.ID) 
 WHERE (post_type='shop_subscription' or post_type='shop_order') AND (meta_key = '_customer_user' or 
meta_key = '_billing_period' or 
meta_key = '_billing_interval' or 
meta_key = '_schedule_next_payment' or 
meta_key = '_paid_date' or 
meta_key = '_completed_date' or 
meta_key = '_order_total' or
meta_key = '_schedule_start' or
meta_key = '_schedule_trial_end');

#select * from wp_posts where ID < 10;
 
SET @bigSQL='';
SET @bigSQL = concat('CREATE TABLE comsubscriptiontable as SELECT p.ID as postid, p.post_date as purchasedate, p.post_type as posttype, ', REPLACE( tmpSQL,'-','_'),
 ' FROM Copy_wp_posts_Order p LEFT JOIN   Copy_wp_postmeta_Order pm1 ON ( pm1.post_id = p.ID)',  ' WHERE p.post_type = ''shop_subscription'' GROUP BY postid;'); 
  
PREPARE stmt1 FROM @bigSQL; 
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1; 

DROP TABLE IF EXISTS comusertable;

SELECT 
    GROUP_CONCAT(DISTINCT concat ('MAX(CASE WHEN usrmt.meta_key =''' ,meta_key,''' then usrmt.meta_value ELSE NULL END) as ', meta_key)
        ORDER BY ID ASC
        SEPARATOR ',') into tmpSQL
FROM Copy_wp_users u inner join Copy_wp_usermeta usrmt ON ( usrmt.user_id = u.ID) 
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
/*
SET @bigSQL = concat('CREATE TABLE comusertable as SELECT u.ID as userid, u.user_email as useremail, ', REPLACE( tmpSQL,'-','_'), ' FROM Copy_wp_users u 
LEFT JOIN   Copy_wp_usermeta usrmt ON ( usrmt.user_id = u.ID)',  'WHERE u.ID in (select _customer_user from comsubscriptiontable) GROUP BY ID;'); 
  */
  
  #Create index idx1 on comsubscriptiontable (_customer_user);
SET @bigSQL = concat('CREATE TABLE comusertable as SELECT u.ID as userid, u.user_email as useremail, ', REPLACE( tmpSQL,'-','_'), ' FROM Copy_wp_users u 
LEFT JOIN   Copy_wp_usermeta usrmt ON ( usrmt.user_id = u.ID)',  ' INNER JOIN   comsubscriptiontable C  on u.ID = C._customer_user GROUP BY ID;'); 
PREPARE stmt1 FROM @bigSQL; 
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1; 

select * from comusertable;

select count(*) from Copy_wp_users;

#select * from comsubscriptiontable;

#alter table comsubscriptiontable add index (_customer_user varchar(100));
#ALTER TABLE comusertable ADD INDEX (userid);
#ALTER TABLE comsubscriptiontable ADD INDEX (_customer_user);


#select * from kappamap_angelshaveNew_March26.usersubcomlist where userid = 5;

    END //
 DELIMITER ;
 
 
CALL GetAllSubscriptions(); 
SET SQL_SAFE_UPDATES = 1;