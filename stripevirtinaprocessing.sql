SET SQL_SAFE_UPDATES = 0;

#Commenting the Stripe Process For the time being

#select * from wp_posts;
#select * from wp_postmeta;

#create table combackuppost as select * from wp_posts; 
#create table combackuppostmeta as select * from wp_postmeta; 
#create table combackuporderitems as select * from wp_woocommerce_order_items;
#create table combackuporderitemmeta as select * from wp_woocommerce_order_itemmeta;
#create table combackupusermeta as select * from wp_usermeta;

#create table combackuppost_new as select * from wp_posts; 
#create table combackuppostmeta_new as select * from wp_postmeta; 
#create table combackuporderitems_new as select * from wp_woocommerce_order_items;
#create table combackuporderitemmeta_new as select * from wp_woocommerce_order_itemmeta;
#create table combackupusermeta_new as select * from wp_usermeta;

#select * from poststoinsertwithidupdate;

#delete from wp_posts where ID in (select newID from poststoinsertwithidupdate);

#delete from wp_postmeta where post_id in (select newID from poststoinsertwithidupdate);

#select * from striperenewal;

select wp.post_id as postorder, wp.meta_value as parentsub from wp_postmeta as wp inner join striperenewal as sr on sr.orderid = wp.meta_value 
where wp.meta_key = '_subscription_renewal' order by sr.orderid;

drop table if exists striperenewalchildhighest;

create table striperenewalchildhighest as select max(wp.post_id) as childorder, wp.meta_value as parentorder from wp_postmeta as wp inner join striperenewal as sr on sr.orderid = wp.meta_value 
where wp.meta_key = '_subscription_renewal' group by sr.orderid;

#select * from striperenewalchildhighest;

#select * from striperenewal;

drop table if exists striperenewalwithchild;
create table striperenewalwithchild as select str.*, srh.childorder from striperenewalchildhighest as srh inner join striperenewal as str on str.orderid = srh.parentorder;

#select * from striperenewalwithchild;

SET @tmpNewStripeID=0;
SELECT  max(ID) from wp_posts into @tmpNewStripeID ;

#select @tmpNewStripeID + striprenewalid from striperenewal;
drop table if exists stripetalepost;
 CREATE TABLE `stripetalepost` (
 `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
 `post_author` bigint(20) unsigned NOT NULL DEFAULT '0',
 `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `post_content` longtext COLLATE utf8mb4_unicode_520_ci NOT NULL,
 `post_title` text COLLATE utf8mb4_unicode_520_ci NOT NULL,
 `post_excerpt` text COLLATE utf8mb4_unicode_520_ci NOT NULL,
 `post_status` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'publish',
 `comment_status` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'open',
 `ping_status` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'open',
 `post_password` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
 `post_name` varchar(200) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
 `to_ping` text COLLATE utf8mb4_unicode_520_ci NOT NULL,
 `pinged` text COLLATE utf8mb4_unicode_520_ci NOT NULL,
 `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
 `post_content_filtered` longtext COLLATE utf8mb4_unicode_520_ci NOT NULL,
 `post_parent` bigint(20) unsigned NOT NULL DEFAULT '0',
 `guid` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
 `menu_order` int(11) NOT NULL DEFAULT '0',
 `post_type` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'post',
 `post_mime_type` varchar(100) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
 `comment_count` bigint(20) NOT NULL DEFAULT '0',
 PRIMARY KEY (`ID`),
 KEY `post_name` (`post_name`(191)),
 KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
 KEY `post_parent` (`post_parent`),
 KEY `post_author` (`post_author`)
);

insert into stripetalepost 
select @tmpNewStripeID + striprenewalid,1, TIMESTAMP('2019-03-05 10:00:00'), TIMESTAMP('2019-03-05 10:00:00'), '', 
'Order &ndash; Mar 05, 2019 @ 06:31 PM', '', 
CASE 
WHEN stripestatus ='succeeded' Then 'wc-completed'
WHEN stripestatus ='failure' Then 'wc-failed'
END as post_status, 'open', 'closed', concat('order_',DATE_FORMAT(now(), '%H%i%s')), concat('order-mar-05-',
DATE_FORMAT(now(), '%m-%d-%Y-%H-%i-%s')), '','', now(), now(), '', 0, 
concat('https://www.angelshaveclub.com/?post_type=shop_order&#038;p=', @tmpNewStripeID + striprenewalid ), 
0, 'shop_order', '', '' from striperenewalwithchild;

alter table striperenewalwithchild add column nepostid int;

update striperenewalwithchild set nepostid = @tmpNewStripeID + striprenewalid;

select * from striperenewalwithchild;

SET @tmpmetaNewStripeID=0;
SELECT  max(meta_id) from wp_postmeta into @tmpmetaNewStripeID;

drop table if exists stripetalepostmeta;
CREATE TABLE `stripetalepostmeta` (
 `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
 `post_id` bigint(20) unsigned NOT NULL DEFAULT '0',
 `meta_key` varchar(255) COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
 `meta_value` longtext COLLATE utf8mb4_unicode_520_ci,
 PRIMARY KEY (`meta_id`),
 KEY `post_id` (`post_id`),
 KEY `meta_key` (`meta_key`(191))
); 

