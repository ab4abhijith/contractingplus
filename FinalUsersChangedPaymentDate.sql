 # Date to be changed Using stripe data

DROP TABLE if exists tmpPM;
	CREATE TABLE tmpPM as
	SELECT distinct cwpO.ID as OrderID ,Cwu.user_email , post_status, Cwu.ID as userID
	 FROM wp_posts cwpO INNER JOIN   wp_postmeta  cwpmO on cwpO.ID=cwpmO.post_id
	 INNER JOIN wp_users Cwu on  cwpmO.meta_value = Cwu.ID 
	 where post_type='shop_subscription' and meta_key='_customer_user';
	CREATE INDEX idx on tmpPM(OrderID);

	Drop table if exists tmpReqManaulTrues;
	CREATE TABLE tmpReqManaulTrues as
	SELECT  post_id as orderID,userID,  user_email, meta_key, meta_value,post_status 
	FROM wp_postmeta pm  inner join   tmpPM t
	   on pm.post_id =t.OrderID
	   where  meta_key ='_requires_manual_renewal'
	   and meta_value='false'
	   and post_status in (  'wc-active' )
	   Order by  2;
	   
	   CREATE INDEX idx1 on  tmpReqManaulTrues(OrderID);
	   CREATE INDEX idx2 on  tmpReqManaulTrues(userID);
	   CREATE INDEX idx3 on  tmpReqManaulTrues(post_status);
       
       Drop table if exists tmpReqManaulTruesWithBIPaymentDate;
	CREATE TABLE tmpReqManaulTruesWithBIPaymentDate as
	Select distinct  t.*,PM.meta_value as NextBillingDate, PM1.meta_value as billing_interval  from wp_postmeta PM INNER JOIN tmpReqManaulTrues t on t.OrderID=PM.post_id
	INNER JOIN wp_postmeta PM1 on  t.OrderID=PM1.post_id
	where PM.meta_key='_schedule_next_payment'
	and PM1.meta_key='_billing_interval';

	 CREATE INDEX idx1 on  tmpReqManaulTruesWithBIPaymentDate( user_email);
	 CREATE INDEX idx2 on  stripepaymentreport01octtomar27( customeremail);
	 
     DROP TABLE if exists tmpTobeProcessedSinglOrders;
     Create table tmpTobeProcessedSinglOrders
	 SELECT U.* , status, sellermessage, createdutc, sellermessage ,description
	 , trim(replace(description,'Angel Shave Club - Order','')) as OrdeIDFromStripe FROM tmpReqManaulTruesWithBIPaymentDate 
	 as U inner join stripepaymentreport01octtomar27 S
	 on U.user_email=customeremail
	 where status ='paid' and NextBillingDate <=now();
     
     CREate index idx1 on tmpTobeProcessedSinglOrders(orderid);

select * from tmpTobeProcessedSinglOrders;

#select M.meta_value, DATE_ADD(Now(), INTERVAL 3 day) from wp_postmeta M inner join tmpTobeProcessedSinglOrders  U  on  M.post_id= U.orderID
#where  M.meta_key='_schedule_next_payment';

UPDATE wp_postmeta M inner join tmpTobeProcessedSinglOrders  U  on  M.post_id= U.orderID
SET M.meta_value =DATE_ADD(Now(), INTERVAL 3 day)
where  M.meta_key='_schedule_next_payment';
  

  
drop table if exists tblsingleorderactivated;
create table tblsingleorderactivated as 
select ID, post_status, concat('{"subscription_id":',ID,'}') as post_content from wp_posts where ID in (select orderID from tmpTobeProcessedSinglOrders);

select * from tblsingleorderactivated;

ALTER TABLE tblsingleorderactivated MODIFY
    post_content VARCHAR(50)
      CHARACTER SET utf8
      COLLATE utf8_unicode_ci;

drop table if exists tblsingleorderactivatedchedule;

create table tblsingleorderactivatedchedule as
select wp.* from wp_posts as wp inner join tblsingleorderactivated as sp on sp.post_content = wp.post_content 
where wp.post_type='scheduled-action';

select * from tblsingleorderactivatedchedule;


alter table tblsingleorderactivatedchedule add index (ID);

update wp_posts set post_status = 'pending' where ID in (select ID from tblsingleorderactivatedchedule);

