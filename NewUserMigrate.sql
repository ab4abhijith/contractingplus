#USE kappamap_angelshaveNew_April08;

DROP TABLE if exists tmpNewUsers;
CREATE TABLE tmpNewUsers as 
SELECT Cwu.* FROM Copy_wp_users Cwu LEFT OUTER join wp_users wu
on Cwu.user_email =wu.user_email where wu.ID is  null;

DROP TABLE if exists wp_users_touppdate;
create table wp_users_touppdate as
SELECT * FROM tmpNewUsers  where ID  in  (select ID from wp_users );

DROP TABLE if exists wp_users_toinsert;
create table wp_users_toinsert as
SELECT * FROM tmpNewUsers  where ID  NOT  in  (select ID from wp_users );


INSERT INTO wp_users 
SELECT * FROM tmpNewUsers  where ID  NOT  in  (select ID from wp_users );


#Drop table if exists tmpIDChange_wp_users;
#CREate table tmpIDChange_wp_users
#SELECT * FROM wp_users_touppdate  where ID    in  (select ID from wp_users );

ALTER TABLE wp_users_touppdate add column newID int primary key auto_increment;
SET @tmpNewUserID=0;
SELECT  max(ID) from wp_users into @tmpNewUserID ;
UPDATE wp_users_touppdate set newID = newID+@tmpNewUserID;


#select * from wp_users_touppdate;
#select * from wp_users_touppdate;
#select * from wp_users_toinsert;


INSERT INTO wp_users
(ID,
user_login,
user_pass,
user_nicename,
user_email,
user_url,
user_registered,
user_activation_key,
user_status,
display_name)
SELECT 
newID,
user_login,
user_pass,
user_nicename,
user_email,
user_url,
user_registered,
user_activation_key,
user_status,
display_name
FROM 
wp_users_touppdate;


INSERT Ignore  INTO wp_usermeta
(
user_id,
meta_key,
meta_value)
Select 
newID,
'previous_user_id', # previous user id
ID
FROM wp_users_touppdate where newID<>ID;


UPDATE   Copy_wp_usermeta Cwu inner join wp_users_touppdate t on 
Cwu.user_id= t.ID
set Cwu.user_id= t.newID ;

#SELECT * FROM Copy_wp_usermeta Cwu where user_id in (select ID from wp_users_toinsert );

insert into wp_usermeta ( user_id,
meta_key,
meta_value )
SELECT user_id,
meta_key,
meta_value FROM Copy_wp_usermeta Cwu where user_id in (select ID from wp_users_toinsert );

update Copy_wp_postmeta_Order as cwpo inner join wp_users_touppdate as usd on usd.ID = cwpo.meta_value 
set cwpo.meta_value = usd.newID where cwpo.meta_key = '_customer_user';

update wp_postmeta as cwpo inner join wp_users_touppdate as usd on usd.ID = cwpo.meta_value 
set cwpo.meta_value = usd.newID where cwpo.meta_key = '_customer_user';


DROP TABLE if exists tmpwp_usermeta;
CREATE TABLE tmpwp_usermeta
SELECT distinct Cwu.* FROM Copy_wp_usermeta Cwu INNER JOIN tmpNewUsers t on Cwu.user_id=t.ID ;
ALTER TABLE tmpwp_usermeta ADD column newumeta_id int primary key auto_increment;
SET @tmpNewUMID=0;
SELECT  max(umeta_id) from wp_usermeta into @tmpNewUMID ;
UPDATE tmpwp_usermeta set newumeta_id = newumeta_id+@tmpNewUMID;

#select * from tmpwp_usermeta;

INSERT Ignore  INTO wp_usermeta
(umeta_id,
user_id,
meta_key,
meta_value)
Select 
newumeta_id,
user_id,
meta_key,
meta_value
FROM tmpwp_usermeta;