drop table if exists tempstripepostmeta;
create table tempstripepostmeta as select * from wp_postmeta where post_id in (select childorder from striperenewalwithchild);

alter table tempstripepostmeta add index(post_id);
alter table striperenewal add index(childorder);
alter table striperenewal add index(nepostid);

#select * from tempstripepostmeta;

update tempstripepostmeta as tsp inner join striperenewalwithchild as str on str.childorder = tsp.post_id
set tsp.post_id = str.nepostid;

#select * from tempstripepostmeta;

insert into stripetalepostmeta ( post_id, meta_key, meta_value) select post_id, meta_key, meta_value from tempstripepostmeta;

#select * from stripetalepostmeta;

update stripetalepostmeta set meta_id =  @tmpmetaNewStripeID + meta_id;

#update stripetalepostmeta set _schedule_next_payment =  '2019-03-05' + _billing_interval;

#select stp.meta_value, stp1.meta_value, DATE_ADD('2019-03-05 10:00:0', INTERVAL stp1.meta_value MONTH) from stripetalepostmeta as stp 
#inner join striperenewal as str on str.nepostid = stp.post_id
#inner join stripetalepostmeta as stp1 on stp1.post_id = str.nepostid 
#where stp.meta_key = '_schedule_next_payment' and stp1.meta_key = '_billing_interval'; 

update stripetalepostmeta as stp inner join striperenewal as str on str.nepostid = stp.post_id
inner join stripetalepostmeta as stp1 on stp1.post_id = str.nepostid 
set stp.meta_value = DATE_ADD('2019-03-05 10:00:00', INTERVAL stp1.meta_value MONTH)
where stp.meta_key = '_schedule_next_payment' and stp1.meta_key = '_billing_interval'; 

update stripetalepostmeta set meta_value = '2019-03-05 10:00:00' where meta_key = '_completed_date';

update stripetalepostmeta set meta_value = '2019-03-05 10:00:00' where meta_key = '_paid_date';

update stripetalepostmeta set meta_value = concat('wc_order_',DATE_FORMAT(now(), '%H%i%s')) where meta_key = '_order_key';

#select * from stripetalepostmeta;





#select * from striperenewal;

SET @tmporderitemNewStripeID=0;
SELECT  max(order_item_id) from wp_woocommerce_order_items into @tmporderitemNewStripeID;

drop table if exists stripeorderiteminsert;
create table stripeorderiteminsert as select * from wp_woocommerce_order_items where order_id in (select childorder from striperenewalwithchild);

alter table stripeorderiteminsert add index(order_item_id);

update stripeorderiteminsert as tsp inner join striperenewalwithchild as str on str.childorder = tsp.order_id
set tsp.order_id = str.nepostid;

drop table if exists temporderitems;
CREATE TABLE `temporderitems` (
  `order_item_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_item_name` longtext COLLATE utf8_unicode_ci NOT NULL,
  `order_item_type` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `order_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`)
);

insert into temporderitems (order_item_name, order_item_type, order_id) select order_item_name, order_item_type, order_id from stripeorderiteminsert;

update temporderitems set order_item_id =  @tmporderitemNewStripeID + order_item_id;



# orderitemmeta

SET @tmporderitemmetaNewStripeID=0;
SELECT  max(meta_id) from wp_woocommerce_order_itemmeta into @tmporderitemmetaNewStripeID;

drop table if exists oldstripeorederitem;
create table oldstripeorederitem as select * from wp_woocommerce_order_items where order_id in (select childorder from striperenewalwithchild); 

drop table if exists stripeorderitemmetainsert;
create table stripeorderitemmetainsert as select * from wp_woocommerce_order_itemmeta where order_item_id in (select order_item_id from oldstripeorederitem);

alter table stripeorderitemmetainsert add index(order_item_id);

alter table oldstripeorederitem add column neworderid int;

