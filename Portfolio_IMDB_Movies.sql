
/*
IMDB Movies Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


Select * 
From CV_Project..Movies
order by 3 desc;

Select * 
From CV_Project..Actors
order by 1 desc;

Select * 
from CV_Project..Genres;


----- Trimming Genre -----

SELECT DISTINCT LTRIM(RTRIM(Genre)) AS Genre
FROM CV_Project..Genres
order by 1;


SELECT DISTINCT REPLACE(Genre, ' ', '') AS Genre
FROM CV_Project..Genres
ORDER BY 1;

UPDATE CV_Project..Genres
SET Genre = REPLACE(Genre, ' ', '');

SELECT DISTINCT Genre
FROM CV_Project..Genres;


----- Avarage score per country -----

	SELECT Original_Language, Number_of_movies, Round(Sum_of_Score / Number_of_movies,2) AS Average_Score
FROM 
(
    SELECT Original_Language, COUNT(Names) AS Number_of_movies, SUM(Score) AS Sum_of_Score
    FROM CV_Project..Movies
    GROUP BY Original_Language
) AS subquery
ORDER BY 3 desc;


----- Avarage score per country with more than 20 movies in the database -----

	SELECT Original_Language, Number_of_movies, Sum_of_points, Round(Sum_of_points / Number_of_movies,2) AS Average
FROM 
(
    SELECT Original_Language, COUNT(Names) AS Number_of_movies, SUM(Score) AS Sum_of_points
    FROM CV_Project..Movies
    GROUP BY Original_Language
) AS subquery
WHERE Number_of_movies > 20
ORDER BY 4 desc;


----- Movies Genres distribution -----

SELECT Genre, COUNT(Genre)
FROM CV_Project..Genres
WHERE Genre is not null
GROUP BY Genre
ORDER BY 2 desc;

SELECT Genre, COUNT(Genre)
FROM CV_Project..Genres
WHERE Genre is not null
GROUP BY Genre
ORDER BY 2 desc;


----- Looking at best movies (Score>75) Genres distribution -----  JOIN

SELECT a.Names, a.Score, a.Country, b.Genre
FROM CV_Project..Movies a
JOIN CV_Project..Genres b ON a.Names = b.Names 
WHERE a.Score > 80
AND Genre is not null
ORDER BY 1;


----- Looking at best movies (Score>75) Dates distribution -----

SELECT Names, CAST(Date as date) as Date, Score
FROM CV_Project..Movies
WHERE Score > 75
ORDER BY 2 desc,1 desc;


----- Top 3 Movie from each Year + (Using a CTE) -----
 
With Table1 (Names, Score, Years)
AS
(
	SELECT Names, Score, Year(date) as Years
	FROM CV_Project..Movies
)
SELECT *
FROM (
  SELECT Names, Score, Years,
    ROW_NUMBER() OVER (PARTITION BY Years ORDER BY Score DESC) AS Rank
  FROM Table1
) AS subquery
WHERE Rank <= 3
ORDER BY Years desc, Rank;


----- Top 3 Movie from each Year + (Using a TEMP TABLE) -----

DROP TABLE IF EXISTS #Table2
CREATE TABLE #Table2
(
  Names nvarchar(255),
  Score float,
  Years int
)

INSERT INTO #Table2
  SELECT Names, Score, YEAR(date) as Years
  FROM CV_Project..Movies;

SELECT *
FROM 
(
  SELECT Names, Score, Years,
    ROW_NUMBER() OVER (PARTITION BY Years ORDER BY Score DESC) AS Rank
  FROM #Table2
) AS subquery
WHERE Rank <= 3
ORDER BY Years DESC, Rank;

----- Creating View to store data for later visualisation -----


CREATE VIEW Top3_Movies_Years as

With Table1 (Names, Score, Years)
AS
(
	SELECT Names, Score, Year(date) as Years
	FROM CV_Project..Movies
)
SELECT *
FROM (
  SELECT Names, Score, Years,
    ROW_NUMBER() OVER (PARTITION BY Years ORDER BY Score DESC) AS Rank
  FROM Table1
) AS subquery
WHERE Rank <= 3
--ORDER BY Years desc, Rank;
