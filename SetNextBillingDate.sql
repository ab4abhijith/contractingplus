DROP TABLE if exists tmpActiveSubID;
Create table tmpActiveSubID as
select distinct U.ID as activeSubID, W.ID as orderID from  wp_users  U
inner join wp_postmeta M on U.ID= M.meta_value
inner join wp_posts  W on W.ID= M.post_id
where user_status='wc_active'
and meta_key='_customer_user'
and post_type='shop_subscription';

CReate index idxsubid on tmpActiveSubID(ActiveSubID);

DROP TABLE If exists tmpBillingInterval;
CReate table tmpBillingInterval as
select distinct activeSubID, meta_value as  billing_interval, orderID from  tmpActiveSubID
inner join wp_postmeta M on post_id=orderID
where  meta_key='_billing_interval';

DROP TABLE If exists tmpLastPayment;
CReate table tmpLastPayment
select distinct activeSubID, meta_value as  nextpaymentdate ,  orderID from  tmpActiveSubID U
inner join wp_postmeta M on post_id= orderID
where  meta_key='_schedule_next_payment';



DROP TABLE if exists tblActiveSubWithBillingDate;
Create table tblActiveSubWithBillingDate
as select LP. ActiveSubID, nextpaymentdate, billing_interval,  LP.orderID FROM tmpLastPayment LP INNER JOIN tmpBillingInterval BI 
on LP.orderID=BI.orderID;

CREATE INDex idxOID on tblActiveSubWithBillingDate(orderID);
CREATE INDex idxLPID on tblActiveSubWithBillingDate(ActiveSubID);


#SELECT * FROM  tblActiveSubWithBillingDate where  Timestampdiff(Month,nextpaymentdate,Now()) >=billing_interval;

#SELECT nextpaymentdate,  meta_value , orderid, activesubid, billing_interval, DATE_ADD(Now(), INTERVAL 3 day) 
#FROM  wp_postmeta M inner join tblActiveSubWithBillingDate  U  on  M.post_id= U.orderID
#where  meta_key='_schedule_next_payment'
#AND  Timestampdiff(Month,nextpaymentdate,Now()) >=billing_interval;
#AND billing_interval<=0

  UPDATE wp_postmeta M inner join tblActiveSubWithBillingDate  U  on  M.post_id= U.orderID
SET meta_value =DATE_ADD(Now(), INTERVAL 3 day)
where  meta_key='_schedule_next_payment' and
  Timestampdiff(Month,nextpaymentdate,Now()) >=billing_interval;
  
  UPDATE wp_postmeta M inner join tblActiveSubWithBillingDate  U  on  M.post_id= U.orderID
SET meta_value =DATE_ADD(Now(), INTERVAL 3 day)
where  meta_key='_schedule_next_payment' and nextpaymentdate = 0;
  
  
  select * from tblActiveSubWithBillingDate;
  
  
drop table if exists tblActiveSubWithBillingDateactivated;
create table tblActiveSubWithBillingDateactivated as 
select ID, post_status, concat('{"subscription_id":',ID,'}') as post_content from wp_posts where ID in (select orderID from tblActiveSubWithBillingDate);

select * from tblActiveSubWithBillingDateactivated;

ALTER TABLE tblActiveSubWithBillingDateactivated MODIFY
    post_content VARCHAR(50)
      CHARACTER SET utf8
      COLLATE utf8_unicode_ci;

create table tblActiveSubWithBillingDateschedule as
select wp.* from wp_posts as wp inner join tblActiveSubWithBillingDateactivated as sp on sp.post_content = wp.post_content 
where wp.post_type='scheduled-action';

select * from tblActiveSubWithBillingDateschedule;


alter table tblActiveSubWithBillingDateschedule add index (ID);

update wp_posts set post_status = 'pending' where ID in (select ID from tblActiveSubWithBillingDateschedule);

update wp_postmeta as p inner join tblActiveSubWithBillingDateschedule as o on o.ID = p.post_id
set meta_value = 
concat('O:30:"ActionScheduler_SimpleSchedule":1:{s:41:"ActionScheduler_SimpleScheduletimestamp";s:10:"',unix_timestamp(DATE_ADD(Now(), INTERVAL 3 day)),'";}')
where p.meta_key = '_action_manager_schedule';
 
  
/*
 select * from tblActiveSubWithBillingDate; 


drop table if exists actionmanager;
create table actionmanager as select ID, post_status, concat('{"subscription_id":',ID,'}') as post_content from wp_posts 
where ID in (select orderid from striperenewal);
select * from actionmanager;

 
 create table actionmanageraction as
select wp.* from wp_posts as wp inner join specialonhold as sp on sp.post_content = wp.post_content 
where wp.post_type='scheduled-action';

update wp_posts set post_status = concat(post_status,'-onhold') where ID in (select ID from specialonholdaction);

update wp_postmeta set 
  
 select meta_value from  wp_postmeta where  meta_key='_schedule_next_payment'; 
 
 */
 

