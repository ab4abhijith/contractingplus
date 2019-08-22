drop table if exists statusTracker;
 CREATE Table statusTracker 
 SELECT  Ce.useremail ,  cwpO.ID as OrderID,Cwu.ID as userID, post_status as oldstatus, 'wc-cancelled' as newstatus  
 FROM wp_posts cwpO INNER JOIN   wp_postmeta  cwpmO on cwpO.ID=cwpmO.post_id
 INNER JOIN wp_users Cwu on  cwpmO.meta_value = Cwu.ID 
 inner join cancelledemaillist  Ce on Ce.useremail = Cwu.user_email
 where post_type='shop_subscription'  and meta_key='_customer_user'  and post_status <>'wc-cancelled' ;
 
 
 #DROP INDEX idxst1 on statusTracker;
 CREATE INDEX idxst1 on statusTracker (OrderID);
UPDATE  wp_posts cwpO INNER JOIN   statusTracker   st on cwpO.ID=st.OrderID
  SET  post_status ='wc-cancelled' where newstatus='wc-cancelled';
  
insert ignore  into wp_comments (comment_post_ID, comment_author, comment_author_email, comment_author_url, comment_author_IP, comment_date, 
comment_date_gmt, comment_content, comment_karma, comment_approved, comment_agent, comment_type, comment_parent, user_id) 
SELECT  OrderID, 'WooCommerce', 'woocommerce@angelshaveclub.com', '','', now(), now(), 
concat('Order status changed by Virtina from ',oldstatus, ' to Cancelled.'), 0, 1, 'WooCommerce', 'order_note', 0 , 0  from statusTracker
 where newstatus='wc-cancelled';
  
UPDATE   wp_usermeta wu   inner join statusTracker st
on wu.user_id = st.userID 
set meta_value='a:1:{s:8:"customer";b:1;}'
where meta_key = 'wp_capabilities' 
and   newstatus='wc-cancelled';

# Cancelled users
 
ALTER TABLE statusTracker add column processed int;
UPDATE statusTracker set processed=0;

UPDATE statusTracker S inner join  wp_postmeta  W on W.post_id= S.orderID
set S.processed=1, meta_value=DATE_ADD(Now(), INTERVAL -1 day)
Where meta_key='_schedule_end' and  meta_value=0;

drop table if exists orderescancelled;
create table orderescancelled as 
select ID, post_status, concat('{"subscription_id":',ID,'}') as post_content from wp_posts where ID in (select OrderID from statusTracker);

ALTER TABLE orderescancelled MODIFY
    post_content VARCHAR(50)
      CHARACTER SET utf8
      COLLATE utf8_unicode_ci;

create table orderescancelledschedule as
select wp.* from wp_posts as wp inner join orderescancelled as sp on sp.post_content = wp.post_content 
where wp.post_type='scheduled-action';

drop table if exists delcancelledsub;
create table delcancelledsub as select * from wp_posts where ID in (select ID from orderescancelledschedule);

delete from wp_posts where ID in (select ID from delcancelledsub);