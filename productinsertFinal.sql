#USE kappamap_angelshaveNew_March21;

#USE kappamap_angelshaveNew_April05;


SET SQL_SAFE_UPDATES = 0;

Drop table if exists updatelistproducts;

create table updatelistproducts as select * from FinalPostsToInsert where newpostid = post_id;

Drop table if exists insertlistproducts;

create table insertlistproducts as select * from FinalPostsToInsert where newpostid != post_id;



insert into insertlistproducts select * from updatelistproducts where newpostid not in (
select ID from wp_posts where (post_type='product' or post_type='product_variation'));


delete from updatelistproducts where newpostid in (select newpostid from insertlistproducts);

drop table if exists updatelistproductsfinal;

create table updatelistproductsfinal as select * from insertlistproducts where post_id in (select ID from wp_posts where (post_type='product' or post_type='product_variation'));


drop table if exists temp_wp_posts;

create table temp_wp_posts as select * from wp_posts;

drop table if exists temp_wp_postmeta;

create table temp_wp_postmeta as select * from wp_postmeta;

drop table if exists temp_wp_woocommerce_order_itemmeta;

create table temp_wp_woocommerce_order_itemmeta as select * from wp_woocommerce_order_itemmeta;

drop table if exists temp_wp_term_relationships;

create table temp_wp_term_relationships as select * from wp_term_relationships;




update temp_wp_posts as twp inner join updatelistproducts as ulp on ulp.post_id = twp.ID 
set twp.post_parent = ulp.newpostparent;



update temp_wp_postmeta as twpt inner join updatelistproducts as ulp on ulp.post_id = twpt.post_id 
set twpt.meta_value = ulp.NewSKU where twpt.meta_key = '_sku';

# consider product price, stock, availability, variation meta 


drop table if exists producttotrash;
create table producttotrash as select * from updatelistproductsfinal where post_id in (select ID from wp_posts) 
and newpostid in (select ID from wp_posts);

drop table if exists producttoupdateoldtonew;
create table producttoupdateoldtonew as select * from updatelistproductsfinal where post_id in (select ID from wp_posts) 
and newpostid not in (select ID from wp_posts);

update temp_wp_posts as twp inner join producttotrash as upf on upf.post_id = twp.ID 
set twp.post_status = 'trash'
where (twp.post_type = 'product' or twp.post_type = 'product_variation');

update temp_wp_woocommerce_order_itemmeta as twpo inner join producttotrash as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_product_id';

update temp_wp_woocommerce_order_itemmeta as twpo inner join producttotrash as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_variation_id';



update temp_wp_posts as twp inner join producttoupdateoldtonew as upf on upf.post_id = twp.ID 
set twp.post_parent = upf.newpostparent, twp.ID = upf.newpostid
where (twp.post_type = 'product' or twp.post_type = 'product_variation'); # oldpostid = newpostid but newpostid exist

update temp_wp_postmeta as twpt inner join producttoupdateoldtonew as upf on upf.post_id = twpt.post_id 
set twpt.post_id = upf.newpostid, twpt.meta_value = upf.newSKU where twpt.meta_key = '_sku';

update temp_wp_term_relationships as twpr inner join producttoupdateoldtonew as upf on upf.post_id = twpr.object_id
set twpr.object_id = upf.newpostid;

update temp_wp_woocommerce_order_itemmeta as twpo inner join producttoupdateoldtonew as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_product_id';

update temp_wp_woocommerce_order_itemmeta as twpo inner join producttoupdateoldtonew as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_variation_id';




update Copy_wp_posts_Products as twp inner join producttotrash as upf on upf.post_id = twp.ID 
set twp.post_status = 'trash'
where (twp.post_type = 'product' or twp.post_type = 'product_variation');

update Copy_wp_woocommerce_order_itemmeta as twpo inner join producttotrash as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_product_id';

update Copy_wp_woocommerce_order_itemmeta as twpo inner join producttotrash as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_variation_id';


update Copy_wp_posts_Products as twp inner join producttoupdateoldtonew as upf on upf.post_id = twp.ID 
set twp.post_parent = upf.newpostparent, twp.ID = upf.newpostid
where (twp.post_type = 'product' or twp.post_type = 'product_variation');

update Copy_wp_postmeta_Products as twpt inner join producttoupdateoldtonew as upf on upf.post_id = twpt.post_id 
set twpt.post_id = upf.newpostid, twpt.meta_value = upf.newSKU where twpt.meta_key = '_sku';

