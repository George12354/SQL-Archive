--select * from artist;
--select * from canvas_size;
--select * from image_link;
--select * from museum_hours;
--select * from museum;
--select * from product_size;
--select * from subject;
--select * from work;

-- Solve the below SQL problems using the Famous Paintings & Museum dataset:

--1) Fetch all the paintings which are not displayed on any museums?

/*select * from work where museum_id IS NULL*/

--2) Are there museuems without any paintings?

/*select * from museum m
where exists (select * from work w 
where w.museum_id=m.museum_id)*/


--3) How many paintings have an asking price of more than their regular price? 

--select * from product_size where sale_price > regular_price

--4) Identify the paintings whose asking price is less than 50% of its regular price

--select * from product_size where sale_price < (regular_price/100) *50

--5) Which canva size costs the most?

/*select cs.*, ps.regular_price, ps.sale_price from canvas_size cs 
JOIN product_size ps on cs.size_id = ps.size_id
where ps.sale_price = (select MAX(sale_price) from product_size)*/


/*SELECT cs.* 
FROM (
    SELECT *, RANK() OVER (ORDER BY sale_price DESC) AS rnk
    FROM product_size
) ps
JOIN canvas_size cs ON cs.size_id = ps.size_id
WHERE ps.rnk = 1;*/

--6) Delete duplicate records from work, product_size, subject and image_link tables
/*
;with CTE as( select *,  
ROW_NUMBER() over( PARTITION BY work_id, name Order by (select NULL)) AS rn
from work)
Delete from CTE Where rn > 1

;with CTE as( select *,  
ROW_NUMBER() over( PARTITION BY work_id, size_id Order by (select NULL)) AS rn
from product_size)
Delete from CTE Where rn > 1

;with CTE as( select *,  
ROW_NUMBER() over( PARTITION BY work_id, [subject] Order by (select NULL)) AS rn
from subject)
Delete from CTE Where rn > 1

;with CTE as( select *,  
ROW_NUMBER() over( PARTITION BY work_id, url Order by (select NULL)) AS rn
from image_link)
Delete from CTE Where rn > 1
*/

--To check for the data type 
/*SELECT 
    DATA_TYPE
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME  = 'Museum'
    AND COLUMN_NAME = 'City'*/

--7) Identify the museums with invalid city information in the given dataset

/*SELECT *
FROM museum
WHERE city LIKE '%[0-9]%' */


--8) Museum_Hours table has 1 invalid entry. Identify it and remove it.

/*
;WITH CTE AS ( SELECT *, 
ROW_NUMBER() OVER 
(PARTITION BY museum_id, day 
ORDER BY (SELECT NULL)) AS rn 
FROM museum_hours ) 
DELETE FROM CTE WHERE rn > 1
*/

--9) Fetch the top 10 most famous painting subject


--SELECT *, ROW_NUMBER() OVER (PARTITION BY [subject] Order by (select NULL) ) AS rnk from subject
--order by rnk DESC

--This query is ideal for the question
/*
select * 
from (
    select s.subject, count(1) as no_of_paintings,
        rank() over(order by count(1) desc) as ranking
    from work w
    join subject s on s.work_id = w.work_id
    group by s.subject
) x
where x.ranking <= 10;
*/

--10) Identify the museums which are open on both Sunday and Monday. Display museum name, city.
/*
select m.name as museum_name, m.city
from museum_hours mh1
join museum m on m.museum_id=mh1.museum_id
where day='Sunday'
and exists (select 1 from museum_hours mh2
where mh2.museum_id = mh1.museum_id and mh2.day='Monday')

--ALTERNATIVE

SELECT DISTINCT m.name AS museum_name, m.city
FROM museum_hours mh1
JOIN museum_hours mh2 ON mh1.museum_id = mh2.museum_id
JOIN museum m ON m.museum_id = mh1.museum_id
WHERE mh1.day = 'Sunday'
  AND mh2.day = 'Monday';
*/


--11) How many museums are open every single day?