update oldstripeorederitem as tsp inner join striperenewalwithchild as str on str.childorder = tsp.order_id
set tsp.neworderid = str.nepostid;

alter table oldstripeorederitem add column neworderitemid int;

update oldstripeorederitem as tsp inner join temporderitems as str on str.order_id = tsp.neworderid and str.order_item_name = tsp.order_item_name
set tsp.neworderitemid = str.order_item_id;

update stripeorderitemmetainsert as st inner join oldstripeorederitem as os on os.order_item_id = st.order_item_id
set st.order_item_id = os.neworderitemid;

#select * from temporderitems;
#select * from stripeorderitemmetainsert;

drop table if exists tempstripeitemmeta;
CREATE TABLE `tempstripeitemmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_item_id` bigint(20) unsigned NOT NULL,
  `meta_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `meta_value` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`meta_id`),
  KEY `order_item_id` (`order_item_id`),
  KEY `meta_key` (`meta_key`)
);

insert into tempstripeitemmeta (order_item_id, meta_key, meta_value) select order_item_id, meta_key, meta_value from stripeorderitemmetainsert;

update tempstripeitemmeta set meta_id =  @tmporderitemmetaNewStripeID + meta_id;

#select * from tempstripeitemmeta;

#select * from wp_posts;
#select * from stripetalepost;
#select * from wp_postmeta;
#select * from stripetalepostmeta;
#select * from wp_woocommerce_order_items;
#select * from temporderitems;
#select * from wp_woocommerce_order_itemmeta;
#select * from tempstripeitemmeta;

insert into wp_posts select stripetalepost.* from stripetalepost;

insert into wp_postmeta select stripetalepostmeta.* from stripetalepostmeta;

insert into wp_woocommerce_order_items select temporderitems.* from temporderitems;

insert into wp_woocommerce_order_itemmeta select tempstripeitemmeta.* from tempstripeitemmeta;


drop table if exists stripecomments;
CREATE TABLE `stripecomments` (
  `comment_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_post_ID` bigint(20) unsigned NOT NULL DEFAULT '0',
  `comment_author` tinytext COLLATE utf8_unicode_ci NOT NULL,
  `comment_author_email` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text COLLATE utf8_unicode_ci NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT '0',
  `comment_approved` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `comment_type` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `comment_parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`comment_ID`),
  KEY `comment_post_ID` (`comment_post_ID`),
  KEY `comment_approved_date_gmt` (`comment_approved`,`comment_date_gmt`),
  KEY `comment_date_gmt` (`comment_date_gmt`),
  KEY `comment_parent` (`comment_parent`),
  KEY `comment_author_email` (`comment_author_email`(10)),
  KEY `woo_idx_comment_type` (`comment_type`)
);

#select * from striperenewalwithchild;

insert into stripecomments (comment_post_ID, comment_author, comment_author_email, comment_author_url, comment_author_IP, 
comment_date, comment_date_gmt, comment_content, comment_karma, comment_approved, comment_agent, comment_type, comment_parent, 
user_id) select nepostid, 'Woocommerce', 'woocommerce@angelshaveclub.com', '', '', 
'2019-03-05 10:00:00', '2019-03-05 10:00:00', 
CASE 
WHEN stripestatus ='succeeded' Then 'Status changed from Pending to Active.'
WHEN stripestatus ='failure' Then 'Payment failed.'
END as comment_content, 0, 1, 'WooCommerce', 'order_note', 0, 0 from striperenewalwithchild;

SET @tmpCommentStripeID=0;
SELECT  max(comment_ID) from wp_comments into @tmpCommentStripeID ;

update stripecomments set comment_ID =  @tmpCommentStripeID + comment_ID;

#select * from stripecomments;

insert into wp_comments select stripecomments.* from stripecomments;




#select * from wp_comments where comment_post_ID in  (select orderid from striperenewal);

/*
select * from wp_posts where post_status = 'special-on-hold';

select * from wp_postmeta where post_id  = 2320;

select * from wp_posts where post_content = '{"subscription_id":2320}';

select unix_timestamp(DATE_ADD(Now(), INTERVAL 2 day));

select * from wp_postmeta where post_id  in (6853, 167807);

select FROM_UNIXTIME(1555273029);
*/

update wp_posts set post_status = 'wc-active' where post_status = 'special-on-hold';

drop table if exists stripeorderesactivated;
create table stripeorderesactivated as 
select ID, post_status, concat('{"subscription_id":',ID,'}') as post_content from wp_posts where ID in (select orderid from striperenewalwithchild);