update Copy_wp_term_relationships as twpr inner join producttoupdateoldtonew as upf on upf.post_id = twpr.object_id
set twpr.object_id = upf.newpostid;

update Copy_wp_woocommerce_order_itemmeta as twpo inner join producttoupdateoldtonew as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_product_id';

update Copy_wp_woocommerce_order_itemmeta as twpo inner join producttoupdateoldtonew as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_variation_id';


drop table if exists insertlistproductsfinal;
create table insertlistproductsfinal as select * from insertlistproducts where post_id not in (select ID from wp_posts where (post_type='product' or post_type='product_variation'));
drop table if exists delpostid;
create table delpostid as select ID,post_title, post_status, post_type, post_parent from temp_wp_posts where ID not in (select newpostid from FinalPostsToInsert) and post_status = 'publish' and (post_type = 'product' or post_type = 'product_variation');


drop table if exists distprodtodel;
create temporary table distprodtodel as select distinct meta_value as postid from temp_wp_woocommerce_order_itemmeta where meta_value in (select ID from delpostid) and (meta_key='_product_id' or meta_key = '_variation_id');


delete from delpostid where ID not in (select postid from distprodtodel);

alter table delpostid add column newpostid varchar(10);

ALTER TABLE delpostid ADD PRIMARY KEY (ID); 

alter table delpostid add column oldsku varchar(10), add column price float;

update delpostid as dp inner join wp_postmeta as wp on wp.post_id = dp.ID set dp.oldsku = wp.meta_value where wp.meta_key = '_sku';
update delpostid as dp inner join wp_postmeta as wp on wp.post_id = dp.ID set dp.price = wp.meta_value where wp.meta_key = '_price';


alter table delpostid add column newparentpost varchar(10);




drop table if exists updateprodparent;

create table updateprodparent as select * from delpostid where newparentpost is not null;

select twp.ID, twp.post_parent, up.newparentpost from temp_wp_posts as twp inner join updateprodparent as up on up.ID = twp.ID;

update temp_wp_posts as twp inner join updateprodparent as up on up.ID = twp.ID
set twp.post_parent = up.newparentpost;

drop table if exists updateprodids;

create table updateprodids as select ID as post_id, newpostid from delpostid where newpostid is not null;


update temp_wp_woocommerce_order_itemmeta as twpo inner join updateprodids as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_product_id';

update temp_wp_woocommerce_order_itemmeta as twpo inner join updateprodids as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_variation_id';

update Copy_wp_woocommerce_order_itemmeta as twpo inner join updateprodids as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_product_id';

update Copy_wp_woocommerce_order_itemmeta as twpo inner join updateprodids as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_variation_id';

select * from delpostid where newpostid not in (select newpostid from FinalPostsToInsert);

drop table if exists survivedproducts;

create table survivedproducts as select distinct newpostid from FinalPostsToInsert union 
select distinct ID from delpostid where newparentpost is not null;

delete from temp_wp_posts where ID not in (select newpostid from survivedproducts) and (post_type='product' or post_type='product_variation'); 


drop table if exists oldpostorderdet;
create temporary table oldpostorderdet select * from wp_woocommerce_order_itemmeta as wpoi inner join wp_posts as wp 
on wp.ID = wpoi.meta_value where (wpoi.meta_key = '_product_id' or wpoi.meta_key = '_variation_id') and wp.post_status = 'publish';

drop table if exists latpostorderdet;
create temporary table latpostorderdet select * from temp_wp_woocommerce_order_itemmeta as wpoi inner join temp_wp_posts as wp 
on wp.ID = wpoi.meta_value where (wpoi.meta_key = '_product_id' or wpoi.meta_key = '_variation_id') and wp.post_status = 'publish';

#select count(*) from oldpostorderdet;
#select count(*) from latpostorderdet;

alter table insertlistproductsfinal add column insertpostid varchar(10);
update insertlistproductsfinal set insertpostid = newpostid where newpostid not in (select ID from temp_wp_posts);

insert into temp_wp_posts select * from Copy_wp_posts_Products where ID in (select insertpostid from insertlistproductsfinal);
insert into temp_wp_postmeta (post_id, meta_key, meta_value) 
select post_id, meta_key, meta_value from Copy_wp_postmeta_Products where post_id in (select insertpostid from insertlistproductsfinal);
insert into temp_wp_term_relationships select * from Copy_wp_term_relationships where object_id in (select insertpostid from insertlistproductsfinal);

