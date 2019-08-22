
create table wp_users_backup as select * from wp_users;
create table wp_usermeta_backup as select * from wp_usermeta;

delete from wp_users;
insert into wp_users select * from temp_wp_users;
delete from wp_usermeta;
insert into wp_usermeta select * from temp_wp_usermeta;

delete from wp_usermeta where user_id not in (select distinct ID from wp_users);

