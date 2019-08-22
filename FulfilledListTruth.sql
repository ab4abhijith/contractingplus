#USE kappamap_angelshaveNew_April04;

SET SQL_SAFE_UPDATES = 0;

/* ----------------------------- Get ASC Completed List Including Manual Fulfiled List --------------------------------- */

# Get ASC Completed List

#drop table if exists ASCJan10March27;
#create table ASCJan10March27 as select * from kappamap_angelshaveNew_March26.ASCJan10March27;

/* -------------- Import Manual Order CSV to table ------------
create table manualorderslist (email varchar(100), fulfileddate datetime, packagesku varchar(10), nosubscribe varchar(20));
LOAD DATA LOCAL INFILE "/home/user/AB/Projects/04 Apr/Angel Shave/SQL/csv/manualorders20Jan27Mar.csv"
            INTO TABLE `manualorderslist`
            FIELDS TERMINATED by ',' OPTIONALLY ENCLOSED BY '"'
            LINES TERMINATED BY '\n'
            IGNORE 1 LINES;
*/

/* -------------- Import Manual Order to a new table ------------ */
drop table if exists ascfilterlist;
create table ascfilterlist as select OrderNumber, OrderDate, BillingEmail, max(ItemCost) as itemcost, ItemName, SKU from ASCJan10March27 where OrderStatus = 'Completed' and BillingEmail!='' group by BillingEmail, OrderNumber;

/* -------------- Product List with SKU ------------ */
drop table if exists proddetwithskuprice;
create table proddetwithskuprice as select wp.post_title as productname, wp.post_type, wpm.meta_value as sku, wpmm.meta_value as price from wp_posts as wp inner join wp_postmeta as wpm on wpm.post_id = wp.ID
inner join wp_postmeta as wpmm on wpmm.post_id = wp.ID  
where (wp.post_type = 'product' or wp.post_type = 'product_variation') and wpm.meta_key = '_sku' and wpmm.meta_key = '_price' and wp.post_title!='';

/* -------------- Combining ASC and Manual Orders ------------ */

/*

Asc combine manual

drop table if exists ascplusmanualdetails;

create table ascplusmanualdetails as select OrderNumber, OrderDate, BillingEmail, itemcost, ItemName, SKU from ascfilterlist where BillingEmail in (select email from manualorderslist where packagesku!='')
union
select OrderNumber, OrderDate, BillingEmail, itemcost, ItemName, SKU from ascfilterlist where BillingEmail not in (select email from manualorderslist where packagesku!='')
union
select 0, fulfileddate, email, 0, '', packagesku from manualorderslist where email not in (select BillingEmail from ascfilterlist) and packagesku!='' group by email,packagesku;
*/
#select * from ascplusmanualdetails; 

/* -------------- Stripe Payment Report Filtering -------------- */

drop table if exists stripepaymentreportordered;
SET SQL_SAFE_UPDATES = 0;

create table stripepaymentreportordered as select distinct stripepaymentreport01octtomar27.*, 0 as billinginterval from stripepaymentreport01octtomar27 
where status = 'Paid' and (paymenttype = 'recurring' or description like '%-0305%' or description like '%mnts') order by customeremailmeta, createdutc;

update stripepaymentreportordered set customeremailmeta = customeremail where customeremailmeta = '' and customeremail!='';

alter table stripepaymentreportordered add column unid int primary key auto_increment;

update stripepaymentreportordered as y inner join (
select customeremailmeta from stripepaymentreportordered group by customeremailmeta having count(unid) = 1 
) as x on x.customeremailmeta = y.customeremailmeta
set billinginterval = -1;

drop table if exists customeridsstripe;
create table customeridsstripe as select customeremailmeta, max(unid) as finalbil, max(unid) - 1 as prevbil from stripepaymentreportordered where billinginterval != -1 group by customeremailmeta;

