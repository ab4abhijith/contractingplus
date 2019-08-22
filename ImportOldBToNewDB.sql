#Assumption: Copy the OLD DB to the same server as the new DB copy
#Replace  kappamap_angelshaveNew_April03 in this script with whatever the new DB name is
#Run this script in the OldDB  

#===================================== USERS
/*DROP TABLE IF exists Copy_wp_usersOld ;
CREATE TABLE Copy_wp_usersOld as
 select distinct wu.* FROM wp_users wu;# INNER JOIN wp_usermeta ON wu.ID = wp_usermeta.user_id WHERE meta_key = 'wp_capabilities' ;
 #AND  meta_value NOT LIKE '%administrator%';
 */
 /*
 ALTER TABLE Copy_wp_usersOld ADD  newID bigint auto_increment PRIMARY KEY;
 */
 /*
CREATE INDEX idx_Copy_wp_usersOld ON Copy_wp_usersOld (id) ;
CREATE INDEX idx_wp_usermeta ON wp_usermeta (user_id) ;
*/
/*
 DROP TABLE IF exists Copy_wp_usermetaOld ;
CREATE TABLE Copy_wp_usermetaOld as SELECT distinct wum.* FROM wp_usermeta wum; # inner join Copy_wp_usersOld cwuo wum.user_id=cwuo.ID
*/
/*
ALTER TABLE Copy_wp_usermetaOld ADD  newumeta_id bigint auto_increment PRIMARY KEY;
ALTER TABLE Copy_wp_usermetaOld ADD  newuser_id bigint ;
*/
/*
DELETE FROM kappamap_angelshaveNew_April03.wp_usermeta where user_id in(
SELECT ID FROM  kappamap_angelshaveNew_April03.wp_users  where ID in ( select ID FROM Copy_wp_usersOld));
DELETE FROM  kappamap_angelshaveNew_April03.wp_users  where ID in ( select ID FROM Copy_wp_usersOld);
*/
/*
Alter table  kappamap_angelshaveNew_April03.wp_users add column oldID bigint;
SELECT max(ID) from kappamap_angelshaveNew_April03.wp_users  into @tmpMaxPostID;
UPDATE Copy_wp_usersOld SET newID= newID+@tmpMaxPostID;
*/
/*
CREATE INDEX idx_emailCopy_wp_usersOld ON Copy_wp_usersOld (user_email) ;
CREATE INDEX idx_emailwp_users ON kappamap_angelshaveNew_April03.wp_users (user_email) ;
CREATE INDEX idx_emailCopy_wp_users ON kappamap_angelshaveNew_April03.Copy_wp_users (user_email) ; 
CREATE INDEX idx_ID ON kappamap_angelshaveNew_April03.Copy_wp_users (ID) ;
*/

USE kappamap_angelshaveOld_March17;

TRuncate kappamap_angelshaveNew_April03.wp_users;
TRuncate kappamap_angelshaveNew_April03.wp_usermeta;

TRuncate kappamap_angelshaveNew_April03.wp_users;
TRuncate kappamap_angelshaveNew_April03.wp_usermeta;


 INSERT IGNORE INTO kappamap_angelshaveNew_April03.wp_users (ID, user_login,
   user_pass,
   user_nicename,
   user_email,
   user_url,
   user_registered,
   user_activation_key,
   user_status,
   display_name)
 SELECT  distinct  Copy_wp_usersOld.ID,
   Copy_wp_usersOld.user_login,
   case when newDBUser.user_pass IS NOT null then newDBUser.user_pass
		else Copy_wp_usersOld.user_pass 
        end as user_pass,
  case when newDBUser.user_nicename is not null then newDBUser.user_nicename
		else  Copy_wp_usersOld.user_nicename end as user_nicename,
   Copy_wp_usersOld.user_email,
   Copy_wp_usersOld.user_url,
   Copy_wp_usersOld.user_registered,
   case when newDBUser.user_activation_key is not null then newDBUser.user_activation_key
		else  Copy_wp_usersOld.user_activation_key end as user_activation_key,
        
        case when newDBUser.user_status is not null then newDBUser.user_status
		else  Copy_wp_usersOld.user_status end as user_status,
        
        case when newDBUser.display_name is not null then newDBUser.display_name
		else  Copy_wp_usersOld.display_name end as display_name
