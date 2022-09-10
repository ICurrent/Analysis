/*QUERY NOW*/

/*Find users who have ever commented on a photo*/
SELECT u.id, u.username, c.comment_text, c.photo_id
FROM users u
JOIN comments c ON u.id = c.user_id
GROUP BY 1;


/*What day of the week do most users register on?
We need to figure out when to schedule an ad campgain*/
SELECT date_format(u.created_at, '%W') 'day of the week',
	COUNT(date_format(u.created_at, '%W')) 'count registers '
FROM users u
GROUP BY 1
ORDER BY 2 DESC;


/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/
SELECT u.id, u.username, p.image_url
FROM `users` u
LEFT JOIN photos p ON u.id = p.user_id
WHERE p.image_url IS NULL;


/*We're running a new contest to see who can get the most likes on a single photo.
WHO WON??!!*/
SELECT u.username, l.photo_id, COUNT(l.photo_id) 'Number of Likes'
FROM users u 
JOIN likes l ON u.id = l.user_id
GROUP BY 2
ORDER BY 3 DESC;


/*We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/
SELECT u.username, u.created_at
FROM users u
ORDER BY 2
LIMIT 5;


/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/
SELECT (SELECT COUNT(p.id) FROM photos p)/ (SELECT COUNT(u.id) FROM users u)


/*user ranking by postings higher to lower*/
SELECT u.username, COUNT(p.user_id) 'Number of Post'
FROM users u
JOIN photos p ON u.id = p.user_id
GROUP BY p.user_id
ORDER BY 2 DESC; 


/*Total Posts by users (longer version of SELECT COUNT(*)FROM photos) */
SELECT SUM(user_posts.total_posts_per_user)
FROM (SELECT u.username, COUNT(p.user_id) total_posts_per_user
	FROM users u
	JOIN photos p ON u.id = p.user_id
	GROUP BY p.user_id
	ORDER BY 2 DESC) AS user_posts;


/*total numbers of users who have posted at least one time */
SELECT COUNT(*)
FROM (
	SELECT u.username, COUNT(p.user_id) 'Number of Post'
	FROM users u
	JOIN photos p ON u.id = p.user_id
	GROUP BY p.user_id
	ORDER BY 2 DESC) tab; 
	/*or*/
SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
FROM users
JOIN photos ON users.id = photos.user_id;


/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/
SELECT t.tag_name, COUNT(*) 'No of Tags'
FROM `tags` t
JOIN photo_tags pt ON t.id = pt.tag_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


/*We have a small problem with bots on our site...
Find users who have liked every single photo on the site*/
SELECT u.id, u.username, COUNT(u.id) As total_likes_by_user
FROM users u
JOIN likes l ON u.id = l.user_id
GROUP BY 2
HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos)
ORDER BY 2;


/*We also have a problem with celebrities
Find users who have never commented on a photo*/
SELECT u.username, c.comment_text
FROM users u
LEFT JOIN comments c ON u.id = c.user_id
WHERE c.comment_text IS NULL;


/*Mega Challenges
/*Mega Challenges
Are we overrun with bots and celebrity accounts?
Find the percentage of our users who have either never commented on a photo or have LIKED every photo*/
SELECT NonCommented.Number_of_Not_Commented AS 'Number Of Users who never commented',
	   (NonCommented.Number_of_Not_Commented/(SELECT COUNT(*) FROM users))*100 AS '%',
	   Liked.Number_of_users_liking_all_post AS 'Number Of Users who liked',
       (Liked.Number_of_users_liking_all_post/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM(
    SELECT COUNT(*) Number_of_users_liking_all_post
	FROM
        (SELECT u.id, u.username, COUNT(u.id) As total_likes_by_user
		FROM users u
		JOIN likes l ON u.id = l.user_id
		GROUP BY 2
		HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos)) no_of_likes) Liked
JOIN(
    SELECT COUNT(DISTINCT u.username) Number_of_Not_Commented
	FROM users u
	LEFT JOIN comments c ON u.id = c.user_id
	WHERE c.comment_text IS NULL) NonCommented;


/*Find users who have ever commented on a photo*/
SELECT u.username, GROUP_CONCAT(c.comment_text SEPARATOR '\n') comments
FROM users u
LEFT JOIN comments c ON u.id = c.user_id
WHERE c.comment_text IS NOT NULL
GROUP BY 1;


/*Are we overrun with bots and celebrity accounts?
Find the percentage of our users who have either never commented on a photo or have commented on photos before*/
SELECT NonCommented.Number_of_Not_Commented AS 'Number Of Users who never commented',
	   (NonCommented.Number_of_Not_Commented/(SELECT COUNT(*) FROM users))*100 AS '%',
	   Commented.Number_of_Commented AS 'Number Of Users who commented',
       (Commented.Number_of_Commented/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM(
    SELECT COUNT(DISTINCT u.username) Number_of_Commented
	FROM users u
	LEFT JOIN comments c ON u.id = c.user_id
	WHERE c.comment_text IS NOT NULL) Commented
JOIN(
    SELECT COUNT(DISTINCT u.username) Number_of_Not_Commented
	FROM users u
	LEFT JOIN comments c ON u.id = c.user_id
	WHERE c.comment_text IS NULL) NonCommented;



#Current