update stripepaymentreportordered as stp inner join 
(
select customeremailmeta, x.createdutc as finalbilldate, y.createdutc as prevbilldate, timestampdiff(MONTH, y.createdutc, x.createdutc) as monthinterval from customeridsstripe inner join 
(select unid, createdutc from stripepaymentreportordered) as x on customeridsstripe.finalbil = x.unid
inner join (select unid, createdutc from stripepaymentreportordered) as y on customeridsstripe.prevbil = y.unid
) as xyz on xyz.customeremailmeta = stp.customeremailmeta
set stp.billinginterval = xyz.monthinterval where stp.billinginterval!=-1;


update stripepaymentreportordered inner join comusersubscribe on comusersubscribe.useremail = stripepaymentreportordered.customeremailmeta
set stripepaymentreportordered.billinginterval = comusersubscribe._billing_interval where billinginterval<=0;

/*
update stripepaymentreportordered inner join oldusersubscribe on oldusersubscribe.useremail = stripepaymentreportordered.customeremailmeta
set stripepaymentreportordered.billinginterval = oldusersubscribe._billing_interval
where billinginterval<=0 and customeremailmeta not in (select useremail from newusersubscribe);
*/

alter table stripepaymentreportordered add column nextbillingdate datetime;

update stripepaymentreportordered as y inner join
(select createdutc, billinginterval from stripepaymentreportordered) as x
set y.nextbillingdate = DATE_ADD(y.createdutc, INTERVAL y.billinginterval MONTH) where y.billinginterval>0;


#  ---------- updating the stripepaymentreport if the date is in striprenewal by virtina
update stripepaymentreportordered as sro inner join striperenewal as str on str.useremail = sro.customeremailmeta
set sro.billinginterval=str._billing_interval, sro.nextbillingdate=str._schedule_next_payment where sro.billinginterval<=0;

#deleting the stripepaymentreport if the useremail is cancelled
delete from stripepaymentreportordered where customeremailmeta in (select useremail from cancelledemaillist);

# ----------  table without biling interval details
drop table if exists stripedatawithoutbillingintervalemail;
create table stripedatawithoutbillingintervalemail as select * from stripepaymentreportordered where billinginterval<=0;

# ----------  table with biling interval details
drop table if exists stripeuserstobebilled;
#create table stripeuserstobebilled as select id, description, createdutc, amount, fee, currency, customerid, customeremailmeta, cardid, billinginterval, max(nextbillingdate) as nextbillingdate, 'no' as reactivate
#from stripepaymentreportordered where billinginterval>0 and nextbillingdate < now() group by customeremailmeta;
create table stripeuserstobebilled as select id, description, createdutc, amount, fee, currency, customerid, customeremailmeta, cardid, billinginterval, max(nextbillingdate) as nextbillingdate, 'no' as reactivate
from stripepaymentreportordered where billinginterval>0 group by customeremailmeta;

#select * from stripeuserstobebilled;

drop table if exists stripeusersalreadybilled;
create table stripeusersalreadybilled as select * from stripeuserstobebilled where nextbillingdate > now();

#select * from stripeusersalreadybilled;

delete from stripeuserstobebilled where customeremailmeta in (select customeremailmeta from stripeusersalreadybilled);

alter table stripeuserstobebilled modify column reactivate varchar(5);

update stripeuserstobebilled as sb inner join onholdtoactive as oa on oa.useremail = sb.customeremailmeta
set reactivate = 'yes';

drop table if exists stripeusersinvirtnialist0305;
create table stripeusersinvirtnialist0305 as select * from stripeuserstobebilled where customeremailmeta in (select useremail from striperenewal);

update stripeuserstobebilled as sro inner join stripeusersinvirtnialist0305 as str on str.customeremailmeta = sro.customeremailmeta
set sro.nextbillingdate=DATE_ADD('2019-03-05 10:23:25', INTERVAL sro.billinginterval MONTH);

insert into stripeusersalreadybilled select * from stripeuserstobebilled where nextbillingdate > now();

delete from stripeuserstobebilled where customeremailmeta in (select customeremailmeta from stripeusersalreadybilled);