insert into temp_wp_posts (post_author, post_date, post_date_gmt, post_content, post_title, post_excerpt, post_status, comment_status, ping_status, post_password, post_name, to_ping, pinged, post_modified, post_modified_gmt, post_content_filtered, post_parent, guid, menu_order, post_type, post_mime_type, comment_count)
select post_author, post_date, post_date_gmt, post_content, post_title, post_excerpt, post_status, comment_status, ping_status, post_password, post_name, to_ping, pinged, post_modified, post_modified_gmt, post_content_filtered, post_parent, guid, menu_order, post_type, post_mime_type, comment_count from Copy_wp_posts_Products where ID in (select newpostid from insertlistproductsfinal where insertpostid is null);
insert into temp_wp_postmeta (post_id, meta_key, meta_value) 
select post_id, meta_key, meta_value from Copy_wp_postmeta_Products where post_id in (select newpostid from insertlistproductsfinal where insertpostid is null);
insert into temp_wp_term_relationships 
select * from Copy_wp_term_relationships where object_id in (select newpostid from insertlistproductsfinal where insertpostid is null);



TRuncate  wp_posts;
TRuncate  wp_postmeta;
TRuncate  wp_term_relationships;
TRuncate  wp_woocommerce_order_itemmeta;

insert ignore into wp_posts select * from temp_wp_posts;

insert into wp_postmeta ( post_id, meta_key, meta_value) select  post_id, meta_key, meta_value from temp_wp_postmeta;


insert ignore into wp_term_relationships select * from temp_wp_term_relationships;
insert into wp_woocommerce_order_itemmeta select * from temp_wp_woocommerce_order_itemmeta;



drop table if exists FinalPostsToUpdate;
create table FinalPostsToUpdate as select post_id, 0 as newpostid, productID, NewProductID from tmpProducts where post_id not in (select post_id from FinalPostsToInsert) and post_id not in (select newpostid from FinalPostsToInsert) and post_id!=0;

Update FinalPostsToUpdate as fu inner join FinalPostsToInsert as fi on fu.NewProductID = fi.NewProductID
set fu.newpostid = fi.newpostid;

update FinalPostsToUpdate as fu inner join tmpProducts as tp on fu.NewProductID = tp.productID 
set fu.newpostid = tp.post_id where newpostid =0;

select * from FinalPostsToUpdate;

drop table if exists FinalPostsToUpdategrouped;
create table FinalPostsToUpdategrouped as select post_id, 0 as newpostid, productID, NewProductID from tmpProducts where post_id not in (select post_id from FinalPostsToInsert) and post_id not in (select newpostid from FinalPostsToInsert) and post_id!=0 group by post_id;

Update FinalPostsToUpdategrouped as fu inner join FinalPostsToInsert as fi on fu.NewProductID = fi.NewProductID
set fu.newpostid = fi.newpostid;

update FinalPostsToUpdategrouped as fu inner join tmpProducts as tp on fu.NewProductID = tp.productID 
set fu.newpostid = tp.post_id where newpostid =0;

#select * from FinalPostsToUpdategrouped;

#select * from insertlistproductsfinal;

insert into wp_posts select * from Copy_wp_posts_Products where ID In 
(select post_id from FinalPostsToUpdategrouped where post_id=newpostid);


update Copy_wp_woocommerce_order_itemmeta as twpo inner join FinalPostsToUpdate as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_product_id' and twpo.meta_value!=upf.newpostid;

update Copy_wp_woocommerce_order_itemmeta as twpo inner join FinalPostsToUpdate as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_variation_id' and twpo.meta_value!=upf.newpostid;

update wp_woocommerce_order_itemmeta as twpo inner join FinalPostsToUpdategrouped as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_product_id' and twpo.meta_value!=upf.newpostid;

update wp_woocommerce_order_itemmeta as twpo inner join FinalPostsToUpdategrouped as upf 
on upf.post_id = twpo.meta_value set twpo.meta_value = upf.newpostid where twpo.meta_key = '_variation_id' and twpo.meta_value!=upf.newpostid;

#select * from Copy_wp_posts_Products;

#select * from Copy_wp_posts_Products where ID not in (select ID from wp_posts) and post_status = 'publish';

#select count(*) from wp_posts;
#select count(*) from temp_wp_posts;