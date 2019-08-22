/*
select * from temp_wp_usermeta as usrm inner join temp_wp_users as usr
on usr.ID = usrm.user_id where usrm.meta_key = 'wp_capabilities' and meta_value = 'a:1:{s:10:"subscriber";b:1;}';

select * from wp_usermeta as usrm inner join wp_users as usr
on usr.ID = usrm.user_id where usrm.meta_key = 'wp_capabilities' and meta_value = 'a:1:{s:10:"subscriber";b:1;}';
*/
#select * from kappamap_angelshaveOld_March17.wp_posts where post_status = 'wc-active' and post_type = 'shop_subscription';

create table usershopsubscription as 
select * from wp_posts where post_status = 'wc-active' and post_type = 'shop_subscription';

create table usershopmeta as 
select * from wp_usermeta as usrm inner join wp_users as usr
on usr.ID = usrm.user_id where usrm.meta_key = 'wp_capabilities' and meta_value = 'a:1:{s:10:"subscriber";b:1;}';

select * from usershopsubscription;
select * from usershopmeta;

alter table usershopsubscription add index (ID);
alter table usershopmeta add index (ID);

drop table if exists compuserlistwithorder;

create table compuserlistwithorder as
select user_email, wpu.ID as userid, wp.post_id as orderid, us.post_date as postdate from usershopsubscription as us inner join wp_postmeta as wp on wp.post_id = us.ID 
inner join usershopmeta as wpu on wpu.ID = wp.meta_value where wp.meta_key = '_customer_user';

select * from compuserlistwithorder;

drop table if exists userduplicatenew;
create table userduplicatenew as select user_email, userid as meta_value, postdate, count(orderid) from compuserlistwithorder group by userid, user_email having count(orderid) > 1;

drop table if exists UserOrderProductDups;
CREATE TABLE UserOrderProductDups as
SELECT  distinct UD.meta_value as userID, P.ID as orderID, P.post_type, P.post_title, ordm.meta_value as productID, post_status, postdate, UD.user_email
 FROM userduplicatenew UD INNER JOIN 
 (SELECT distinct meta_value as userID , post_id as orderID FROM wp_postmeta where meta_key =  '_customer_user') as PM on PM.userID= UD.meta_value
 INNER JOIN wp_posts P on PM.orderID= P.ID
 INNER JOIN wp_woocommerce_order_items ord on ord.order_id= P.ID
 INNER JOIN wp_woocommerce_order_itemmeta ordm on ord.order_item_id= ordm.order_item_id
 WHERE post_type='Shop_subscription'
 and ( ordm.meta_key='_prorduct_id' or ordm.meta_key='_variation_id')
 ORDER BY userID, orderID;
 
 SELECT * FROM UserOrderProductDups;
 
 
 
 
 # order repeated for users

drop table if exists virtinachangesstatus;
 create table virtinachangesstatus as SELECT * FROM UserOrderProductDups where user_email in (select useremail from onholdtoactive);
 
 #select * from virtinachangesstatus;
 
 update wp_posts set post_status = 'wc-on-hold' where ID in (select orderID from virtinachangesstatus);

 update wp_posts set post_status = 'wc-active' where ID in (select max(orderID) from virtinachangesstatus group by user_email);
 
 
 
 /*
  SELECT * FROM UserOrderProductDups where user_email not in (select useremail from onholdtoactive)  order by user_email;
 
 SELECT * FROM UserOrderProductDups where user_email not in (select useremail from onholdtoactive) 
 and productID not in (select ID from wp_posts)
 order by user_email;
 */
 
 drop table if exists UserOrderProductDupsDummy;
 create table UserOrderProductDupsDummy as SELECT * FROM UserOrderProductDups where user_email not in (select useremail from onholdtoactive)  order by user_email;
 
update wp_posts set post_status = 'trash' where ID in (select orderID from UserOrderProductDupsDummy);

 update wp_posts set post_status = 'wc-active' where ID in (select max(orderID) from UserOrderProductDupsDummy group by user_email);
 
 
 
 #select * from wp_posts where ID = 371853;
 
 
 
 #create table wppostcheker as select * from wp_posts;
 
 #select * from wppostcheker;

 
 
 
 # ---------------------------------- biling interval issue -----------------------------------
 
 update wp_postmeta set meta_value = 2 where post_id = 120846 and meta_key='_billing_interval'; 
 
 
 