update wp_postmeta as p inner join tblsingleorderactivatedchedule as o on o.ID = p.post_id
set meta_value = 
concat('O:30:"ActionScheduler_SimpleSchedule":1:{s:41:"ActionScheduler_SimpleScheduletimestamp";s:10:"',unix_timestamp(DATE_ADD(Now(), INTERVAL 3 day)),'";}')
where p.meta_key = '_action_manager_schedule';
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 # All Data processed irrespective of stripe data
 
 DROP TABLE if exists tmpPM;
	CREATE TABLE tmpPM as
	SELECT distinct cwpO.ID as OrderID ,Cwu.user_email , post_status, Cwu.ID as userID
	 FROM wp_posts cwpO INNER JOIN   wp_postmeta  cwpmO on cwpO.ID=cwpmO.post_id
	 INNER JOIN wp_users Cwu on  cwpmO.meta_value = Cwu.ID 
	 where post_type='shop_subscription' and meta_key='_customer_user';
	CREATE INDEX idx on tmpPM(OrderID);

	Drop table if exists tmpReqManaulTrues;
	CREATE TABLE tmpReqManaulTrues as
	SELECT  post_id as orderID,userID,  user_email, meta_key, meta_value,post_status 
	FROM wp_postmeta pm  inner join   tmpPM t
	   on pm.post_id =t.OrderID
	   where  meta_key ='_requires_manual_renewal'
	   and meta_value='false'
	   and post_status in (  'wc-active' )
	   Order by  2;
	   
	   CREATE INDEX idx1 on  tmpReqManaulTrues(OrderID);
	   CREATE INDEX idx2 on  tmpReqManaulTrues(userID);
	   CREATE INDEX idx3 on  tmpReqManaulTrues(post_status);
       
       
       Drop table if exists tmpReqManaulTruesWithBIPaymentDate;
	CREATE TABLE tmpReqManaulTruesWithBIPaymentDate as
	Select distinct  t.*,PM.meta_value as NextBillingDate, PM1.meta_value as billing_interval  from wp_postmeta PM INNER JOIN tmpReqManaulTrues t on t.OrderID=PM.post_id
	INNER JOIN wp_postmeta PM1 on  t.OrderID=PM1.post_id
	where PM.meta_key='_schedule_next_payment'
	and PM1.meta_key='_billing_interval';

	 CREATE INDEX idx1 on  tmpReqManaulTruesWithBIPaymentDate( user_email);
	 CREATE INDEX idx2 on  stripepaymentreport01octtomar27( customeremail);
	 
     DROP TABLE if exists tmpTobeProcessedSinglOrders;
     Create table tmpTobeProcessedSinglOrders
	 SELECT t.* 
	  FROM tmpReqManaulTruesWithBIPaymentDate  t
	 where  NextBillingDate <=now();
     
	CREate index idx1 on tmpTobeProcessedSinglOrders(orderid);
 
 select * from tmpTobeProcessedSinglOrders;

#select M.meta_value, DATE_ADD(Now(), INTERVAL 3 day) from wp_postmeta M inner join tmpTobeProcessedSinglOrders  U  on  M.post_id= U.orderID
#where  M.meta_key='_schedule_next_payment';

UPDATE wp_postmeta M inner join tmpTobeProcessedSinglOrders  U  on  M.post_id= U.orderID
SET M.meta_value =DATE_ADD(Now(), INTERVAL 3 day)
where  M.meta_key='_schedule_next_payment';
  

  
drop table if exists tblsingleorderactivated;
create table tblsingleorderactivated as 
select ID, post_status, concat('{"subscription_id":',ID,'}') as post_content from wp_posts where ID in (select orderID from tmpTobeProcessedSinglOrders);

select * from tblsingleorderactivated;

ALTER TABLE tblsingleorderactivated MODIFY
    post_content VARCHAR(50)
      CHARACTER SET utf8
      COLLATE utf8_unicode_ci;

drop table if exists tblsingleorderactivatedchedule;

create table tblsingleorderactivatedchedule as
select wp.* from wp_posts as wp inner join tblsingleorderactivated as sp on sp.post_content = wp.post_content 
where wp.post_type='scheduled-action';

select * from tblsingleorderactivatedchedule;


alter table tblsingleorderactivatedchedule add index (ID);

update wp_posts set post_status = 'pending' where ID in (select ID from tblsingleorderactivatedchedule);

update wp_postmeta as p inner join tblsingleorderactivatedchedule as o on o.ID = p.post_id
set meta_value = 
concat('O:30:"ActionScheduler_SimpleSchedule":1:{s:41:"ActionScheduler_SimpleScheduletimestamp";s:10:"',unix_timestamp(DATE_ADD(Now(), INTERVAL 3 day)),'";}')
where p.meta_key = '_action_manager_schedule';