/* ------- Create list of users sent to client -------- */
#select * from stripeuserstobebilled;

#select sum(amount) from stripeuserstobebilled;

/*
drop table if exists stripereactivateuserlist;
create table stripereactivateuserlist as select * from stripeuserstobebilled where reactivate = 'yes';

drop table if exists stripetobill;
create table stripetobill as select * from stripeuserstobebilled where reactivate = 'no';

drop table if exists stripeusersnotsubscriberdb;
create table stripeusersnotsubscriberdb as select * from stripedatawithoutbillingintervalemail where customeremailmeta in (select user_email from temp_wp_users);

drop table if exists stripeusersmissingemaillist;
create table stripeusersmissingemaillist as  select * from stripedatawithoutbillingintervalemail where customeremailmeta not in (select user_email from temp_wp_users);
*/


/*select wpu.*, cwpo.meta_value, cwp.post_status, cwp.post_type from Copy_wp_postmeta_Order as cwpo inner join Copy_wp_posts_Order as cwp on cwp.ID = cwpo.post_id
inner join temp_wp_users as wpu on wpu.ID = cwpo.meta_value 
inner join stripedatawithoutbillingintervalemail as sub on sub.customeremailmeta = wpu.user_email
where cwpo.meta_key = '_customer_user' order by sub.customeremailmeta;
*/






/* -------------- Create Completed Subscribed user List ----------- */
#select * from stripeuserstobebilled;
#select * from stripeusersmissingemaillist;
#select * from stripeuserstobebilled;

#select * from stripeusersbillinterval;

drop table if exists stripepaymentlistusers;
create table stripepaymentlistusers as 
select wp.ID as postid, wpm.meta_value as customerid, wu.user_email as useremail, wpmm.meta_value as billinginterval, wppm.meta_value as nextpayment
from wp_posts as wp inner join wp_postmeta as wpm on wpm.post_id = wp.ID 
inner join wp_postmeta as wpmm on wpmm.post_id = wp.ID 
inner join wp_postmeta as wppm on wppm.post_id = wp.ID 
inner join wp_users as wu on wu.ID = wpm.meta_value
where wpm.meta_key = '_customer_user' and wp.post_type = 'shop_subscription' and wpmm.meta_key = '_billing_interval'
and wppm.meta_key = '_schedule_next_payment';

#select * from stripeusersalreadybilled where billinginterval<=1;

#select * from stripeuserstobebilled;
#select * from stripeusersbillinterval;
#select * from stripeusersalreadybilled;

#select * from stripeusersalreadybilled where customeremailmeta in (select customeremailmeta from stripeuserstobebilled);


drop table if exists stripebillinglistcom;
create table stripebillinglistcom as select su.postid, su.customerid, su.useremail, sb.billinginterval, sb.nextbillingdate from 
stripepaymentlistusers as su 
inner join stripeuserstobebilled as sb on sb.customeremailmeta = su.useremail where sb.billinginterval>1;

#select * from stripebillinglistcom;

insert into stripebillinglistcom select su.postid, su.customerid, su.useremail, sb.billinginterval, sb.nextbillingdate from stripepaymentlistusers as su 
inner join stripeusersalreadybilled as sb on sb.customeremailmeta = su.useremail where sb.billinginterval>1;

#select * from stripebillinglistcom;
#select * from stripebillinglistcom group by postid;
#select * from stripebillinglistcom group by useremail;

drop table if exists finalstripebillist;
create table finalstripebillist as select * from stripebillinglistcom group by customerid;

select * from finalstripebillist;

#select meta_value, U.nextbillingdate from wp_postmeta M inner join finalstripebillist  U  on  M.post_id= U.postid
#where  meta_key='_schedule_next_payment';

UPDATE wp_postmeta M inner join finalstripebillist  U  on  M.post_id= U.postid
SET meta_value = U.nextbillingdate
where  meta_key='_schedule_next_payment';