#select * from stripeorderesactivated;

ALTER TABLE stripeorderesactivated MODIFY
    post_content VARCHAR(50)
      CHARACTER SET utf8
      COLLATE utf8_unicode_ci;

drop table if exists stripeorderesactivatedschedule;
create table stripeorderesactivatedschedule as
select wp.* from wp_posts as wp inner join stripeorderesactivated as sp on sp.post_content = wp.post_content 
where wp.post_type='scheduled-action';

alter table stripeorderesactivatedschedule add index (ID);

#select * from stripeorderesactivatedschedule;

update wp_posts set post_status = 'pending' where ID in (select ID from stripeorderesactivatedschedule);

update wp_postmeta as p inner join stripeorderesactivatedschedule as o on o.ID = p.post_id
set meta_value = 
concat('O:30:"ActionScheduler_SimpleSchedule":1:{s:41:"ActionScheduler_SimpleScheduletimestamp";s:10:"',unix_timestamp(DATE_ADD(Now(), INTERVAL 2 day)),'";}')
where p.meta_key = '_action_manager_schedule';


UPDATE striperenewalwithchild S inner join  wp_postmeta  W on W.post_id= S.orderid
set meta_value=0 Where meta_key='_schedule_end';

update wp_usermeta WU INNER JOIN wp_postmeta WM on WU.user_id= WM.meta_value 
 INNER JOIN specialonhold OH on WM.post_id= OH.ID
 SET  WU.meta_value = 'a:1:{s:10:"subscriber";b:1;}'
 WHERE WM.meta_key='_customer_user' AND WU.meta_key= 'wp_capabilities';
 



#select * from striperenewalwithchild;


# Uncomment Below Data to Change Stripe processed orders to Special On Hold

/*


select * from striperenewal;

#delete from wp_posts where ID in (select nepostid from striperenewal);
#delete from wp_postmeta where post_id in (select nepostid from striperenewal);

alter table striperenewal add index (orderid);

drop table if exists specialonhold;
create table specialonhold as select ID, post_status, concat('{"subscription_id":',ID,'}') as post_content from wp_posts where ID in (select orderid from striperenewal);
#select * from specialonhold;

update wp_posts set post_status = 'special-on-hold' where ID in (select ID from specialonhold) and post_type = 'shop_subscription';

ALTER TABLE specialonhold MODIFY
    post_content VARCHAR(50)
      CHARACTER SET utf8
      COLLATE utf8_unicode_ci;

drop table if exists specialonholdaction;

create table specialonholdaction as
select wp.* from wp_posts as wp inner join specialonhold as sp on sp.post_content = wp.post_content 
where wp.post_type='scheduled-action';

update wp_posts set post_status = concat(post_status,'-onhold') where ID in (select ID from specialonholdaction);

#select distinct meta_value from wp_postmeta where post_id in (select ID from specialonhold) and meta_key='_customer_user';


#select meta_value from wp_usermeta where user_id in (
#select distinct meta_value from wp_postmeta where post_id in (select ID from specialonhold) and meta_key='_customer_user'
#) and meta_key= 'wp_capabilities';

#select  WU.meta_value, 'a:1:{s:8:"customer";b:1;}'  from
# wp_usermeta WU INNER JOIN wp_postmeta WM on WU.user_id= WM.meta_value 
# INNER JOIN specialonhold OH on WM.post_id= OH.ID
# WHERE WM.meta_key='_customer_user' AND WU.meta_key= 'wp_capabilities';

#create table wp_usermeta_backup_full as select * from wp_usermeta;

alter table specialonhold add index(ID);
alter table wp_postmeta add index(post_id);

#update wp_usermeta set meta_value = 'a:1:{s:8:"customer";b:1;}' where user_id in (
#select distinct meta_value from wp_postmeta where post_id in (select ID from specialonhold) and meta_key='_customer_user'
#) and meta_key= 'wp_capabilities';

update wp_usermeta WU INNER JOIN wp_postmeta WM on WU.user_id= WM.meta_value 
 INNER JOIN specialonhold OH on WM.post_id= OH.ID
 SET  WU.meta_value = 'a:1:{s:8:"customer";b:1;}'
 WHERE WM.meta_key='_customer_user' AND WU.meta_key= 'wp_capabilities';


#select * from wp_postmeta where meta_value = '28555' and meta_key = '_customer_user';

#select * from wp_users where user_email = 'rowe266@msn.com';

#select * from wp_posts where ID in ( select post_id from wp_postmeta where meta_value = '28555' and meta_key = '_customer_user' );


*/