FROM wp_users as Copy_wp_usersOld LEFT OUTER JOIN  kappamap_angelshaveNew_April03.Copy_wp_users newDBUser
on newDBUser.user_email =Copy_wp_usersOld.user_email;



/*
# update new PK. umeta_id
SELECT max(umeta_id) from kappamap_angelshaveNew_April03.wp_usermeta  into @tmpMaxPostID;
 UPDATE Copy_wp_usermetaOld SET newumeta_id= newumeta_id+@tmpMaxPostID;
 */
 #CREATE INDEX meta_user_id_index ON Copy_wp_usermetaOld (user_id) ;
 #CREATE INDEX id_index ON Copy_wp_usersOld (ID) ;
 /*
 # update correct  user_id
 UPDATE Copy_wp_usermetaOld cwumO  
   INNER JOIN  Copy_wp_usersOld  cwuO 
on cwumO.user_id=cwuO.ID 
Set cwumO.newuser_id= cwuO.newID   ;
*/
 
 CREATE INDEX id_umID ON kappamap_angelshaveNew_April03.Copy_wp_usermeta(user_id) ;
 CREATE INDEX id_umID1 ON kappamap_angelshaveNew_April03.Copy_wp_usermeta(umeta_id) ;
 #CREATE INDEX id_umID2 ON Copy_wp_usermetaOld(umeta_id) ;
 
 INSERT IGNORE INTO kappamap_angelshaveNew_April03.wp_usermeta (umeta_id,
    user_id,
    meta_key,
    meta_value)
SELECT distinct  umeta_id,
     user_id,
   meta_key,
   meta_value
FROM  wp_usermeta ;

/*
Select Count(*)  FROM  wp_usermeta;
Select Count(distinct M.umeta_id) FROM  wp_usermeta as M LEFT OUTER JOIN kappamap_angelshaveNew_April03.Copy_wp_usermeta  as U
on U.umeta_id =M.umeta_id 

INNER JOIN kappamap_angelshaveNew_April03.Copy_wp_users wu
on U.user_id=wu.ID;

Select Count(*) from  kappamap_angelshaveNew_April03.Copy_wp_usermeta;

#delete newum FROM kappamap_angelshaveNew_April03.wp_usermeta  newum INNER JOIN Copy_wp_usermetaOld cum on newum.umeta_id=cum.umeta_id
*/
#====================================PRODUCTS
/*
DROP TABLE  IF EXISTS Copy_wp_posts_ProductsOld;
#find only those products that are actively used in orders
CREATE TABLE Copy_wp_posts_ProductsOld as 
select distinct * FROM wp_posts WHERE  (post_type='product_variation' or post_type = 'product') ;
*/
/*
 ALTER TABLE Copy_wp_postsOld ADD  newID bigint auto_increment PRIMARY KEY;
SELECT max(ID) from kappamap_angelshaveNew_April03.wp_posts  into @tmpMaxPostID;
 UPDATE Copy_wp_postsOld SET newID= newID+@tmpMaxPostID;
 */

 INSERT IGNORE INTO kappamap_angelshaveNew_April03.wp_posts
    (
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
    comment_count)
    
