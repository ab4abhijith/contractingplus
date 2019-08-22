#create table wp_posts_backup as select * from wp_posts;
#create table wp_postmeta_backup as select * from wp_postmeta;
#create table wp_woocommerce_order_items_backup as select * from wp_woocommerce_order_items;
#create table wp_woocommerce_order_itemmeta_backup as select * from wp_woocommerce_order_itemmeta;

#alter table Copy_wp_posts_Order add index (post_date);
#alter table Copy_wp_posts_Order add index (ID);
#alter table wp_posts add index (post_date);
#alter table wp_posts add index (ID);

#select * from Copy_wp_users where ID = 33353;
#select * from wp_users where ID = 33353;
#select * from wp_users where user_email = 'sista_h@hotmail.com';

#select * from tmpIDChange_wp_users;

#update Copy_wp_postmeta_Order as cwpo inner join tmpIDChange_wp_users as twpn on twpn.ID = cwpo.meta_value
#set cwpo.meta_value = twpn.newID where cwpo.meta_key = '_customer_user';

alter table Copy_wp_posts_Order add index (ID);
alter table Copy_wp_postmeta_Order add index (post_id);

alter table wp_posts add index (ID);
alter table wp_postmeta add index (post_id);

drop table if exists copywpordermeta;
create table copywpordermeta as select cwpo.*, cwpmo.meta_value as customerid from Copy_wp_posts_Order as cwpo 
inner join Copy_wp_postmeta_Order as cwpmo on cwpo.ID = cwpmo.post_id where cwpmo.meta_key='_customer_user';

drop table if exists wpordermeta;
create table wpordermeta as select cwpo.*, cwpmo.meta_value as customerid from wp_posts as cwpo 
inner join wp_postmeta as cwpmo on cwpo.ID = cwpmo.post_id where cwpmo.meta_key='_customer_user';

#select * from copywpordermeta;
#select * from wpordermeta;


alter table copywpordermeta add index(post_date);
alter table wpordermeta add index(post_date);

drop table if exists comdatatodelfrmpostorder;
create table comdatatodelfrmpostorder as select wpm.* from copywpordermeta as cwpm inner join  wpordermeta as wpm on wpm.customerid = cwpm.customerid and
wpm.post_date = cwpm.post_date and wpm.post_title = cwpm.post_title;

#select * from comdatatodelfrmpostorder;

#select * from Copy_wp_posts_Order where ID in (select ID from comdatatodelfrmpostorder);

drop table if exists poststoinsert;
create table poststoinsert as select * from Copy_wp_posts_Order where ID not in (select ID from comdatatodelfrmpostorder);


drop table if exists poststoinsertwithidupdate;
create table poststoinsertwithidupdate as select * from poststoinsert where ID in (select ID from wp_posts);

drop table if exists poststoinsertwithnoupdate;
create table poststoinsertwithnoupdate as select * from poststoinsert where ID not in (select ID from wp_posts);

#select * from poststoinsertwithnoupdate;
#select * from poststoinsertwithidupdate;

drop table if exists copypostmetatoinsert;
create table copypostmetatoinsert as select * from Copy_wp_postmeta_Order where post_id in (select ID from poststoinsertwithnoupdate);

drop table if exists orderitemtoinsert;
create table orderitemtoinsert as select * from Copy_wp_woocommerce_order_items where order_id in (select ID from poststoinsertwithnoupdate);

drop table if exists orderitemtoinsert;
create table orderitemtoinsert as select * from Copy_wp_woocommerce_order_items where order_id in (select ID from poststoinsertwithnoupdate);

alter table Copy_wp_woocommerce_order_itemmeta add index (order_item_id);
alter table Copy_wp_woocommerce_order_itemmeta add index (order_item_id);

drop table if exists orderitemmetatoinsert;
create table orderitemmetatoinsert as select * from Copy_wp_woocommerce_order_itemmeta where order_item_id in (select order_item_id from orderitemtoinsert);


#select * from Copy_wp_woocommerce_order_items where order_id in (select ID from poststoinsertwithidupdate);

#select * from wp_woocommerce_order_items where order_id in (select ID from poststoinsertwithidupdate);

#select * from wp_woocommerce_order_itemmeta;

insert into wp_posts select * from poststoinsertwithnoupdate;
insert into wp_postmeta select * from copypostmetatoinsert;
insert into wp_woocommerce_order_items select * from orderitemtoinsert;
insert into wp_woocommerce_order_itemmeta select * from orderitemmetatoinsert;

#select * from wp_comments where comment_post_ID in (select ID from poststoinsertwithnoupdate);
drop table if exists commenttoinsert;
create table commenttoinsert as select * from Copy_wp_comments where comment_post_ID in (select ID from poststoinsertwithnoupdate);

insert into wp_comments select * from commenttoinsert where comment_ID not in (select comment_ID from wp_comments);

drop table if exists commentmetatoinsert;
create table commentmetatoinsert as select * from Copy_wp_commentmeta where comment_id in (select comment_post_ID from commenttoinsert);

#select * from commentmetatoinsert;
#select * from wp_commentmeta where meta_id not in (select meta_id from commentmetatoinsert);

insert into wp_commentmeta select * from commentmetatoinsert where meta_id not in (select meta_id from wp_commentmeta);

