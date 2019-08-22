#run this in new and old DB
#When run on the new DB make sure the last statment in this SQL is commented out
/*
DROP table if exists Orphan_wp_posts;
create table Orphan_wp_posts as select  wp_posts.*  FROM wp_posts
LEFT JOIN wp_posts child ON (wp_posts.post_parent = child.ID)
WHERE (wp_posts.post_parent <> 0) AND (child.ID IS NULL);

DELETE wp_posts FROM wp_posts
LEFT JOIN wp_posts child ON (wp_posts.post_parent = child.ID)
WHERE (wp_posts.post_parent <> 0) AND (child.ID IS NULL);

Drop table if exists Orphan_wp_postmeta;
create table Orphan_wp_postmeta as select  wp_postmeta.*  FROM wp_postmeta
LEFT JOIN wp_posts ON (wp_postmeta.post_id = wp_posts.ID)
WHERE (wp_posts.ID IS NULL);

DELETE wp_postmeta FROM wp_postmeta
LEFT JOIN wp_posts ON (wp_postmeta.post_id = wp_posts.ID)
WHERE (wp_posts.ID IS NULL);

Drop table if exists Orphan_wp_term_taxonomy;
create table Orphan_wp_term_taxonomy Select wp_term_taxonomy.* FROM wp_term_taxonomy
LEFT JOIN wp_terms ON (wp_term_taxonomy.term_id = wp_terms.term_id)
WHERE (wp_terms.term_id IS NULL);
DELETE wp_term_taxonomy FROM wp_term_taxonomy
LEFT JOIN wp_terms ON (wp_term_taxonomy.term_id = wp_terms.term_id)
WHERE (wp_terms.term_id IS NULL);


Drop table if exists Orphan_wp_term_relationships;
create table Orphan_wp_term_relationships as  select wp_term_relationships.* FROM wp_term_relationships
LEFT JOIN wp_term_taxonomy
	ON (wp_term_relationships.term_taxonomy_id = wp_term_taxonomy.term_taxonomy_id)
WHERE (wp_term_taxonomy.term_taxonomy_id IS NULL);

DELETE wp_term_relationships FROM wp_term_relationships
LEFT JOIN wp_term_taxonomy
	ON (wp_term_relationships.term_taxonomy_id = wp_term_taxonomy.term_taxonomy_id)
WHERE (wp_term_taxonomy.term_taxonomy_id IS NULL);

Drop table if exists Orphan_wp_usermeta;
create table Orphan_wp_usermeta as select wp_usermeta.* FROM wp_usermeta
LEFT JOIN wp_users ON (wp_usermeta.user_id = wp_users.ID)
WHERE (wp_users.ID IS NULL);

DELETE wp_usermeta FROM wp_usermeta
LEFT JOIN wp_users ON (wp_usermeta.user_id = wp_users.ID)
WHERE (wp_users.ID IS NULL);

Drop table if exists Orphan_wp_users;
create table Orphan_wp_users as select wp_users.* FROM wp_users
LEFT JOIN wp_usermeta ON (wp_users.ID = wp_usermeta.user_id)
WHERE (wp_usermeta.user_id IS NULL);
 DELETE wp_users  FROM wp_users
LEFT JOIN wp_usermeta ON (wp_users.ID = wp_usermeta.user_id)
WHERE (wp_usermeta.user_id IS NULL);

Drop table if exists Orphan_wp_posts;
create table Orphan_wp_posts as select wp_posts.* FROM wp_posts
LEFT JOIN wp_users ON (wp_posts.post_author = wp_users.ID)
WHERE (wp_users.ID IS NULL);

DELETE wp_posts FROM wp_posts
LEFT JOIN wp_users ON (wp_posts.post_author = wp_users.ID)
WHERE (wp_users.ID IS NULL);

/*
SELECT *,COUNT(*) AS keycount
FROM wp_postmeta
GROUP BY post_id,meta_key
HAVING (COUNT(*) > 1);
Drop table if exists dup_wp_postmeta;
create table dup_wp_postmeta as select wp_postmeta.* FROM  wp_postmeta
WHERE (meta_id IN (
	SELECT * FROM (
		SELECT meta_id
		FROM wp_postmeta tmp
		GROUP BY post_id,meta_key
		HAVING (COUNT(*) > 1)
	) AS tmp
));

DELETE FROM wp_postmeta
WHERE (meta_id IN (
	SELECT * FROM (
		SELECT meta_id
		FROM wp_postmeta tmp
		GROUP BY post_id,meta_key
		HAVING (COUNT(*) > 1)
	) AS tmp
));
/*
SELECT * FROM wp_posts
LEFT JOIN wp_postmeta ON (
	(wp_posts.ID = wp_postmeta.post_id) AND
	(wp_postmeta.meta_key = '_wp_attached_file')
)
WHERE (wp_posts.post_type = 'attachment') AND (wp_postmeta.meta_id IS NULL);

SELECT * FROM wp_posts
LEFT JOIN wp_postmeta ON (
	(wp_posts.ID = wp_postmeta.post_id) AND
	(wp_postmeta.meta_key = '_wp_attachment_metadata')
)
WHERE (wp_posts.post_type = 'attachment') AND (wp_postmeta.meta_id IS NULL);

*/

DELETE a,b,c
 FROM wp_posts a
 LEFT JOIN wp_term_relationships b ON ( a.ID = b.object_id)
 LEFT JOIN wp_postmeta c ON ( a.ID = c.post_id )
 LEFT JOIN wp_term_taxonomy d ON ( b.term_taxonomy_id = d.term_taxonomy_id)
 WHERE a.post_type = 'revision'
 AND d.taxonomy != 'link_category';
 #Delete Spam Comments
 DELETE FROM wp_comments WHERE comment_approved = 'spam';
 #Delete Unapproved Comments
 DELETE from wp_comments WHERE comment_approved = '0';
 
 #Delete Unused Tags
 DELETE FROM wp_terms WHERE term_id IN (SELECT term_id FROM wp_term_taxonomy WHERE count = 0 );
DELETE FROM wp_term_taxonomy WHERE term_id not IN (SELECT term_id FROM wp_terms);
DELETE FROM wp_term_relationships WHERE term_taxonomy_id not IN (SELECT term_taxonomy_id FROM wp_term_taxonomy);

#Delete Pingbacks and Trackbacks
DELETE FROM wp_comments WHERE comment_type = 'pingback';
DELETE FROM wp_comments WHERE comment_type = 'trackback';
 
 #Delete Transients
DELETE FROM wp_options WHERE option_name LIKE ('%\_transient\_%');



#Delete _edit_lock, _edit_last, _wp_page_template
DELETE FROM  wp_postmeta  where meta_key in ('_edit_lock','_edit_last');
#Run this only in  Old DB
#DELETE FROM  wp_postmeta  where meta_key = '_wp_page_template';

 