select
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
FROM    wp_posts where (post_type='product_variation' or post_type = 'product') ;
/*
Select distinct O.ID,
    O.post_author,
    O.post_date,
    O.post_date_gmt,
   Case when  C.post_content is not null then C.post_content
	   else O.post_content end as post_content ,
 Case when  C.post_title is not null then C.post_title
	   else O.post_title end as post_title ,
Case when  C.post_excerpt is not null then C.post_excerpt
	   else O.post_excerpt end as post_excerpt ,
   Case when  C.post_status is not null then C.post_status
	   else O.post_status end as post_status ,
Case when  C.comment_status is not null then C.comment_status
	   else O.comment_status end as comment_status ,
Case when  C.ping_status is not null then C.ping_status
	   else O.ping_status end as ping_status ,
    O.post_password,
    Case when  C.post_name is not null then C.post_name
	   else O.post_name end as post_name ,
    O.to_ping,
    O.pinged,
   O.post_modified,
    O.post_modified_gmt,
    O.post_content_filtered,
    O.post_parent,
Case when  C.guid is not null then C.guid
	   else O.guid end as guid ,
    O.menu_order,
    O.post_type,
    O.post_mime_type,
    O.comment_count
FROM    wp_posts 
O LEFT OUTER  join kappamap_angelshaveNew_April03.Copy_wp_posts_Products C
on O.ID= C.ID 
where O.post_type='product_variation' or O.post_type = 'product';
*/
#==Postmeta for products
/*
DROP TABLE  IF EXISTS Copy_wp_postmetaOld;
CREATE TABLE Copy_wp_postmetaOld as 
select distinct * FROM wp_postmeta WHERE  post_id in (select ID FROM Copy_wp_postsOld);
*/
/*
ALTER TABLE Copy_wp_postmetaOld ADD Column  newmeta_id bigint  auto_increment PRIMARY KEY;
ALTER TABLE Copy_wp_postmetaOld add column  newpost_id bigint;
*/

#Insert into postMeta
 #CREATE INDEX indpost_metaid ON  Copy_wp_postmetaOld (meta_id) ;
INSERT IGNORE INTO kappamap_angelshaveNew_April03.wp_postmeta (meta_id,post_id, meta_key, meta_value) 
SELECT distinct 
meta_id,post_id,meta_key, meta_value
FROM wp_postmeta M inner join wp_posts
on M.post_id=ID
 where post_type='product_variation' or post_type = 'product';


# Proccess Terms for products
DROP TABLE if exists Copy_wp_termsOld ;
CREATE Table Copy_wp_termsOld as
SELECT distinct terms.*   
FROM wp_term_relationships AS relations
INNER JOIN wp_term_taxonomy AS taxes
ON relations.term_taxonomy_id=taxes.term_taxonomy_id
INNER JOIN wp_terms AS terms
ON taxes.term_id=terms.term_id
INNER JOIN wp_posts 
on  ID=   object_id
WHERE  post_type='product_variation' or post_type = 'product';

/*
Select CO.* from  Copy_wp_termsOld CO 
  INNER JOIN kappamap_angelshaveNew_April03.Copy_wp_terms nt
on CO.term_id=nt.term_id  and CO.name=nt.name and CO.slug=nt.slug;

#Copy_wp_postsOld contains product /Variation IDs that are actively used in orders The actual relationship SQL is below instead of SELECT ID FROM Copy_wp_postsOld
#SELECT ID FROM wp_posts WHERE post_type in ('product', 'product_variation') 

ALTER TABLE Copy_wp_termsOld ADD Column  newterm_id bigint  auto_increment PRIMARY KEY;
#assign new PK (term_id ) in terms
SELECT max(term_id) from kappamap_angelshaveNew_April03.wp_terms  into @tmpTermID;
UPDATE Copy_wp_termsOld SET newterm_id= newterm_id+@tmpTermID;
*/
INSERT ignore into kappamap_angelshaveNew_April03.wp_terms(
term_id,
    name,
    slug,
    term_group,
    term_order)
SELECT CO.term_id,
    case when nt.name IS NOT NULL THEN  nt.name
    else CO.name end as name,
    case when nt.slug IS NOT NULL THEN  nt.slug
    else CO.slug end as slug,
     case when nt.term_group IS NOT NULL THEN  nt.term_group
    else CO.term_group end as term_group,
 case when nt.term_order IS NOT NULL THEN  nt.term_order
    else CO.term_order end as term_order
 from  Copy_wp_termsOld CO 
  LEFT OUTER JOIN kappamap_angelshaveNew_April03.Copy_wp_terms nt
on CO.term_id=nt.term_id  and CO.name=nt.name and CO.slug=nt.slug;

 #TermMeta can be null. 
