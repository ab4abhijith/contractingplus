
drop table if exists comsubscriptiontableuser;
drop table if exists comsubscriptiontablewithoutuser;
#CREATE INDEX idxcomusertable on comusertable(userid);

#alter table comsubscriptiontable add index (_customer_user);
#alter table comusertable add index (userid);

create table comsubscriptiontableuser as 
select * from comsubscriptiontable  S
INNER JOIN comusertable U  on S._customer_user = U.userid;

#select distinct S.postid, U.useremail, U.userid from comsubscriptiontable  S
#INNER JOIN comusertable U  on S._customer_user = U.userid;

#select * from comsubscriptiontable;
#select * from comusertable;

#select count(distinct useremail) from comsubscriptiontableuser ;
#select count(distinct userid) from comsubscriptiontablewithoutuser;

#select * from comsubscriptiontable where _customer_user not in (select userid from comusertable);

create table comsubscriptiontablewithoutuser as 
select * from comsubscriptiontable  S LEFT OUTER JOIN  comusertable U
on S._customer_user=U.userid Where U.userid IS null;

#select * from comsubscriptiontablewithoutuser;

drop table if exists userlistwithoutids;
create table userlistwithoutids (useremail varchar(50));
insert into userlistwithoutids select meta_value as useremail from wp_postmeta where post_id in (select postid from comsubscriptiontablewithoutuser) and meta_key = 'billing_email';

drop table if exists userwithoutemaildetails;

create table userwithoutemaildetails as select * from wp_users where user_email in ( select useremail from userlistwithoutids );

select * from wp_users where user_email in ( select useremail from userlistwithoutids );

select * from userwithoutemaildetails;

drop table if exists anonymoususer; 

create table anonymoususer as select distinct useremail from userlistwithoutids where useremail not in ( select user_email from userwithoutemaildetails );

#create table oldcomsubscriptiontablewithoutuser as select * from comsubscriptiontablewithoutuser where _customer_user in (select ID from wp_users);

#select * from comsubscriptiontableuser;
#select * from comsubscriptiontablewithoutuser;

#select * from wp_posts where ID in (select postid from comsubscriptiontablewithoutuser) and post_status='wc-active';

select * from comsubscriptiontable;
select * from comusertable;

drop table if exists usersubcomlist;
create table usersubcomlist as select * from comsubscriptiontable as cst inner join comusertable as cut 
on cut.userid = cst._customer_user;

select * from usersubcomlist;

#select count(*) from wp_users where ID in (select userid from usersubcomlist) and user_email in (select useremail from usersubcomlist);

#select count(*) from usersubcomlist where userid in (select ID from wp_users) and useremail in (select user_email from wp_users);

/*
drop table if exists olduserwithidemail;
create table olduserwithidemail as select * from usersubcomlist where userid in (select ID from wp_users) and useremail in (select user_email from wp_users);
drop table if exists olduserwithoutemail;
create table olduserwithoutemail as select * from usersubcomlist where userid not in (select ID from wp_users) and useremail in (select user_email from wp_users);
drop table if exists olduserwithoutidemail;
create table olduserwithoutidemail as select * from usersubcomlist where userid not in (select ID from wp_users) and useremail not in (select user_email from wp_users);
*/

drop table if exists olduserwithidemail;
create table olduserwithidemail as select ID as userid, user_email as useremail from wp_users where ID in (select userid from usersubcomlist) and user_email in (select useremail from usersubcomlist);
drop table if exists olduserwithoutemail;
create table olduserwithoutemail as select ID as userid, user_email as useremail from wp_users where ID not in (select userid from usersubcomlist) and user_email in (select useremail from usersubcomlist);
drop table if exists olduserwithoutidemail;
create table olduserwithoutidemail as select ID as userid, user_email as useremail  from wp_users where ID not in (select userid from usersubcomlist) and user_email not in (select useremail from usersubcomlist);



select count(*) from usersubcomlist;

select count(*) from wp_users;

select count(*) from olduserwithidemail;

select count(*) from olduserwithoutemail;

select count(*) from olduserwithoutidemail;
/*
select count(*) from newuserwithidemail;

select count(*) from newuserwithoutemail;

select count(*) from newuserwithoutidemail;
*/
select * from olduserwithidemail; # Both ID and Email Matches
select * from olduserwithoutemail; # EMAIL of OLD DB matches with New but ID does not match
select * from olduserwithoutidemail; # Both ID and Email are not matching
