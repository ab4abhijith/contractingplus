
# Uncomment Below Data to Change Stripe processed orders to Special On Hold



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


