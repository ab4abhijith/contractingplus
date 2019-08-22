SET SQL_SAFE_UPDATES = 0;


/*


create table wp_users_backup as select * from wp_users;
create table wp_usermeta_backup as select * from wp_usermeta;

drop table if exists olduserwithidemail;

create table olduserwithidemail as select * from olduserwithidemail;

drop table if exists olduserwithoutemail;

create table olduserwithoutemail as select * from olduserwithoutemail;

drop table if exists olduserwithoutidemail;

create table olduserwithoutidemail as select * from olduserwithoutidemail;

select * from olduserwithidemail;

select * from olduserwithoutemail;

select * from olduserwithoutidemail;

drop table if exists temp_wp_users;
*/
#show create table wp_users;

drop table if exists temp_wp_users;

CREATE TABLE `temp_wp_users` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(255) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(255) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT '0',
  `display_name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`),
  KEY `user_email` (`user_email`)
);

insert into temp_wp_users select * from wp_users;

drop table if exists temp_wp_usermeta;

#show create table wp_usermeta;

CREATE TABLE `temp_wp_usermeta` (
  `umeta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext,
  PRIMARY KEY (`umeta_id`),
  KEY `user_id` (`user_id`),
  KEY `meta_key` (`meta_key`(191))
);

insert into temp_wp_usermeta select * from wp_usermeta;


drop table if exists wp_users_new;

create table wp_users_new select * from Copy_wp_users;

drop table if exists wp_usermeta_new;

create table wp_usermeta_new select * from Copy_wp_usermeta;



#select distinct user_id from wp_usermeta_new;
#select distinct user_id from wp_usermeta_new where meta_key = 'wp_capabilities';

#select * from Copy_wp_users;

#select * from wp_users_new;
#select * from wp_users_new;

#select count(*) from wp_users_new as wpun inner join olduserwithidemail as ouwe on wpun.ID = ouwe.ID;

drop table if exists userdetupdate;

create table userdetupdate as select wpun.* from wp_users_new as wpun inner join olduserwithidemail as ouwe on wpun.ID = ouwe.userid;

#select * from userdetupdate;

#select * from temp_wp_users as twp inner join userdetupdate as udu on udu.ID = twp.ID;

#select count(*) from userdetupdate;

#select count(*) from temp_wp_users as twp inner join userdetupdate as udu on udu.ID = twp.ID;

alter table temp_wp_users add index (ID);
alter table temp_wp_users add index (user_email);


#select * from temp_wp_users;

update temp_wp_users as twp inner join userdetupdate as udu on udu.ID = twp.ID
set twp.user_pass = udu.user_pass, twp.user_nicename = udu.user_nicename, twp.display_name = udu.display_name;


alter table temp_wp_usermeta add index (user_id);
alter table userdetupdate add index (ID);

#select * from temp_wp_usermeta where user_id in (select ID from userdetupdate);

#select * from temp_wp_usermeta where user_id in (select ID from temp_wp_users);

#select count(*) from temp_wp_usermeta where user_id in (select ID from userdetupdate);

#select count(*) from temp_wp_usermeta where user_id in (select ID from temp_wp_users);

drop table if exists usermetaupdatelst;

alter table userdetupdate add index (ID);
alter table wp_usermeta_new add index (user_id);

create table usermetaupdatelst as select * from wp_usermeta_new where user_id in (select ID from userdetupdate);

#select * from usermetaupdatelst;

#select * from usermetaupdatelst where user_id not in (select ID from userdetupdate);

#select twpu.meta_value, num.meta_value from temp_wp_usermeta as twpu inner join usermetaupdatelst as num on num.user_id = twpu.user_id
#where num.meta_key = twpu.meta_key;


#update temp_wp_usermeta as twpu inner join usermetaupdatelst as num on num.user_id = twpu.user_id
#set twpu.meta_value = num.meta_value where num.meta_key = twpu.meta_key and num.meta_key != 'wp_capabilities';

delete from temp_wp_usermeta where user_id in (select ID from userdetupdate) and meta_key != 'wp_capabilities';

insert into temp_wp_usermeta (user_id, meta_key, meta_value) 
select user_id, meta_key, meta_value from usermetaupdatelst where meta_key != 'wp_capabilities';


#select * from olduserwithoutidemail;

#select * from olduserwithoutidemail as ouwe inner join wp_users_new as wpn on wpn.ID = ouwe.userid;

#select * from olduserwithoutidemail as ouwe inner join temp_wp_users as wpn on wpn.ID = ouwe.userid;

#select count(*) from olduserwithoutidemail;

#select count(*) from olduserwithoutidemail as ouwe inner join wp_users_new as wpn on wpn.ID = ouwe.ID;

drop table if exists userstoimport;

create table userstoimport as select wpn.* from olduserwithoutidemail as ouwe inner join wp_users_new as wpn on wpn.ID = ouwe.userid;

#select * from userstoimport;
#select t1.* FROM temp_wp_users t1, temp_wp_users t2 WHERE t1.ID < t2.ID AND t1.user_email = t2.user_email;

#select count(*) from userstoimport;

#select * from temp_wp_users where ID in (select ID from userstoimport);

#select count(*) from temp_wp_users where ID in (select ID from userstoimport);

drop table if exists usermetatoimport;

create table usermetatoimport as select wpn.* from olduserwithoutidemail as ouwe inner join wp_usermeta_new as wpn on wpn.user_id = ouwe.userid;

#select * from usermetatoimport;

#select * from userstoimport;

insert ignore into temp_wp_users select * from userstoimport;

insert ignore into temp_wp_usermeta select * from usermetatoimport;

#select count(*) from wp_users;
#select count(*) from temp_wp_users;

#select distinct meta_key from temp_wp_usermeta;

#select count(*) from temp_wp_users;
#select count(DISTINCT user_email) from temp_wp_users;

#select * from temp_wp_users order by user_email; 

#select * from temp_wp_users where user_email = 'wssrbchdevany12@aol.com'; 

#select * from wp_users where user_email = 'wssrbchdevany12@aol.com'; 

#select * from wp_users_new where user_email = 'wssrbchdevany12@aol.com'; 

#Alter table ASCJan10March15 add index (BillingEmail text);
#Alter table ASCJan10March27 add index (BillingEmail);

drop table if exists userwitoutidsandemail;

create table userwitoutidsandemail as select distinct BillingEmail from ASCJan10March27 where BillingEmail not in (select user_email from temp_wp_users);

drop table if exists userwitidsandemail;

create table userwitidsandemail as select distinct user_email from Copy_wp_users where user_email in (select distinct BillingEmail from ASCJan10March27 where BillingEmail not in (select user_email from temp_wp_users));

#select * from userwitoutidsandemail;

#select * from userwitidsandemail;

drop table if exists userwithidnonsubscriber;

create table userwithidnonsubscriber as select nwpu.* from wp_users_new as nwpu inner join userwitidsandemail as uwe on uwe.user_email = nwpu.user_email;

insert into temp_wp_users select nwpu.* from wp_users_new as nwpu inner join userwitidsandemail as uwe on uwe.user_email = nwpu.user_email;

#select nwum.user_id, nwum.meta_key, nwum.meta_value from wp_usermeta_new as nwum inner join userwithidnonsubscriber as nonsid on nonsid.ID = nwum.user_id;

insert into temp_wp_usermeta (user_id, meta_key, meta_value) 
select nwum.user_id, nwum.meta_key, nwum.meta_value from wp_usermeta_new as nwum inner join userwithidnonsubscriber as nonsid 
on nonsid.ID = nwum.user_id;

#select * from userwitoutidsandemail where BillingEmail in (select user_email from userwitidsandemail);

drop table if exists listuserwoidandemail;

create table listuserwoidandemail as select * from userwitoutidsandemail where BillingEmail not in (select user_email from userwitidsandemail);

#select * from wp_users where user_email in (select BillingEmail from listuserwoidandemail);

#select * from Copy_wp_users where user_email in (select BillingEmail from listuserwoidandemail);

drop table if exists userupdatedeldet;

create table userupdatedeldet as select t1.ID, t1.user_email as useremail FROM temp_wp_users t1, temp_wp_users t2 WHERE t1.ID < t2.ID AND t1.user_email = t2.user_email;

#select * from userupdatedeldet;

drop table if exists userupdatedeldetails;

create table userupdatedeldetails as select ud.ID as olduserid, tu.ID as newuserid, tu.user_email as useremail from temp_wp_users tu inner join userupdatedeldet ud on ud.useremail = tu.user_email 
where tu.ID != ud.ID;

#select * from userupdatedeldetails;

#select * from Copy_wp_postmeta_Order where meta_key = '_customer_user' and meta_value in (select olduserid from userupdatedeldetails); 

#select cwpo.meta_value, usd.newuserid from Copy_wp_postmeta_Order as cwpo inner join userupdatedeldetails as usd on usd.olduserid = cwpo.meta_value where 
#cwpo.meta_key = '_customer_user';

update Copy_wp_postmeta_Order as cwpo inner join userupdatedeldetails as usd on usd.olduserid = cwpo.meta_value 
set cwpo.meta_value = usd.newuserid where cwpo.meta_key = '_customer_user';

update wp_postmeta as cwpo inner join userupdatedeldetails as usd on usd.olduserid = cwpo.meta_value 
set cwpo.meta_value = usd.newuserid where cwpo.meta_key = '_customer_user';

#select * from Copy_wp_postmeta_Order where meta_value in (select olduserid from userupdatedeldetails) and meta_key='_customer_user';

delete from temp_wp_users where ID in (select olduserid from userupdatedeldetails);

delete from temp_wp_usermeta where user_id in (select olduserid from userupdatedeldetails);


select * from temp_wp_usermeta;

select * from temp_wp_usermeta as usrm inner join wp_users as usr on usr.ID = usrm.user_id 
where usrm.meta_key = 'wp_capabilities' and meta_value = 'a:1:{s:10:"subscriber";b:1;}';

#select * from temp_wp_users where ID in (select newuserid from userupdatedeldetails);

#select * from temp_wp_users;
#select * from temp_wp_usermeta;


#select * from temp_wp_usermeta as usrm inner join wp_users as usr on usr.ID = usrm.user_id #
#where usrm.meta_key = 'wp_capabilities' and meta_value = 'a:1:{s:10:"subscriber";b:1;}';

#Uncomment these lines to import after status changer

/*

#create table wp_users_backup as select * from wp_users;
#create table wp_usermeta_backup as select * from wp_usermeta;

#truncate wp_users;
#insert into wp_users select * from wp_users_backup;
#truncate wp_usermeta;
#insert into wp_usermeta select * from wp_usermeta_backup;

truncate wp_users;
insert into wp_users select * from temp_wp_users;
truncate wp_usermeta;
insert into wp_usermeta select * from temp_wp_usermeta;

delete from wp_usermeta where user_id not in (select distinct ID from wp_users);

*/

#select count(*) from wp_users;
#select count(*) from wp_usermeta;

#select count(*) from wp_users_backup;
#select count(*) from wp_usermeta_backup;


#SELECT * FROM tmpNewUsers  where ID    in  ( select ID from wp_users );

#create table wp_users_backup as select * from wp_users;
#create table wp_usermeta_backup as select * from wp_usermeta;

#select * from Copy_wp_users where ID not in (select ID from temp_wp_users);

#alter table temp_wp_users add index(user_email); 
#alter table Copy_wp_users add index(user_email); 

#select * from Copy_wp_users where user_email not in (select user_email from temp_wp_users);

#Uncomment these lines to import after status changer

/*

#create table wp_users_backup as select * from wp_users;
#create table wp_usermeta_backup as select * from wp_usermeta;

delete from wp_users;
insert into wp_users select * from temp_wp_users;
delete from wp_usermeta;
insert into wp_usermeta select * from temp_wp_usermeta;

delete from wp_usermeta where user_id not in (select distinct ID from wp_users);

*/

#create table wp_users_backup_new as select * from wp_users;
#create table wp_usermeta_backup_new as select * from wp_usermeta;

#create table wp_users_newdb as select * from wp_users;
#create table wp_usermeta_newdb as select * from wp_usermeta;




#create table wp_users_backup_new as select * from wp_users;
#create table wp_usermeta_backup_new as select * from wp_usermeta;

#truncate wp_users;
#truncate wp_usermeta;
#insert into wp_users select * from wp_users_backup_new;
#insert into wp_usermeta select * from wp_usermeta_backup_new;

