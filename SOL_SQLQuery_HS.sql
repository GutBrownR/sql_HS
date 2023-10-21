/*
In this exercise I will solve the question for Haystack:

Assume a schema of: users (userid string, created_at timestamp), logon_events (userid string, logon_ts timestamp). Write a SQL query to calculate the percentage of users who logged on during the second day since they created their account (Day 2 Return Rate)
Note that a single user can login more than once in a single day.

Sol by. Roberto Gutiérrez Brown
*/

-----------------------
-- FIRST STAGE:
-- creation of tables assuming that 10 users log in on different dates and log in on the second and third day.
-----------------------

--Create DATABASE
CREATE DATABASE haystack;
USE haystack;

-- Create table users
CREATE TABLE users (
userid VARCHAR(50), created_at DATETIME );

--Insert Data table users

INSERT INTO users (userid, created_at)
VALUES
('user1', '2023-10-10 10:45:00'), ('user2', '2023-10-11 14:30:00'), ('user3', '2023-10-12 09:15:00'),
('user4', '2023-10-13 20:00:00'), ('user5', '2023-10-14 07:45:00'), ('user6', '2023-10-15 18:30:00'),
('user7', '2023-10-10 22:15:00'), ('user8', '2023-10-12 03:00:00'), ('user9', '2023-10-14 11:30:00'),
('user10', '2023-10-15 02:45:00');

--Create table logon_events

CREATE TABLE logon_events (
userid VARCHAR(50), logon_ts DATETIME );

--Insert Data logon_events

INSERT INTO logon_events (userid, logon_ts)
VALUES
-- User 1
('user1', '2023-10-11 10:00:00'), ('user1', '2023-10-11 12:00:00'), ('user1', '2023-10-10 10:45:00'),
-- User 2 
('user2', '2023-10-12 11:00:00'), ('user2', '2023-10-12 12:00:00'), ('user2', '2023-10-12 13:00:00'),
('user2', '2023-10-12 14:00:00'), ('user2', '2023-10-11 14:30:00'),
-- User 3
('user3', '2023-10-13 09:00:00'), ('user3', '2023-10-13 10:00:00'), ('user3', '2023-10-12 09:15:00'),
-- User 4
('user4', '2023-10-14 20:00:00'), ('user4', '2023-10-14 21:00:00'), ('user4', '2023-10-14 22:00:00'),
('user4', '2023-10-13 20:00:00'),
-- User 5
('user5', '2023-10-14 07:45:00'), ('user5', '2023-10-14 08:00:00'), ('user5', '2023-10-15 07:00:00'),
('user5', '2023-10-15 08:00:00'), 
-- User 6
('user6', '2023-10-15 18:30:00'), ('user6', '2023-10-15 19:00:00'), ('user6', '2023-10-15 20:00:00'),
('user6', '2023-10-16 18:30:00'), ('user6', '2023-10-17 18:30:00'), ('user6', '2023-10-17 19:00:00'),
-- User 7 
('user7', '2023-10-10 22:15:00'), 
-- User 8
('user8', '2023-10-12 03:00:00'),
-- User 9
('user9', '2023-10-15 11:30:00'), ('user9', '2023-10-15 12:00:00'), ('user9', '2023-10-14 11:30:00'),
-- User 10
('user10', '2023-10-16 02:45:00'), ('user10', '2023-10-16 03:00:00'), ('user10', '2023-10-15 02:45:00');

--Check new Tables
SELECT * FROM users;
SELECT * FROM logon_events;

-----------------------
-- SECOND STAGE:
-- This table provides information on user activity.
-----------------------
SELECT u.userid,
		SUM(CASE WHEN DATEDIFF(day, u.created_at, l.logon_ts) = 0 THEN 1 ELSE 0 END) AS day_1,
		SUM(CASE WHEN DATEDIFF(day, u.created_at, l.logon_ts) = 1 THEN 1 ELSE 0 END) AS day_2,
		SUM(CASE WHEN DATEDIFF(day, u.created_at, l.logon_ts) = 2 THEN 1 ELSE 0 END) AS day_3
FROM
    users u
LEFT JOIN
    logon_events l ON u.userid = l.userid
GROUP BY u.userid
ORDER BY u.userid;

-----------------------
-- THIRD STAGE:
-- Analysis and solution of the query in 3 steps
-----------------------

-- STEP [1]: Calculate the total number of users.
SELECT COUNT(*) AS total_users FROM users;

-- STEP [2]: Calculate the number of users who logged in on the second day.

SELECT COUNT(DISTINCT u.userid) AS users_day_2 FROM users u
JOIN
logon_events L
ON 
u.userid = L.userid
WHERE DATEDIFF(day, u.created_at, L.logon_ts) = 1; 

--STEP [3]: Calculate Day 2 Return Rate in %
--------- TIP: % is in decimals

SELECT (CAST(users_day_2 AS DECIMAL) / total_users) AS day_2_return_rate FROM 
	(SELECT COUNT(DISTINCT u.userid) AS users_day_2
FROM users u
JOIN logon_events L 
ON 
u.userid = L.userid
WHERE DATEDIFF(day, u.created_at, L.logon_ts) = 1) day_2,
	(SELECT COUNT(*) AS total_users FROM users) total_users;