#Process Term Meta for products
DROP TABLE if exists Copy_wp_termmetaOld;
CREATE TABLE Copy_wp_termmetaOld as 
SELECT * FROM wp_termmeta where term_id in (select term_id from Copy_wp_termsOld);
/*
ALTER TABLE Copy_wp_termmetaOld ADD Column  newmeta_id bigint  auto_increment PRIMARY KEY;
ALTER TABLE Copy_wp_termmetaOld add column  newterm_id bigint;

#assign new PK (meta_id ) in meta
 SELECT max(meta_id) from kappamap_angelshaveNew_April03.wp_termmeta  into @tmpMaxTermMetaID;
 UPDATE Copy_wp_termmetaOld SET newmeta_id= newmeta_id+@tmpMaxTermMetaID;

#test this before running 
 #Assign new termID in meta
UPDATE Copy_wp_termmetaOld cwtmO
   INNER JOIN  Copy_wp_termsOld  cwtO 
on cwtmO.term_id=cwtO.term_id 
Set cwtmO.newterm_id= cwtO.newterm_id   ;

#Insert into termMeta 
INSERT IGNORE INTO kappamap_angelshaveNew_April03.wp_termmeta (meta_id,term_id, meta_key, meta_value) 
SELECT distinct newmeta_id,newterm_id, meta_key, meta_value FROM Copy_wp_postmetaOld;
*/
#Process taxonomy for Products
drop TABLE if exists Copy_wp_term_taxonomyOld;
CREATE TABLE Copy_wp_term_taxonomyOld as 
SELECT distinct taxes.*   
FROM wp_term_relationships AS relations
INNER JOIN wp_term_taxonomy AS taxes
ON relations.term_taxonomy_id=taxes.term_taxonomy_id
INNER JOIN wp_terms AS terms
ON taxes.term_id=terms.term_id
INNER JOIN wp_posts 
on  ID=   object_id
WHERE  post_type='product_variation' or post_type = 'product';

#Copy_wp_postsOld contains product /Variation IDs that are actively used in orders The actual relationship SQL is below instead of SELECT ID FROM Copy_wp_postsOld
#SELECT ID FROM wp_posts WHERE post_type in ('product', 'product_variation') 
ALTER TABLE Copy_wp_term_taxonomyOld ADD Column  newterm_taxonomy_id bigint  auto_increment PRIMARY KEY;
ALTER TABLE Copy_wp_term_taxonomyOld ADD Column  newterm_id bigint;

/*
#assign new PK (term_tax_id ) in terms
SELECT max(term_taxonomy_id) from kappamap_angelshaveNew_April03.wp_term_taxonomy  into @tmpTermTaxID;
UPDATE Copy_wp_term_taxonomyOld SET newterm_taxonomy_id= newterm_taxonomy_id+@tmpTermTaxID;
#test this before running
UPDATE Copy_wp_term_taxonomyOld cwtmO
   INNER JOIN  Copy_wp_termsOld  cwtO 
on cwtmO.term_id=cwtO.term_id 
Set cwtmO.newterm_id= cwtO.newterm_id   ;
*/

INSERT IGNORE INTO kappamap_angelshaveNew_April03.wp_term_taxonomy
    (term_taxonomy_id,
    term_id,
    taxonomy,
    description,
    parent,
    count)
SELECT CO.term_taxonomy_id,
    CO.term_id,
    case when nt.taxonomy is not null then nt.taxonomy 
    else CO.taxonomy end as taxonomy ,
    case when nt.description is not null then nt.description 
    else CO.description end as description ,
     case when nt.parent is not null then nt.parent 
    else CO.parent end as parent ,
    case when nt.count is not null then nt.count 
    else CO.count end as count 
 from  Copy_wp_term_taxonomyOld CO 
  LEFT OUTER JOIN kappamap_angelshaveNew_April03.Copy_wp_term_taxonomy nt
on CO.term_taxonomy_id=nt.term_taxonomy_id  and CO.term_id=nt.term_id and CO.taxonomy=nt.taxonomy;


