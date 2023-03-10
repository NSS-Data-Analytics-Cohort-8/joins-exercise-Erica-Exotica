-- ** How to import your data. **

-- 1. In PgAdmin, right click on Databases (under Servers -> Postgresql 15). Hover over Create, then click Database.

-- 2. Enter in the name ‘Joins’ (not the apostrophes). Click Save.

-- 3. Left click the server ‘Joins’. Left click Schemas. 

-- 4. Right click public and select Restore.

-- 5. Select the folder icon in the filename row. Navigate to the data folder of your repo and select the file movies.backup. Click Restore.


-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT film_title, release_year, worldwide_gross
FROM specs AS s
JOIN revenue AS r
ON s.movie_id = r.movie_id
ORDER BY worldwide_gross
LIMIT 1;

--Semi-Tough is the lowest grossing movie worldwide


-- 2. What year has the highest average imdb rating?

SELECT release_year, ROUND(AVG(r.imdb_rating),2) as avg_rating
FROM specs as s
JOIN rating as r
ON s.movie_id = r.movie_id
GROUP BY release_year
ORDER BY avg_rating DESC
LIMIT 1;

-- 1991

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT 
	film_title,
	company_name
FROM specs as s
JOIN revenue as r
ON s.movie_id = r.movie_id
JOIN distributors
ON distributor_id = domestic_distributor_id
WHERE mpaa_rating = 'G'
ORDER BY worldwide_gross DESC
LIMIT 1;

-- Toy Story 4 / Walt Disney


-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT company_name as company, COUNT(film_title) as movie_count
FROM distributors as d
LEFT JOIN specs as s
ON d.distributor_id = s.domestic_distributor_id
GROUP BY company;


-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT company_name as company, ROUND(AVG(film_budget),2) as avg_budget
FROM distributors as d
JOIN specs as s
ON d.distributor_id = s.domestic_distributor_id
JOIN revenue as r
USING(movie_id)
GROUP BY company
ORDER BY avg_budget DESC
LIMIT 5;

--highest avg budget companies are Disney, Sony, Lionsgate, DreamWorks, and Warner Bros

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT film_title, company_name, headquarters, imdb_rating
FROM distributors as d
JOIN specs as s
ON d.distributor_id = s.domestic_distributor_id
JOIN rating as r
ON s.movie_id = r.movie_id
WHERE headquarters NOT LIKE '%CA%'
GROUP BY film_title, company_name, imdb_rating, headquarters
ORDER BY imdb_rating DESC;

--Dirty Dancing has the highest rating of the two films that weren't made in California

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT 
	ROUND(AVG(imdb_rating),2) as avg_rating_under2,
	(SELECT 
	 	ROUND(AVG(imdb_rating),2)
	FROM rating
	JOIN specs
	USING(movie_id)
	WHERE length_in_min > 120) as avg_rating_over2
FROM rating
JOIN specs
USING(movie_id)
WHERE length_in_min < 120;

--Movies over 2 hours have a higher avg rating than movies under 2 hrs.