/*
--Alternative
SELECT COUNT(DISTINCT mh.museum_id) AS museums_open_every_day
FROM museum_hours mh
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT 'Sunday' AS day
        UNION SELECT 'Monday'
        UNION SELECT 'Tuesday'
        UNION SELECT 'Wednesday'
        UNION SELECT 'Thursday'
        UNION SELECT 'Friday'
        UNION SELECT 'Saturday'
    ) all_days
    WHERE NOT EXISTS (
        SELECT 1
        FROM museum_hours mh2
        WHERE mh2.museum_id = mh.museum_id
          AND mh2.day = all_days.day
    )
);

--Alternative
SELECT count(*) as museums_open_every_day
FROM (
    SELECT museum_id
    FROM museum_hours
    GROUP BY museum_id
    HAVING count(DISTINCT day) = 7
)x ;


--Alternative
--ordered according to days
SELECT mh.museum_id, mh.day
FROM museum_hours mh
WHERE mh.museum_id IN (
    SELECT museum_id
    FROM museum_hours
    GROUP BY museum_id
    HAVING COUNT(DISTINCT day) = 7
)
ORDER BY mh.museum_id, mh.day;
*/

--12) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)

/*
select TOP (5) m.name as museum_name, COUNT(w.work_id) as no_of_paintings
from museum m
JOIN work w on m.museum_id = w.museum_id
GROUP BY m.name
ORDER BY no_of_paintings DESC
*/

--13) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)

/*
select TOP (5) a.full_name, COUNT(w.work_id) as no_of_paintings
from artist a
JOIN work w on w.artist_id = a.artist_id
GROUP BY a.full_name
ORDER BY no_of_paintings DESC
*/

--14) Display the 3 least popular canva sizes

---To check data type
/*
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'product_size' AND COLUMN_NAME = 'size_id';


SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'canvas_size' AND COLUMN_NAME = 'size_id';
*/

/*
--This query does not answer the question

select TOP (3) *, (width * height) as area
from canvas_size
where width is NOT NULL AND height IS NOT NULL
ORDER BY area ASC
*/

/*
--This query answers the question
SELECT TOP (3) c.label, COUNT(w.work_id) AS no_of_paintings
FROM work w
JOIN product_size p ON p.work_id = w.work_id
JOIN canvas_size c ON p.size_id = CAST(c.size_id AS VARCHAR)
WHERE c.width IS NOT NULL AND c.height IS NOT NULL
GROUP BY c.label
ORDER BY no_of_paintings ASC;
*/


--15) Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?

/*
--This query is to change the data type
select DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'museum_hours' and COLUMN_NAME = 'close'

--This query help to make the data consistent to aid easy conversion to date time
UPDATE museum_hours
SET [open] = REPLACE(REPLACE([open], ':AM', ' AM'), ':PM', ' PM'),
    [close] = REPLACE(REPLACE([close], ':AM', ' AM'), ':PM', ' PM')
WHERE [open] LIKE '%:%:AM%' OR [open] LIKE '%:%:PM%'
   OR [close] LIKE '%:%:AM%' OR [close] LIKE '%:%:PM%';


--This query answers the question
SELECT TOP (1) [open],[close], 
       DATEDIFF(MINUTE, CAST([open] AS TIME), CAST([close] AS TIME)) AS Duration_in_minutes, 
       RANK() OVER (ORDER BY DATEDIFF(MINUTE, CAST([open] AS TIME), CAST([close] AS TIME)) DESC) AS Ranking
FROM museum_hours mh
JOIN museum m ON m.museum_id = mh.museum_id
WHERE [open] IS NOT NULL 
  AND [close] IS NOT NULL
  AND LEN([open]) > 0 
  AND LEN([close]) > 0
  AND ([open] LIKE '%AM%' OR [open] LIKE '%PM%') 
  AND ([close] LIKE '%AM%' OR [close] LIKE '%PM%');
*/


--16) Which museum has the most no of most popular painting style?

/*
select TOP(1) m.name as museum_name, w.style, COUNT(1) AS no_of_paintings
from museum m
JOIN work w on m.museum_id = w.museum_id
GROUP BY m.name, w.style
ORDER BY COUNT(1) DESC 
*/

--17) Identify the artists whose paintings are displayed in multiple countries