# Process relationships 
DROP TABLE if exists Copy_wp_term_relationshipsOld;
CREATE TABLE Copy_wp_term_relationshipsOld as 
SELECT distinct relations.*   
FROM wp_term_relationships AS relations
INNER JOIN wp_term_taxonomy AS taxes
ON relations.term_taxonomy_id=taxes.term_taxonomy_id
INNER JOIN wp_terms AS terms
ON taxes.term_id=terms.term_id
INNER JOIN wp_posts 
on  ID=   object_id
WHERE  post_type='product_variation' or post_type = 'product';
#Copy_wp_postsOld contains product /Variation IDs that are actively used in orders The actual relationship SQL is below instead of SELECT ID FROM Copy_wp_postsOld
#SELECT ID FROM wp_posts WHERE post_type in ('product', 'product_variation') 
/*
ALTER TABLE Copy_wp_term_relationshipsOld ADD Column  newobject_id bigint;
ALTER TABLE Copy_wp_term_relationshipsOld ADD Column  newterm_taxonomy_id bigint;

#update relationship
UPDATE  Copy_wp_term_relationshipsOld cwtrO
INNER JOIN Copy_wp_postsOld cwpO
on cwtrO.object_id = cwpO.ID 
inner join Copy_wp_term_taxonomyOld cwttO
on cwtrO.term_taxonomy_id= cwttO.term_taxonomy_id
SET cwtrO.newobject_id =cwpO.newID, cwtrO.newterm_taxonomy_id =cwttO.newterm_taxonomy_id;
*/

INSERT ignore INTO kappamap_angelshaveNew_April03.wp_term_relationships (
object_id,
term_taxonomy_id,
term_order)
SELECT CO.object_id,
    CO.term_taxonomy_id,
    case when  nt.term_order  is not null then  nt.term_order  
    else  CO.term_order   end as term_order
FROM  Copy_wp_term_relationshipsOld  CO 
  LEFT OUTER JOIN kappamap_angelshaveNew_April03.Copy_wp_term_relationships nt
on CO.term_taxonomy_id=nt.term_taxonomy_id  and CO.object_id=nt.object_id;

#===================================== ORDERS

#Process posts for orders
#need to process wp posts differently since we are using wp posts already for products
/*
Drop table if exists Copy_wp_posts_OrderOld;
CREATE TABLE Copy_wp_posts_OrderOld as 
select * FROM wp_posts WHERE post_type in ( 'shop_order','shop_subscription' );
*/
/*
UNION
select * FROM Orphan_wp_posts WHERE post_type in ( 'shop_order','shop_subscription' );
ALTER TABLE Copy_wp_posts_OrderOld ADD Column  newID  bigint  auto_increment PRIMARY KEY;
*/
/*
SELECT max(ID) from kappamap_angelshaveNew_April03.wp_posts  into @tmpMaxPostID;
 UPDATE Copy_wp_posts_OrderOld SET newID= newID+@tmpMaxPostID;
 */
 
 INSERT IGNORE INTO kappamap_angelshaveNew_April03.wp_posts
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
Select distinct  ID,
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
 FROM wp_posts WHERE post_type in ( 'shop_order','shop_subscription' );
/*


#Process postmeta for orders
/*
DROP TABLE  IF EXISTS Copy_wp_postmeta_OrderOld;
CREATE TABLE Copy_wp_postmeta_OrderOld as 
SELECT pmo.*  from wp_postmeta  pmo inner join  
kappamap_angelshaveNew_April03.wp_posts wp
on wp.ID = pmo.post_id  where  post_type in ( 'shop_order','shop_subscription' ) ;
ALTER TABLE Copy_wp_postmeta_OrderOld ADD Column  newmeta_id bigint  auto_increment PRIMARY KEY;
ALTER TABLE Copy_wp_postmeta_OrderOld add column  newpost_id bigint;

#assign new PK (meta_id ) in meta
 SELECT max(meta_id) from kappamap_angelshaveNew_April03.wp_postmeta  into @tmpMaxPostMetaID;
 UPDATE Copy_wp_postmeta_OrderOld  SET newmeta_id= newmeta_id+@tmpMaxPostMetaID;

 CREATE INDEX indpost_id ON  Copy_wp_postmeta_OrderOld (post_id) ;
 CREATE INDEX indid ON Copy_wp_posts_OrderOld (ID) ;
 */
 /*
 #Assign new postID in meta
UPDATE Copy_wp_postmeta_OrderOld  cwpmO
   INNER JOIN  Copy_wp_posts_OrderOld  cwpO 
on cwpmO.post_id=cwpO.ID 
Set cwpmO.newpost_id= cwpO.newID   ;
*/

