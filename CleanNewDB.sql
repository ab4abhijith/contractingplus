#Run this in New DB

/*Orders*/
CREATE TABLE Copy_wp_woocommerce_order_itemmeta as select * FROM wp_woocommerce_order_itemmeta;
DELETE FROM wp_woocommerce_order_itemmeta;

CREATE TABLE Copy_wp_woocommerce_order_items as select * FROM wp_woocommerce_order_items;
DELETE FROM wp_woocommerce_order_items;

CREATE TABLE Copy_wp_comments as select * FROM wp_comments WHERE comment_type in ('order_note' ,'action_log');
DELETE FROM wp_comments WHERE comment_type  in ('order_note' ,'action_log');

CREATE TABLE Copy_wp_commentmeta as select * FROM wp_commentmeta;
DELETE FROM wp_commentmeta ;

CREATE TABLE Copy_wp_posts_Order as select * FROM wp_posts WHERE post_type in ( 'shop_order','shop_subscription' );
DELETE FROM wp_posts WHERE post_type in ( 'shop_order', 'shop_subscription');

CREATE TABLE Copy_wp_postmeta_Order as select * FROM wp_postmeta WHERE post_id in (Select ID from Copy_wp_posts_Order);
DELETE wpm FROM wp_postmeta wpm INNER JOIN Copy_wp_postmeta_Order cWPM on wpm.meta_id=cWPM.meta_id;


/*users*/
CREATE TABLE Copy_wp_users as 
select  distinct wu.*  FROM wp_users wu ;
#INNER JOIN wp_usermeta ON wu.ID = wp_usermeta.user_id
 #WHERE  meta_value   LIKE '%administrator%' and
 # meta_key = 'wp_capabilities';
 
DELETE wu.* FROM wp_users wu;#  INNER join Copy_wp_users cwpu on wu.ID= cwpu.ID;

CREATE TABLE Copy_wp_usermeta as select wum.* from wp_usermeta wum ;# where  user_id  IN ( select ID FROM  Copy_wp_users);
DELETE wum FROM wp_usermeta wum ;# inner join Copy_wp_usermeta Cwum wum.umeta_id=Cwum.meta_id;
/*Now copy the admins also
INSERT ignore into Copy_wp_users
SELECT * FROM  wp_users where ID NOT IN (
 select  distinct wu.ID FROM wp_users wu INNER JOIN wp_usermeta ON wu.ID = wp_usermeta.user_id
 WHERE # meta_value  LIKE '%administrator%' and
 and meta_key = 'wp_capabilities');
- 
 INSERT ignore into Copy_wp_usermeta
 SELECT * FROM wp_usermeta where user_id in
 (SELECT ID FROM  wp_users where ID NOT IN (
 select  distinct wu.ID FROM wp_users wu INNER JOIN wp_usermeta ON wu.ID = wp_usermeta.user_id
 WHERE  #meta_value  LIKE '%administrator%' and
 and meta_key = 'wp_capabilities')
 );
*/

/*Products*/
CREATE TABLE Copy_wp_term_relationships as 
SELECT distinct relations.*   
FROM wp_term_relationships AS relations
INNER JOIN wp_term_taxonomy AS taxes
ON relations.term_taxonomy_id=taxes.term_taxonomy_id
INNER JOIN wp_terms AS terms
ON taxes.term_id=terms.term_id
WHERE object_id IN (SELECT ID FROM wp_posts WHERE post_type in ('product', 'product_variation'));

CREATE TABLE Copy_wp_term_taxonomy as 
SELECT distinct taxes.*   
FROM wp_term_relationships AS relations
INNER JOIN wp_term_taxonomy AS taxes
ON relations.term_taxonomy_id=taxes.term_taxonomy_id
INNER JOIN wp_terms AS terms
ON taxes.term_id=terms.term_id
WHERE object_id IN (SELECT ID FROM wp_posts WHERE post_type in ('product', 'product_variation') );

CREATE TABLE Copy_wp_terms as 
SELECT distinct terms.*   
FROM wp_term_relationships AS relations
INNER JOIN wp_term_taxonomy AS taxes
ON relations.term_taxonomy_id=taxes.term_taxonomy_id
INNER JOIN wp_terms AS terms
ON taxes.term_id=terms.term_id
WHERE object_id IN (SELECT ID FROM wp_posts WHERE post_type in ('product', 'product_variation') );

CREATE TABLE Copy_wp_termmeta as select * from wp_termmeta  WHERE term_id IN (SELECT term_id FROM Copy_wp_terms);
DELETE wtm FROM wp_termmeta wtm  INNER JOIN Copy_wp_terms cwpt on cwpt.term_id=wtm.term_id;


DELETE relations.*, taxes.*, terms.*
FROM wp_term_relationships AS relations
INNER JOIN wp_term_taxonomy AS taxes
ON relations.term_taxonomy_id=taxes.term_taxonomy_id
INNER JOIN wp_terms AS terms
ON taxes.term_id=terms.term_id
WHERE object_id IN (SELECT ID FROM wp_posts WHERE post_type  in ('product', 'product_variation') );

CREATE TABLE Copy_wp_posts_Products as select * FROM wp_posts WHERE post_type  in ('product', 'product_variation') ;
DELETE FROM wp_posts WHERE post_type  in ('product', 'product_variation') ;

CREATE TABLE Copy_wp_postmeta_Products as select * from wp_postmeta  WHERE post_id IN (SELECT ID FROM Copy_wp_posts_Products);
DELETE wpm FROM wp_postmeta wpm  INNER JOIN Copy_wp_postmeta_Products cwpmp on cwpmp.meta_id=wpm.meta_id



