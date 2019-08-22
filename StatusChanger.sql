#create table wp_users_as_backup as select * from wp_users;
#create table wp_usermeta_as_backup as select * from wp_usermeta; 

#DROP INdex idxCp1 on Copy_wp_posts_Order ;
#CREATE INDEX  idxCp1 on Copy_wp_posts_Order (post_type);

#DROP INdex idxCp2 on Copy_wp_posts_Order ;
#CREATE INDEX idxCp2 on Copyignore_wp_posts_Order (ID);

#DROP INdex idxCpM1 on Copy_wp_postmeta_Order ;
#CREATE INDEX idxCpM1 on Copy_wp_postmeta_Order (post_id);

#DROP INdex idxCpM2 on Copy_wp_postmeta_Order ;
#CREATE INDEX idxCpM2 on Copy_wp_postmeta_Order (meta_key);

#DROP INdex idxCpM3 on Copy_wp_postmeta_Order ;
#CREATE INDEX idxCpM3 on Copy_wp_postmeta_Order (meta_value);

#DROP INdex idxC1 on cancelledemaillist ;
#CREATE INDEX idxC1 on cancelledemaillist (ID);

#DROP INdex idxC2 on cancelledemaillist ;
#CREATE INDEX idxC2 on cancelledemaillist (useremail);
#DROP INdex idxCU1 on Copy_wp_users ;
#CREATE INDEX idxCU1 on Copy_wp_users (user_email);
 
 drop table if exists statusTracker;
 CREATE Table statusTracker 
 SELECT  Ce.useremail ,  cwpO.ID as OrderID,Cwu.ID as userID, post_status as oldstatus, 'wc-cancelled' as newstatus  
 FROM Copy_wp_posts_Order cwpO INNER JOIN   Copy_wp_postmeta_Order  cwpmO on cwpO.ID=cwpmO.post_id
 INNER JOIN temp_wp_users Cwu on  cwpmO.meta_value = Cwu.ID 
 inner join cancelledemaillist  Ce on Ce.useremail = Cwu.user_email
 where post_type='shop_subscription'  and meta_key='_customer_user'  and post_status <>'wc-cancelled' ;
 
 
#select * from statusTracker;
 
 #DROP INDEX idxst1 on statusTracker;
 CREATE INDEX idxst1 on statusTracker (OrderID);
UPDATE  Copy_wp_posts_Order cwpO INNER JOIN   statusTracker   st on cwpO.ID=st.OrderID
  SET  post_status ='wc-cancelled' where newstatus='wc-cancelled';
  
  
insert ignore  into wp_comments (comment_post_ID, comment_author, comment_author_email, comment_author_url, comment_author_IP, comment_date, 
comment_date_gmt, comment_content, comment_karma, comment_approved, comment_agent, comment_type, comment_parent, user_id) 
SELECT  OrderID, 'WooCommerce', 'woocommerce@angelshaveclub.com', '','', now(), now(), 
concat('Order status changed by Virtina from ',oldstatus, ' to Cancelled.'), 0, 1, 'WooCommerce', 'order_note', 0 , 0  from statusTracker
 where newstatus='wc-cancelled';
  
UPDATE   temp_wp_usermeta wu   inner join statusTracker st
on wu.user_id = st.userID 
set meta_value='a:1:{s:8:"customer";b:1;}'
where meta_key = 'wp_capabilities' 
and   newstatus='wc-cancelled';

 #DROP index idxo1 on onholdtoactive;
 CREATE Index idxo1 on onholdtoactive(useremail);
 INSERT ignore Into statusTracker ( useremail ,   OrderID,userID, oldstatus, newstatus  )
  SELECT  Ce.useremail ,  cwpO.ID as OrderID,Cwu.ID as userID, post_status as oldstatus, 'wc-active' as newstatus  
 FROM Copy_wp_posts_Order cwpO INNER JOIN   Copy_wp_postmeta_Order  cwpmO on cwpO.ID=cwpmO.post_id
 INNER JOIN temp_wp_users Cwu on  cwpmO.meta_value = Cwu.ID 
 inner join onholdtoactive  Ce on Ce.useremail = Cwu.user_email
 where post_type='shop_subscription'  and meta_key='_customer_user'  and cwpO.post_status ='wc-on-hold' ;
 
 UPDATE  Copy_wp_posts_Order cwpO INNER JOIN   statusTracker   st on cwpO.ID=st.OrderID
  SET  post_status ='wc-active' where newstatus='wc-active';
 
 insert ignore  into wp_comments (comment_post_ID, comment_author, comment_author_email, comment_author_url, comment_author_IP, comment_date, 
comment_date_gmt, comment_content, comment_karma, comment_approved, comment_agent, comment_type, comment_parent, user_id) 
SELECT  OrderID, 'WooCommerce', 'woocommerce@angelshaveclub.com', '','', now(), now(), 
concat('Order status changed by Virtina from ',oldstatus, ' to Active.'), 0, 1, 'WooCommerce', 'order_note', 0 , 0  from statusTracker
 where newstatus='wc-active';
 
 
UPDATE   temp_wp_usermeta wu   inner join statusTracker st
on wu.user_id = st.userID 
set meta_value='a:1:{s:10:"subscriber";b:1;}'
where meta_key = 'wp_capabilities' 
and   newstatus='wc-active';


 