#select * from kappamap_angelshaveNew_April03.wp_postmeta;

#select distinct meta_id from kappamap_angelshaveNew_April03.wp_postmeta;

#Insert into postMeta  for orders
INSERT IGNORE INTO kappamap_angelshaveNew_April03.wp_postmeta (meta_id,post_id, meta_key, meta_value) 
SELECT distinct meta_id, post_id, meta_key, meta_value  from wp_postmeta  pmo inner join  
kappamap_angelshaveNew_April03.wp_posts wp
on wp.ID = pmo.post_id  where  post_type in ( 'shop_order','shop_subscription' ) ;


#process order_items
/*
DROP TABLE  IF EXISTS Copy_wp_woocommerce_order_itemsOld;
CREATE TABLE Copy_wp_woocommerce_order_itemsOld as select * FROM wp_woocommerce_order_items;
/*
Alter table Copy_wp_woocommerce_order_itemsOld add  Column neworder_item_id bigint  auto_increment PRIMARY KEY;
Alter table Copy_wp_woocommerce_order_itemsOld add  Column neworder_id bigint ;
SELECT max(order_item_id) from kappamap_angelshaveNew_April03.wp_woocommerce_order_items  into @tmpMaxPostMetaID;
#========== Special Case.
# do not run this if the above count is null
UPDATE Copy_wp_woocommerce_order_itemsOld  SET neworder_item_id= neworder_item_id+@tmpMaxPostMetaID;
#==================End special case
#assign neworder_id in Copy_wp_woocommerce_order_itemsOld
 UPDATE Copy_wp_woocommerce_order_itemsOld  cwcOI
   INNER JOIN  Copy_wp_posts_OrderOld  cwO
on cwcOI.order_id =cwO.ID
Set cwcOI.neworder_id= cwO.newID   ;
*/
/* 
drop table if exists Orphanwp_woocommerce_order_items;
CREATE TABLE Orphanwp_woocommerce_order_items as Select * from wp_woocommerce_order_items where order_ID not in
 (select ID FROM kappamap_angelshaveNew_April03.wp_posts where
 post_type in ( 'shop_order','shop_subscription' )
 );
 create index idx_orderID on Orphanwp_woocommerce_order_items (order_id);

create table Orphanwp_woocommerce_order_itemmeta as select * FROM wp_woocommerce_order_itemmeta  
where order_item_id in (select order_item_id from Orphanwp_woocommerce_order_items);
*/
INSERT IGNORE into kappamap_angelshaveNew_April03.wp_woocommerce_order_items(
 order_item_id,
   order_item_name,
   order_item_type,
   order_id)
SELECT order_item_id,
   order_item_name,
   order_item_type,
   order_id
FROM wp_woocommerce_order_items ;
/*
where order_item_id NOT IN ( select order_item_id from Orphanwp_woocommerce_order_items);
*/
  

#Procress order meta

#process order_items
/*
DROP TABLE  IF EXISTS Copy_wp_woocommerce_order_itemmetaOld;
CREATE TABLE Copy_wp_woocommerce_order_itemmetaOld as select * FROM wp_woocommerce_order_itemmeta;
/*
Alter table Copy_wp_woocommerce_order_itemmetaOld add  Column newmeta_id bigint  auto_increment PRIMARY KEY;
Alter table Copy_wp_woocommerce_order_itemmetaOld add  Column neworder_item_id bigint ;
 create index idx_metaID on Copy_wp_woocommerce_order_itemmetaOld(meta_id);
 create index idx_metaID on Orphanwp_woocommerce_order_itemmeta (meta_id);
 
DELETE C from Copy_wp_woocommerce_order_itemmetaOld C inner join Orphanwp_woocommerce_order_itemmeta OI
on C.meta_id= OI.meta_id;
*/
INSERT ignore into	kappamap_angelshaveNew_April03.wp_woocommerce_order_itemmeta (meta_id,
    order_item_id,
    meta_key,
    meta_value)
SELECT meta_id,
    order_item_id,
    meta_key,
    meta_value
FROM wp_woocommerce_order_itemmeta;
# where meta_id NOT IN (select meta_id from Orphanwp_woocommerce_order_itemmeta );


