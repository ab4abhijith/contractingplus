#CREATE TABLE ASCJan10March27 as select * FROM  kappamap_angelshaveNew_March17.ASCJan10March27
SET SQL_SAFE_UPDATES = 0;

DROP TABLE if exists ASCCustomer;

CREATE TABLE ASCCustomer as
SELECT distinct BillingEmail,
    Billinglastname,
    BillingFirstname,
    ShippingLastName,
    ShippingFirstName,
    BillingCompany,
    BillingAddress,
    BillingCity,
    BillingStateCode,
    BillingPostCode,
    BillingCountryCode,
    BillingPhone,
    ShippingAddress,
    ShippingCity,
    ShippingStateCode,
    ShippingPostcode,
    ShippingCountryCode
FROM ASCJan10March27
WHERE  BillingEmail<>''
order by BillingEmail, OrderDate asc ;

ALTER TABLE  ASCCustomer ADD  ID bigint auto_increment PRIMARY KEY;

DROP TABLE if exists tmpUniqCustomer ;
CREATE TABLE tmpUniqCustomer as 
SELECT Billingemail, max(ID) as ID FROM ASCJan10March27
WHERE Billingemail  in(
SELECT Billingemail
from ASCCustomer
WHERE  BillingEmail<>''
group by Billingemail
)
GROUP BY Billingemail;
ALTER TABLE  tmpUniqCustomer ADD  customerID bigint auto_increment PRIMARY KEY;

DROP TABLE if exists tmp_ASC_wp_usersANDmeta;
CREATE TABLE tmp_ASC_wp_usersANDmeta as
SELECT Y.ID, Y.BillingEmail,
    Billinglastname,
    BillingFirstname,
    ShippingLastName,
    ShippingFirstName,
    BillingCompany,
    BillingAddress,
    BillingCity,
    BillingStateCode,
    BillingPostCode,
    BillingCountryCode,
    BillingPhone,
    ShippingAddress,
    ShippingCity,
    ShippingStateCode,
    ShippingPostcode,
    ShippingCountryCode
    FROM ASCJan10March27 as Y inner join tmpUniqCustomer  as X
on Y.Billingemail=X.Billingemail 
#and Y.OrderDate = X.OrderDate
and Y.ID=X.ID
WHERE Y. BillingEmail<>''
order by Y.Billingemail, Y.OrderDate;


drop table if exists tmpAllProducts;
CREATE TABLE tmpAllProducts 
select distinct 0 as post_id, sku, itemname, 'ASC' as Source from ASCJan10March27
where itemname<>'';

ALter table tmpAllProducts add primary key(sku,itemname);

INSERT IGNORE INTO tmpAllProducts(post_id, sku, itemname, source)
select distinct  p.ID, meta_value, p.post_title as itemname, 'olddb' as source  FROM wp_posts p
INNER JOIN wp_postmeta  pm on
p.ID=pm.post_id
WHERE  (post_type='product_variation' or post_type = 'product') 
and meta_key='_sku'
and p.ID in 
(SELECT distinct meta_Value FROM wp_woocommerce_order_itemmeta where meta_key='_product_id' or meta_key='_variation_id');

INSERT IGNORE INTO tmpAllProducts(post_id, sku, itemname, source)
Select distinct p.ID, meta_value, p.post_title as itemname, 'Newdb' as source  FROM Copy_wp_posts_Products p
INNER JOIN Copy_wp_postmeta_Products  pm on
p.ID=pm.post_id
WHERE  (post_type='product_variation' or post_type = 'product') 
and meta_key='_sku'
and p.ID in 
(SELECT distinct meta_Value FROM Copy_wp_woocommerce_order_itemmeta where meta_key='_product_id' or meta_key='_variation_id');

ALTER TABLE tmpAllProducts DROP primary key;
ALTER TABLE  tmpAllProducts ADD  productID bigint auto_increment PRIMARY KEY;

DROP TABLE if exists tmpProducts;
CREATE Table tmpProducts as 
SELECT distinct A.sku,
    A.itemname,
    A.Source,
    A.productID,
    A.NewProductID,
    A.NewSKU,
    A.Parent,
    post_id FROM AllProducts  A INNER Join tmpAllProducts T on
A.itemname= T.itemname  where post_id >0 and
A.Source='new' And T.source='new';

INSERT INTO tmpProducts
 (sku,
    itemname,
    Source,
    productID,
    NewProductID,
    NewSKU,
    Parent,
    post_id)
SELECT distinct A.*, post_id FROM AllProducts  A INNER Join tmpAllProducts T on
A.itemname= T.itemname  where post_id >0 and
A.Source='Old' And T.source='Old';

INSERT INTO tmpProducts  (sku,
    itemname,
    Source,
    productID,
    NewProductID,
    NewSKU,
    Parent,
    post_id)