/*
SELECT a.full_name AS artist, COUNT(DISTINCT m.country) AS no_of_countries
FROM artist a
JOIN work w ON w.artist_id = a.artist_id
JOIN museum m ON w.museum_id = m.museum_id
WHERE w.name IS NOT NULL AND m.country IS NOT NULL
GROUP BY a.full_name
ORDER BY no_of_countries DESC
*/

--18) Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country. If there are multiple value, seperate them with comma.
 

---To check for the number of museum
/*
select m.country AS top_countries, m.city AS top_cities,
	COUNT(DISTINCT m.name ) AS no_of_museum
from museum m
GROUP BY m.country, m.city
ORDER BY no_of_museum DESC
*/

/*
;WITH ranked_data AS (
    SELECT 
        m.country, 
        m.city, 
        COUNT(DISTINCT m.name) AS no_of_museum,
        RANK() OVER (ORDER BY COUNT(DISTINCT m.name) DESC) AS rank
    FROM museum m
    GROUP BY m.country, m.city
)
SELECT 
    STRING_AGG(ranked_data.country, ', ') AS top_countries,
    STRING_AGG(ranked_data.city, ', ') AS top_cities
FROM ranked_data
WHERE ranked_data.rank = 1;
*/

--19) Identify the artist and the museum where the most expensive and least expensive painting is placed. Display the artist name, sale_price, painting name, museum name, museum city and canvas label

/*
;with ranked_cte AS (
select w.name AS painting, ps.sale_price AS sale_price, a.full_name AS artist, m.name AS museum, m.city AS city, cs.label AS canvas
from work w
JOIN artist a ON a.artist_id = w.artist_id
JOIN museum m ON m.museum_id = w.museum_id
JOIN product_size ps ON ps.work_id = w.work_id
JOIN canvas_size cs ON CAST(cs.size_id AS varchar(50)) = CAST(ps.size_id AS varchar(50))
GROUP BY w.name, ps.sale_price, a.full_name, m.name, m.city, cs.label
)

select *
from ranked_cte
WHERE ranked_cte.sale_price = (select MAX(sale_price) from ranked_cte) OR ranked_cte.sale_price = (select MIN(sale_price) from ranked_cte)
order by ranked_cte.sale_price DESC
*/

--20) Which country has the 5th highest no of paintings?

/*
;with rnk as(
select m.country, Count(w.work_id) as no_of_paintings, 
RANK() OVER(ORDER BY COUNT(w.work_id) DESC) as rank
from museum m
JOIN work w on w.museum_id = m.museum_id
GROUP BY m.country
)

select rnk.country, rnk.no_of_paintings
from rnk
where rank = 5
*/


--21) Which are the 3 most popular and 3 least popular painting styles?

/*
;with rnk as(
    select w.style,
	CASE 
		WHEN RANK() OVER (ORDER BY COUNT(w.work_id) DESC) <= 3 THEN 'Most Popular'
		WHEN RANK() OVER (ORDER BY COUNT(w.work_id) ASC) <= 3 THEN 'Least Popular'
		ELSE NULL
    END AS remarks,
        
	RANK() OVER(ORDER BY COUNT(w.work_id) DESC) AS rank_desc,
	RANK() OVER(ORDER BY COUNT(w.work_id) ASC) AS rank_asc
	from work w
	where w.style IS NOT NULL
	GROUP BY w.style
)


select rnk.style, rnk.remarks
from rnK
WHERE rnk.remarks IS NOT NULL
ORDER BY rank_desc, rank_asc;

*/
--22) Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.

/*
;with rnk as(
SELECT a.full_name AS artist_name, a.nationality, COUNT(1) AS no_of_paintings,
RANK() OVER( ORDER BY COUNT(1) DESC) AS ranking
FROM museum m
JOIN work w ON w.museum_id = m.museum_id
JOIN artist a ON a.artist_id = w.artist_id
JOIN subject s ON s.work_id = w.work_id
WHERE m.country != 'USA' AND s.subject = 'Portraits'
GROUP BY a.full_name, a.nationality
)

select rnk.artist_name, rnk.nationality, rnk.no_of_paintings
from rnk
where rnk.ranking = 1
*/