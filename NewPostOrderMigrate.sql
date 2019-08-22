SET SQL_SAFE_UPDATES = 0;


#create table wp_posts_backup_new as select * from wp_posts;
#create table wp_postmeta_backup_new as select * from wp_postmeta;
#create table wp_woocommerce_order_items_backup_new as select * from wp_woocommerce_order_items;
#create table wp_woocommerce_order_itemmeta_backup_new as select * from wp_woocommerce_order_itemmeta;

DROP TABLE if exists tmpOrphanOrderPosts;
create table tmpOrphanOrderPosts as 
SELECT CWP.* FROM Copy_wp_posts_Order CWP inner join wp_posts WP on 
CWP.ID= WP.ID  and (WP.post_type='shop_order' or WP.post_type='shop_subscription')
AND CWP.post_date_gmt <> WP.post_date_gmt;

alter table tmpOrphanOrderPosts add index (ID);

UPDATE  wp_posts W INNER JOIN tmpOrphanOrderPosts  t
on W.ID= t.ID
SET W.post_date= t.post_date, W.post_date_gmt= t.post_date_gmt , W.post_title =t.post_title, W.post_status = t.post_title, W.post_name = t.post_name,  W.post_modified= t.post_modified , W.post_modified_gmt= t.post_modified_gmt;

DELETE  CWP FROM Copy_wp_posts_Order CWP  INNER JOIN tmpOrphanOrderPosts t on  t.ID=CWP.ID;

DROP TABLE if exists tmpMatchingOrderPosts;
create table tmpMatchingOrderPosts as 
SELECT CWP.* FROM Copy_wp_posts_Order CWP inner join wp_posts WP on 
CWP.ID= WP.ID  and (WP.post_type='shop_order' or WP.post_type='shop_subscription')
AND CWP.post_date_gmt =WP.post_date_gmt;

alter table tmpMatchingOrderPosts add index (ID);

DELETE  CWP FROM Copy_wp_posts_Order CWP  INNER JOIN tmpMatchingOrderPosts t on  t.ID=CWP.ID;

#process postmeta
CREATE INDEX idxtmpMatchingOrderPosts on tmpMatchingOrderPosts (ID);
DROP TABLE IF EXISTS tmpWPPostMetaOrder;

create table tmpWPPostMetaOrder as
SELECT WPM.* FROM  Copy_wp_postmeta_Order CWO inner join tmpMatchingOrderPosts t on t.ID = CWO.post_id
INNER JOIN wp_postmeta WPM on WPM.post_id=CWO.post_id and WPM.meta_id=CWO.meta_id;

CREATE INDEX idx_meta_id on tmpWPPostMetaOrder(meta_id);
DELETE WPM FROM  wp_postmeta WPM  INNER JOIN tmpWPPostMetaOrder t on t.meta_id= WPM.meta_id;

# process Order ITEMS
DROP TABLE If exists tmpDltdwp_woocommerce_order_items;
CREATE TABLE tmpDltdwp_woocommerce_order_items
SELECT CW.* FROM   wp_woocommerce_order_items W INNER JOIN Copy_wp_woocommerce_order_items CW 
on CW.order_item_id =W.order_item_id and CW.order_id =W.order_id;

alter table Copy_wp_woocommerce_order_items add index (order_item_id);
alter table Copy_wp_woocommerce_order_items add index (order_id);

DELETE W FROM   wp_woocommerce_order_items W INNER JOIN Copy_wp_woocommerce_order_items CW 
on CW.order_item_id =W.order_item_id and CW.order_id =W.order_id;


# process Order ITEMmeta
DROP TABLE if exists tmpDltdwp_woocommerce_order_itemmeta;

select * from wp_woocommerce_order_itemmeta;

CREATE table tmpDltdwp_woocommerce_order_itemmeta as 
SELECT C.* FROM  wp_woocommerce_order_itemmeta W  INNER JOIN  Copy_wp_woocommerce_order_itemmeta C 
on C.meta_id=W.meta_id  and C.order_item_id =W.order_item_id;

CREATE INDEX idx_tmpDltdwp_woocommerce_order_itemmeta on tmpDltdwp_woocommerce_order_itemmeta(meta_id);
DELETE C FROM  wp_woocommerce_order_itemmeta  C INNER JOIN tmpDltdwp_woocommerce_order_itemmeta   W on C.meta_id=W.meta_id  ;

# process Comments
DROP TABLE if exists tmpDltdComments;

CREATE TABLE tmpDltdComments as
Select CC.* from wp_comments W inner join  Copy_wp_comments CC  on  CC.comment_post_ID = W.comment_post_ID
where W.comment_type='order_note' AND CC.comment_date =W.comment_date;

CREATE INDEX idx_tmpDltdComments on tmpDltdComments (comment_ID);
DELETE W FROM  wp_comments W INNER JOIN  tmpDltdComments t on  t.comment_ID = W.comment_ID;

#Process CommentMeta
DROP TABLE if exists tmpDltdCommentMeta;

CREATE TABLE tmpDltdCommentMeta as
Select CM.* from wp_commentmeta  W Inner join  Copy_wp_commentmeta CM  on  CM.comment_id = W.comment_id;

CREATE INDEX idx_tmpDltdCommentMeta on tmpDltdComments (comment_id);
DELETE W FROM  wp_commentmeta W INNER JOIN  tmpDltdCommentMeta t on  t.comment_id = W.comment_id;


#select * from Copy_wp_posts_Order;

#Perform Inserts
ALTER TABLE Copy_wp_posts_Order add newID int  primary key auto_increment;
SET @tmpNewID=0;
SELECT  max(ID) from wp_posts into @tmpNewID ;
SElect @tmpNewID;
UPDATE Copy_wp_posts_Order set newID = newID+@tmpNewID;

