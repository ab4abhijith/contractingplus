#DROP INdex idxCp1 on wp_posts ;
#CREATE INDEX  idxCp1 on wp_posts (post_type);

#DROP INdex idxCp2 on wp_posts ;
#CREATE INDEX idxCp2 on wp_posts (ID);

#DROP INdex idxCpM1 on wp_postmeta ;
#CREATE INDEX idxCpM1 on wp_postmeta (post_id);

#DROP INdex idxCpM2 on wp_postmeta ;
#CREATE INDEX idxCpM2 on wp_postmeta (meta_key);

#DROP INdex idxCpM3 on wp_postmeta ;
#CREATE INDEX idxCpM3 on wp_postmeta (meta_value);

#DROP INdex idxC1 on cancelledemaillist ;
#CREATE INDEX idxC1 on cancelledemaillist (ID);

#DROP INdex idxC2 on cancelledemaillist ;
#CREATE INDEX idxC2 on cancelledemaillist (useremail);
#DROP INdex idxCU1 on Copy_wp_users ;
#CREATE INDEX idxCU1 on Copy_wp_users (user_email);
 
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


#update wp_posts set post_status = concat(post_status,'-onhold') where ID in (select ID from specialonholdaction);


 #DROP index idxo1 on onholdtoactive;
 CREATE Index idxo10 on onholdtoactive(useremail);
 alter table wp_posts add index (ID);
  alter table wp_postmeta add index (post_id);
  alter table wp_users add index (ID);
  alter table wp_users add index (user_email);
  show index from wp_users;
  show index from onholdtoactive;
  alter table wp_users drop index ID;
  alter table wp_users drop index user_email_2;
  alter table onholdtoactive drop index idxo1;
  
  drop table if exists activestatustrackerpostpostmeta;
  create table activestatustrackerpostpostmeta as SELECT cwpO.ID as OrderID, cwpmO.meta_value, post_status as oldstatus, 'wc-active' as newstatus 
FROM wp_posts cwpO INNER JOIN wp_postmeta cwpmO on cwpO.ID=cwpmO.post_id
 where post_type='shop_subscription' and meta_key='_customer_user'; 

DROP TABLE IF EXISTS ActivestatusTracker;
create table ActivestatusTracker as 
select distinct Ce.useremail , OrderID, Cwu.ID as userID, oldstatus, newstatus from  activestatustrackerpostpostmeta as cwpmO
INNER JOIN wp_users Cwu on cwpmO.meta_value = Cwu.ID 
inner join onholdtoactive Ce on Ce.useremail = Cwu.user_email;
 
 /*
DROP TABLE IF EXISTS ActivestatusTracker;
CREATE Table ActivestatusTracker
As 
SELECT distinct Ce.useremail , cwpO.ID as OrderID,Cwu.ID as userID, post_status as oldstatus, 'wc-active' as newstatus 
FROM wp_posts cwpO INNER JOIN wp_postmeta cwpmO on cwpO.ID=cwpmO.post_id
INNER JOIN wp_users Cwu on cwpmO.meta_value = Cwu.ID 
inner join onholdtoactive Ce on Ce.useremail = Cwu.user_email
where post_type='shop_subscription' and meta_key='_customer_user' and cwpO.post_status ='wc-on-hold' ;
 */
 
 UPDATE  wp_posts cwpO INNER JOIN   ActivestatusTracker   st on cwpO.ID=st.OrderID
  SET  post_status ='wc-active';
 
 insert ignore  into wp_comments (comment_post_ID, comment_author, comment_author_email, comment_author_url, comment_author_IP, comment_date, 
comment_date_gmt, comment_content, comment_karma, comment_approved, comment_agent, comment_type, comment_parent, user_id) 
SELECT  OrderID, 'WooCommerce', 'woocommerce@angelshaveclub.com', '','', now(), now(), 
concat('Order status changed by Virtina from ',oldstatus, ' to Active.'), 0, 1, 'WooCommerce', 'order_note', 0 , 0  from ActivestatusTracker
 where newstatus='wc-active';
 
 
UPDATE   wp_usermeta wu   inner join ActivestatusTracker st
on wu.user_id = st.userID 
set meta_value='a:1:{s:10:"subscriber";b:1;}'
where meta_key = 'wp_capabilities';


/*

create table finalbackuppost as select * from wp_posts;
create table finalbackuppostmeta as select * from wp_posts;
create table finalbackupuser as select * from wp_users;
create table finalbackupusermeta as select * from wp_usermeta;

*/
 
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



# Active

drop table if exists orderesactivated;
create table orderesactivated as 
select ID, post_status, concat('{"subscription_id":',ID,'}') as post_content from wp_posts where ID in (select OrderID from ActivestatusTracker);

select * from orderesactivated;

ALTER TABLE orderesactivated MODIFY
    post_content VARCHAR(50)
      CHARACTER SET utf8
      COLLATE utf8_unicode_ci;

create table orderesactivatedschedule as
select wp.* from wp_posts as wp inner join orderesactivated as sp on sp.post_content = wp.post_content 
where wp.post_type='scheduled-action';

alter table orderesactivatedschedule add index (ID);

update wp_posts set post_status = 'pending' where ID in (select ID from orderesactivatedschedule);

update wp_postmeta as p inner join orderesactivatedschedule as o on o.ID = p.post_id
set meta_value = 
concat('O:30:"ActionScheduler_SimpleSchedule":1:{s:41:"ActionScheduler_SimpleScheduletimestamp";s:10:"',unix_timestamp(DATE_ADD(Now(), INTERVAL 3 day)),'";}')
where p.meta_key = '_action_manager_schedule';

UPDATE ActivestatusTracker S inner join  wp_postmeta  W on W.post_id= S.OrderID
set meta_value=0 Where meta_key='_schedule_end';