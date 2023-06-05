1
Select*
from public."Game_data"
where event_name='install'

--
2
SELECT EXTRACT(DAY
FROM e3.day_num) AS days, COUNT(user_id) AS payer
FROM 
	(SELECT e1.user_id, ( e2.created_at - e1.created_at) AS day_num
		 
	FROM public."Game_data" e1
	JOIN 
		(SELECT min(created_at) AS created_at,
		 user_id
		FROM public."Game_data"
		WHERE event_name = 'payment'
		GROUP BY  user_id, event_name) e2
			ON e1.user_id = e2.user_id
		WHERE e1.event_name = 'install') AS e3
	GROUP BY  days
ORDER BY  days ASC limit 14
--
3
SELECT EXTRACT(DAY
FROM e3.day_num) AS days, SUM(revenue)
FROM 
	(SELECT e1.user_id,
		 ( e2.created_at - e1.created_at) AS day_num,
		 e2.revenue
	FROM public."Game_data" e1
	JOIN 
		(SELECT created_at AS created_at,
		 revenue,
		 user_id
		FROM public."Game_data"
		WHERE event_name = 'payment' ) e2
			ON e1.user_id = e2.user_id
		WHERE e1.event_name = 'install') AS e3
	GROUP BY  days
ORDER BY  days ASC limit 14
--
4
SELECT e3.day_num,
		 count(user_id) AS active
FROM 
	(SELECT DISTINCT e1.user_id,
		 extract(day
	FROM (e2.created_at - e1.created_at)) AS day_num
	FROM public."Game_data" e1
	JOIN 
		(SELECT created_at AS created_at,
		 user_id
		FROM public."Game_data"
		WHERE event_name = 'session' ) e2
			ON e1.user_id = e2.user_id
		WHERE e1.event_name = 'install' ) AS e3
	GROUP BY  e3.day_num
ORDER BY  e3.day_num ASC limit 14
--
5
SELECT EXTRACT(DAY
FROM e3.day_num) AS days, 
	(SELECT count(distinct(bill_to))) :: float / 
		(SELECT count(distinct user_id)
		FROM public."Game_data"
		WHERE event_name = 'install') * 100
	FROM 
	(SELECT ( e2.created_at - e1.created_at) AS day_num,
		 e2.user_id AS bill_to
	FROM public."Game_data" e1
	JOIN 
		(SELECT min(created_at) AS created_at,
		 user_id
		FROM public."Game_data"
		WHERE event_name = 'payment'
		GROUP BY  user_id, event_name) e2
			ON e1.user_id = e2.user_id
		WHERE e1.event_name = 'install') AS e3
	GROUP BY  days
ORDER BY  days ASC limit 14
--
6
SELECT EXTRACT(DAY
FROM e3.day_num) AS days, 
	(SELECT count(distinct(bill_to))) :: float / 
		(SELECT count(distinct user_id)
		FROM public."Game_data"
		WHERE event_name = 'install') * 100
	FROM 
	(SELECT ( e2.created_at - e1.created_at) AS day_num,
		 e2.user_id AS bill_to
	FROM public."Game_data" e1
	JOIN 
		(SELECT created_at AS created_at,
		 user_id
		FROM public."Game_data"
		WHERE event_name = 'session' ) e2
			ON e1.user_id = e2.user_id
		WHERE e1.event_name = 'install') AS e3
	GROUP BY  days 

--
7
SELECT EXTRACT(DAY
FROM e3.day_num) AS days, 
	(SELECT SUM(revenue)) :: float / 
		(SELECT count(distinct user_id)
		FROM public."Game_data"
		WHERE event_name = 'install') AS LTV
	FROM 
	(SELECT e1.user_id,
		 ( e2.created_at - e1.created_at) AS day_num,
		 e2.revenue
	FROM public."Game_data" e1
	JOIN 
		(SELECT created_at AS created_at,
		 revenue,
		 user_id
		FROM public."Game_data"
		WHERE event_name = 'payment' ) e2
			ON e1.user_id = e2.user_id
		WHERE e1.event_name = 'install') AS e3
	GROUP BY  days
ORDER BY  days ASC limit 14 