Create table copypostorderidchange as select ID, newID from Copy_wp_posts_Order;

UPDATE Copy_wp_posts_Order C INNER JOIN  wp_posts W  on W.ID= C.ID
SET C.ID= C.newID ;

INSERT  INTO wp_posts
(ID,
post_author,
post_date,
post_date_gmt,
post_content,
post_title,
post_excerpt,
post_status,
comment_status,
ping_status,
post_password,
post_name,
to_ping,
pinged,
post_modified,
post_modified_gmt,
post_content_filtered,
post_parent,
guid,
menu_order,
post_type,
post_mime_type,
comment_count)
SELECT 
ID,
post_author,
post_date,
post_date_gmt,
post_content,
post_title,
post_excerpt,
post_status,
comment_status,
ping_status,
post_password,
post_name,
to_ping,
pinged,
post_modified,
post_modified_gmt,
post_content_filtered,
post_parent,
guid,
menu_order,
post_type,
post_mime_type,
comment_count
FROM Copy_wp_posts_Order;

#select * from copypostorderidchange;

UPDATE   Copy_wp_postmeta_Order Cwu inner join copypostorderidchange t on 
Cwu.post_id= t.ID
set Cwu.post_id= t.newID where t.ID!=t.newID;


INSERT Ignore  INTO wp_postmeta
(
post_id,
meta_key,
meta_value)
Select 
 newID,
'prev_order_id',
 ID
FROM copypostorderidchange where ID!=newID;

ALTER TABLE Copy_wp_postmeta_Order ADD column newmeta_id int primary key auto_increment;
SET @tmpNewUMID=0;
SELECT  max(meta_id) from wp_postmeta into @tmpNewUMID ;
UPDATE Copy_wp_postmeta_Order set newmeta_id = newmeta_id+@tmpNewUMID;

UPDATE Copy_wp_postmeta_Order C INNER JOIN  wp_postmeta W  on W.meta_id= C.meta_id
SET C.meta_id= C.newmeta_id ;

#select * from wp_postmeta;

#show index from Copy_wp_postmeta_Order;
INSERT ignore INTO wp_postmeta
(meta_id,
post_id,
meta_key,
meta_value)
Select 
meta_id,
post_id,
meta_key,
meta_value
FROM 
Copy_wp_postmeta_Order;

INSERT INTO wp_woocommerce_order_items  SELECT * FROM  Copy_wp_woocommerce_order_items;


ALTER TABLE Copy_wp_woocommerce_order_itemmeta ADD column newmeta_id int primary key auto_increment;

SET @tmpNewOMID=0;
SELECT  max(meta_id) from Copy_wp_woocommerce_order_itemmeta  into @tmpNewOMID ;

#SELECT  max(meta_id) from wp_woocommerce_order_itemmeta  into @tmpNewOMIDCOPY ;

#select @tmpNewOMID ;
#select * from Copy_wp_woocommerce_order_itemmeta;
UPDATE Copy_wp_woocommerce_order_itemmeta set newmeta_id = newmeta_id+@tmpNewOMID;
UPDATE Copy_wp_woocommerce_order_itemmeta C INNER JOIN  wp_woocommerce_order_itemmeta  W  on W.meta_id= C.meta_id
SET C.meta_id= C.newmeta_id ;


#show index from Copy_wp_woocommerce_order_itemmeta;
alter table Copy_wp_woocommerce_order_itemmeta drop index order_item_id;
alter table Copy_wp_woocommerce_order_itemmeta drop index order_item_id_2;

INSERT INTO wp_woocommerce_order_itemmeta  
(meta_id,
order_item_id,
meta_key,
meta_value
)
SELECT 
meta_id,
order_item_id,
meta_key,
meta_value FROM
Copy_wp_woocommerce_order_itemmeta;

alter table Copy_wp_woocommerce_order_itemmeta add index (order_item_id);


#delete from wp_woocommerce_order_itemmeta where order_item_id in (
#select order_item_id from Copy_wp_woocommerce_order_itemmeta where meta_id<>newmeta_id
#);

#select * from Copy_wp_woocommerce_order_itemmeta;

/*INSERT INTO wp_woocommerce_order_itemmeta  
(order_item_id,
meta_key,
meta_value
)
SELECT 
order_item_id,
'previous_meta_id',
meta_id FROM
Copy_wp_woocommerce_order_itemmeta
WHERE meta_id<>newmeta_id;*/

#alter table Copy_wp_woocommerce_order_itemmeta add index (order_item_id);


ALTER TABLE Copy_wp_comments ADD column newcomment_ID int primary key auto_increment;
SET @tmpNewCMID=0;
SELECT  max(comment_ID) from wp_comments   into @tmpNewCMID ;
UPDATE Copy_wp_comments set newcomment_ID = newcomment_ID+@tmpNewCMID;
UPDATE Copy_wp_comments C INNER JOIN  wp_comments  W  on W.comment_ID= C.comment_ID
SET C.comment_ID= C.newcomment_ID ;

INSERT INTO wp_comments
(comment_ID,
comment_post_ID,
comment_author,
comment_author_email,
comment_author_url,
comment_author_IP,
comment_date,
comment_date_gmt,
comment_content,
comment_karma,
comment_approved,
comment_agent,
comment_type,
comment_parent,
user_id)
SELECT 
comment_ID,
comment_post_ID,
comment_author,
comment_author_email,
comment_author_url,
comment_author_IP,
comment_date,
comment_date_gmt,
comment_content,
comment_karma,
comment_approved,
comment_agent,
comment_type,
comment_parent,
user_id
FROM  Copy_wp_comments;

INSERT INTO wp_commentmeta  SELECT * FROM  Copy_wp_commentmeta;