SELECT sku,
    itemname,
    Source,
    productID,
    NewProductID,
    NewSKU,
    Parent,
    0 FROM AllProducts
where productID not in (Select productID from tmpProducts);

ALTER TABLE tmpProducts add tmpID int primary key auto_increment;

DELETE t.* FROM tmpProducts t Inner join (
SELECT Count(*) , productID , min(tmpID) as tID From tmpProducts group by  productID having count(*)>1) as x 
on t.productID= x.productID
and t.tmpID= x.tID;

Update tmpProducts set parent=0 where parent=newProductID;

ALTER TABLE tmpProducts add column newSource varchar(25);

UPDATE tmpProducts tA INNER JOIN
(
SELECT  newSKU,  max(post_id) as newPostID, max(NewProductID) , max(source) as source FROM tmpProducts
WHERE #newSKU='BH' and
 source='New'
Group by newSKU
having count(*)>1
) as X
on X.newSKU= tA.newSKU
SET  tA.post_id = X.newPostID, tA.newSource= X.source 
WHERE tA.post_id=0;

drop table if exists Copy_post_postmeta_sku;

create table Copy_post_postmeta_sku as select cpw.*, cpwp.meta_value as sku from Copy_wp_posts_Products as cpw inner join Copy_wp_postmeta_Products as cpwp on
cpwp.post_id = cpw.ID where cpwp.meta_key = '_sku';

update tmpProducts as ptp inner join 
(select max(ID) as ID, post_title from Copy_post_postmeta_sku where post_status='publish' group by post_title) as cwp
on ptp.itemname = cwp.post_title 
set ptp.post_id = cwp.ID, ptp.newSource = 'New'
where ptp.post_id = 0;

update tmpProducts as ptp inner join 
(select max(ID) as ID, post_title from wp_posts where post_status='publish' group by post_title) as cwp
on ptp.itemname = cwp.post_title 
set ptp.post_id = cwp.ID, ptp.newSource = 'Old'
where ptp.post_id = 0;

update Copy_wp_posts_Products 
set post_title = replace(replace(post_title,',',' '),'  ',' ');

update tmpProducts as ptp inner join 
(select max(ID) as ID, post_title from Copy_wp_posts_Products where post_status='publish' group by post_title) as cwp
on ptp.itemname = cwp.post_title 
set ptp.post_id = cwp.ID, ptp.newSource = 'New'
where ptp.post_id = 0;

Alter table tmpProducts add column olditemname varchar(100);

update tmpProducts 
set olditemname = itemname
where post_id = 0;
update tmpProducts 
set itemname = replace(replace(itemname,'4 oz',''),'  ',' ')
where post_id = 0;

update tmpProducts 
set itemname = replace(replace(itemname,'2 oz',''),'  ',' ')
where post_id = 0;

update tmpProducts as ptp inner join 
(select max(ID) as ID, post_title from Copy_wp_posts_Products where post_status='publish' group by post_title) as cwp
on ptp.itemname = cwp.post_title 
set ptp.post_id = cwp.ID, ptp.newSource = 'New'
where ptp.post_id = 0;

update tmpProducts set newSource = Source where newSource is null;

Alter table tmpProducts add column newpostparent int;

update  tmpProducts  tp inner join tmpProducts tp1
on tp.parent=tp1.productID
set tp.newpostparent= tp1.post_id ;

UPDATE tmpProducts tA     INNER JOIN
(
SELECT  newSKU,  max(post_id) as newPostID, max(NewProductID) as maxNewProductID , max(source) as source FROM tmpProducts
WHERE #newSKU='BH'  and
 source='New'
Group by newSKU
having count(*)>1
) as X
on X.newSKU= tA.newSKU
SET  tA.newProductID=X.maxNewProductID
WHERE tA.parent<>0 ;



DELETE t from tmpProducts t INNER JOIN (
SELECT tp.post_id as tPostID, tp.tmpID as tID FROM tmpProducts tp inner join ( 
SELECT  post_id, min(tmpID) mxtmpID from tmpProducts
WHERE parent<>0
group by post_id
having count(productID)>1) as X
on tp.post_id= X.post_id
and tp.tmpID<> X.mxtmpID ) as Y
on Y.tPostID= t.post_id
and Y.tID=t.tmpID;
drop table if exists posttoinsert;

create table posttoinsert as select max(post_id) as newpostid, tmpProducts.* from tmpProducts group by NewSKU;
DROP TABLE if exists FinalPostsToInsert;
CREATE TABLE FinalPostsToInsert as 
SELECT pi1.* from posttoinsert pi1 inner join(
SELECT newpostid, max(tmpID) as MaxTmpID from posttoinsert
group by newpostid) pi2
on pi1.tmpID= pi2.MaxTmpID;
UPDATE FinalPostsToInsert Set newpostparent=0 where newpostparent is null;