# Process comments for orders
/*
Drop table if exists Copy_wp_commentsOld;
CREATE TABLE Copy_wp_commentsOld as select * FROM wp_comments WHERE comment_type in( 'order_note','action_log');
*/
/*
ALTER TABLE Copy_wp_commentsOld ADD Column  newcomment_id bigint  auto_increment PRIMARY KEY;
ALTER TABLE Copy_wp_commentsOld ADD Column  newuser_id bigint ;
ALTER TABLE Copy_wp_commentsOld ADD Column  newcomment_post_id bigint ;


#================================Special Case. 
#Check whether there is only one comment ID here. which is of test
#Then Delete the one row
 Select Count(*) from   kappamap_angelshaveNew_April03.wp_comments into @tmpCount ;
 # Delete if only there is one row.
 DELETE FROM kappamap_angelshaveNew_April03.wp_comments;
# execute the next two SQLs only if there were more than one row in  kappamap_angelshaveNew_April03.wp_comments
#assign new PK (comment_id ) in wp_comments
 SELECT max(comment_id) from kappamap_angelshaveNew_April03.wp_comments  into @tmpCommentsID;
 UPDATE Copy_wp_commentsOld  SET newcomment_id= newcomment_id+@tmpCommentsID;
/* NO NEED TO UPDATE THE USERid IN WPCOMMENTS SINCE WP_COMMENTS.USERid=0 FOR ALL RECORDS
 #assign newuser_id in wp_comments
 UPDATE Copy_wp_commentsOld  cwcO
   INNER JOIN  Copy_wp_usersOld  cwuO 
on cwcO.user_id=cwuO.ID
Set cwpmO.newuser_id= cwuO.newID;

# if we did not apply the update statment of the PK then run the next line
UPDATE Copy_wp_commentsOld set newuser_id=0;
#========================= ENd of special case

 #assign comment_post_id in wp_comments
 UPDATE Copy_wp_commentsOld  cwcO
   INNER JOIN  Copy_wp_posts_OrderOld  cwuO 
on cwcO.comment_post_id =cwuO.ID
Set cwcO.newcomment_post_id= cwuO.newID   ;
*/

INSERT ignore into kappamap_angelshaveNew_April03.wp_comments 
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
SELECT comment_id,
    comment_post_id,
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
FROM wp_comments WHERE comment_type in( 'order_note','action_log');
# <>'action_scheduler' ;

#===========================================================Comment meta
/*
DROP TABLE if exists Copy_wp_commentmetaOld;
CREATE TABLE Copy_wp_commentmetaOld as select * FROM wp_commentmeta;
ALTER TABLE Copy_wp_commentmetaOld ADD Column  newmeta_id bigint  auto_increment PRIMARY KEY;
ALTER TABLE Copy_wp_commentmetaOld add column  newcomment_id bigint;
*/
#============================= Special Case
# Check the max ID below from. If null then skip the next two statments
/*
SELECT max(meta_id) from kappamap_angelshaveNew_April03.wp_commentmeta  into @tmpCommentsMetaID;
 UPDATE Copy_wp_commentmetaOld  SET newmeta_id= newmeta_id+@tmpCommentsMetaID;
 */

#========================= ENd of special case
 /*
 CREATE INDEX idx_comment_id ON Copy_wp_commentmetaOld (comment_id) ;
 CREATE INDEX idx_comment_ID  ON Copy_wp_commentsOld (comment_ID) ;
 
 UPDATE Copy_wp_commentmetaOld  cwcO
   INNER JOIN  Copy_wp_commentsOld  cwuO 
on cwcO.newcomment_id=cwuO.comment_id
Set cwcO.newcomment_id= cwuO.newcomment_ID;

*/
INSERT ignore into kappamap_angelshaveNew_April03.wp_commentmeta
(meta_id,
    comment_id,
    meta_key,
    meta_value)
SELECT  meta_id,
     wc.comment_id,
    meta_key,
    meta_value
 FROM wp_commentmeta w INNER JOIN kappamap_angelshaveNew_April03.wp_comments wc ON wc.comment_id= w.comment_ID
 where comment_type in( 'order_note','action_log');
  