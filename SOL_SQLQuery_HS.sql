--Create DATABASE
CREATE DATABASE haystack;
USE haystack;

-- Create table users
CREATE TABLE users (
userid VARCHAR(50),
created_at DATETIME 
);

--Insert Data table users

INSERT INTO users (userid, created_at)
VALUES
('user1', '2023-10-10 10:45:00'),
('user2', '2023-10-11 14:30:00'),
('user3', '2023-10-12 09:15:00'),
('user4', '2023-10-13 20:00:00'),
('user5', '2023-10-14 07:45:00'),
('user6', '2023-10-15 18:30:00'),
('user7', '2023-10-10 22:15:00'),
('user8', '2023-10-12 03:00:00'),
('user9', '2023-10-14 11:30:00'),
('user10', '2023-10-15 02:45:00');

--Create table logon_events

CREATE TABLE logon_events (
userid VARCHAR(50),
logon_ts DATETIME
);

--Insert Data logon_events

delete from logon_events;

INSERT INTO logon_events (userid, logon_ts)
VALUES
-- Usuario 1
('user1', '2023-10-11 10:00:00'),
('user1', '2023-10-11 12:00:00'),
('user1', '2023-10-10 10:45:00'),
-- Usuario 2
('user2', '2023-10-12 11:00:00'),
('user2', '2023-10-12 12:00:00'),
('user2', '2023-10-12 13:00:00'),
('user2', '2023-10-12 14:00:00'),
('user2', '2023-10-11 14:30:00'),
-- Usuario 3
('user3', '2023-10-13 09:00:00'),
('user3', '2023-10-13 10:00:00'),
('user3', '2023-10-12 09:15:00'),
-- Usuario 4
('user4', '2023-10-14 20:00:00'),
('user4', '2023-10-14 21:00:00'),
('user4', '2023-10-14 22:00:00'),
('user4', '2023-10-13 20:00:00'),
-- Usuario 5
('user5', '2023-10-14 07:45:00'),
('user5', '2023-10-14 08:00:00'),
('user5', '2023-10-15 07:00:00'),
('user5', '2023-10-15 08:00:00'),
-- Usuario 6
('user6', '2023-10-15 18:30:00'),
('user6', '2023-10-15 19:00:00'),
('user6', '2023-10-15 20:00:00'),
('user6', '2023-10-16 18:30:00'),
('user6', '2023-10-17 18:30:00'),
('user6', '2023-10-17 19:00:00'),
-- Usuario 7
('user7', '2023-10-10 22:15:00'),
-- Usuario 8
('user8', '2023-10-12 03:00:00'),
-- Usuario 9
('user9', '2023-10-15 11:30:00'),
('user9', '2023-10-15 12:00:00'),
('user9', '2023-10-14 11:30:00'),
-- Usuario 10
('user10', '2023-10-16 02:45:00'),
('user10', '2023-10-16 03:00:00'),
('user10', '2023-10-15 02:45:00');

--Check new Tables

SELECT * FROM users;

SELECT * FROM logon_events;

-- TABLE: this table provides information on user activity.
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

-- Analysis and solution of the query:
-- STEP [1]: Calculate the total number of users.
SELECT COUNT(*) AS total_users FROM users;

-- STEP [2]: Calculate the number of users who logged in on the second day.

SELECT COUNT(DISTINCT u.userid) AS users_day_2 FROM users u
JOIN
logon_events l 
ON 
u.userid = l.userid --
WHERE DATEDIFF(day, u.created_at, l.logon_ts) = 1; 

--STEP [3]: Calculate Day 2 Return Rate

SELECT (CAST(users_day_2 AS DECIMAL) / total_users) AS day_2_return_rate FROM 
	(SELECT COUNT(DISTINCT u.userid) AS users_day_2
FROM users u
JOIN logon_events l 
ON 
u.userid = l.userid
WHERE DATEDIFF(day, u.created_at, l.logon_ts) = 1) day_2,
	(SELECT COUNT(*) AS total_users FROM users) total_users;