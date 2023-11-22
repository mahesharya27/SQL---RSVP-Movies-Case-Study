use imdb;
/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select count(*) as 'Total number of rows in Director_mapping' from director_mapping;
select count(*) as 'Total number of rows in Genre' from genre;
select count(*) as 'Total number of rows in Movie' from movie;
select count(*) as 'Total number of rows in Names' from names;
select count(*) as 'Total number of rows in Ratings' from ratings;
select count(*) as 'Total number of rows in Role_mapping' from role_mapping;

-- Q1.Ans: Total number of rows can be derived from above code individually.


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS null_id,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS null_title,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS null_year,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS null_date_published,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS null_duration,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS null_country,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS null_worlwide_gross_income,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS null_languages,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS null_production_company
FROM
    movie;

-- Q2 Ans: So from above queries it is clear that colums(country,worlwide_gross_income,languages,production_company) have null values


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

SELECT 
    year, COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY year;

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY COUNT(title) DESC;

-- Q3 Ans:(1) highest number of movies released in 2017 the count was gradually decreasing for approaching years
-- Q3 Ans:(2)  limited number of movies getting released in (may, june, july) were as maximum targetting the major market which is (mar, jan, sept, oct) and utmost lowest in (dec) and highest(mar)


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(id) AS number_of_movies, year
FROM
    movie
WHERE
    (country LIKE '%USA%'
        OR COUNTRY LIKE '%India%')
        AND YEAR = 2019;
        
-- Q4.Ans: USA and India produced 1059 in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/


-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre AS 'unique list of Genres'
FROM
    genre;
-- Q5.Ams: list of Genres mentioned below.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */


-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    g.genre, COUNT(m.title) AS 'number of movies'
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY genre
ORDER BY COUNT(m.title) DESC;

-------------------

SELECT 
    g.genre, COUNT(m.title) AS 'number of movies'
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
where year = 2019
GROUP BY genre
ORDER BY COUNT(m.title) DESC;

-- Q6.Ans: in the previous answer statement it mentioned for previous year but in question it mentioned for overall, given codes for both. unfortunately both the data has "drama" in top

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/


-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count 
AS(
SELECT movie_id, count(genre) as count_of_genre
FROM genre group by movie_id)
SELECT count(movie_id) as 'movies with one genre' FROM genre_count where count_of_genre = 1;

-- Q7.Ans: 3289 movies belong to only one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/


-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

SELECT
g.genre, ROUND(AVG(m.duration),2) AS 'Avg Duration'
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY genre
ORDER BY AVG(m.duration) DESC;

-- Q8.Ans: average duration of all genre movies lies between 92-112.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

SELECT
genre, COUNT(movie_id),
RANK() OVER(ORDER BY COUNT(movie_id) DESC) as 'Genre rank'
FROM genre
GROUP BY genre;

-- Q9.Ans: from result it is evident that drama, comedy, thriller genres have highest releases.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:





-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?

SELECT
MIN(avg_rating) AS min_avg_rating,
MAX(avg_rating) AS max_avg_rating,
MIN(total_votes) as min_total_votes,
MAX(total_votes) AS max_total_votes,
MIN(median_rating) AS min_median_rating,
MAX(median_rating) AS max_median_rating
FROM ratings;

-- Q10.Ans: it is evident that given ratings table has no outliers.

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/


-- Q11. Which are the top 10 movies based on average rating?

WITH Rank_by_avg_rating
AS
(
SELECT title, avg_rating,
DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
)
SELECT * FROM Rank_by_avg_rating WHERE movie_rank <= 10;

-- Q11.Ans: Kirket, love in kilnerry secured the 1st position in top 10 movies list based on average rating

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/


-- Q12. Summarise the ratings table based on the movie counts by median ratings.

SELECT 
    median_rating, COUNT(movie_id) AS num_of_movies
FROM
    ratings
GROUP BY median_rating
ORDER BY num_of_movies DESC;

-- Q12.Ans: median rating like 6-8 has highest chunk of the data were as 7 has the highest number.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/


-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??

SELECT production_company,
       Count(movie_id) AS 'num of hit movies',
       DENSE_RANK()
         OVER(
           ORDER BY Count(movie_id) DESC) AS prod_company_rank
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  r.avg_rating > 8
       AND m.production_company IS NOT NULL
GROUP  BY production_company;

-- Q13.Ans: Dream Warrior Pictures and National Theatre had produced the most number of hit movies 

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?

SELECT 
    genre, COUNT(g.movie_id) AS 'Movies released count'
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    MONTH(m.date_published) = 3
        AND m.year = 2017
        AND m.country LIKE '%usa%'
        AND r.total_votes > 1000
GROUP BY genre
ORDER BY COUNT(g.movie_id) DESC;

-- Q14.Ans: Drama genre movies released in highest number during March 2017 in USA which had more than 1,000 votes

-- Lets try to analyse with a unique problem statement.

-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?

SELECT 
    title, avg_rating, genre
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    title LIKE 'the%' AND avg_rating > 8
    ORDER BY avg_rating DESC;
    
-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

SELECT 
    title, median_rating, genre
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    title LIKE 'the%' AND median_rating > 8
    ORDER BY median_rating DESC;
    
-- Q15.Ans: By comparing both average and median rating one point is evident that median rating provides highest number of movies than avg rating

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

SELECT 
    median_rating, COUNT(id) AS 'num of movies released'
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- Q16.Ans: Total 361 movies were given a median rating of 8
 
-- Once again, try to solve the problem given below.

-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    country, SUM(total_votes) AS 'votes count'
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    country in ('germany' ,'italy')
GROUP BY country;

-- Q17.Ans: German movies get more votes than Italian movies

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??

SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;
    
    -- Q18.Ans: all columns except id,name have null values in names table
    
    /* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?

WITH top_genre
AS
(
SELECT
g.genre,
COUNT(g.movie_id) as movie_count
FROM genre g
INNER JOIN ratings r
ON g.movie_id = r.movie_id
WHERE avg_rating>8
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
),
top_director
AS
(
SELECT
n.name as director_name,
COUNT(d.movie_id) as movie_count,
RANK() OVER(ORDER BY COUNT(d.movie_id) DESC) director_rank
FROM names n
INNER JOIN director_mapping d
ON n.id = d.name_id
INNER JOIN ratings r
ON r.movie_id = d.movie_id
INNER JOIN genre g
ON g.movie_id = d.movie_id,
top_genre
WHERE r.avg_rating > 8 AND g.genre IN (top_genre.genre)
GROUP BY n.name
ORDER BY movie_count DESC
)
SELECT director_name,
movie_count
FROM top_director
WHERE director_rank <= 3
LIMIT 3;

-- Q19.Ans: James Mangold, Soubin Shahir, Joe Russo, Anthony Russo were on top.

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/


-- Q20. Who are the top two actors whose movies have a median rating >= 8?

SELECT 
    *
FROM
    role_mapping;
SELECT 
    n.name AS actor_name, COUNT(rm.movie_id) AS movie_count
FROM
    role_mapping rm
        INNER JOIN
    names n ON n.id = rm.name_id
        INNER JOIN
    ratings r ON r.movie_id = rm.movie_id
WHERE
    category = 'actor'
        AND r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;

-- Q20.And: Mammootty, Mohanlal top two actors whose movies have a median rating >= 8. 

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/


-- Q21. Which are the top three production houses based on the number of votes received by their movies?

SELECT
production_company,
SUM(total_votes) AS vote_count,
DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY production_company
ORDER BY vote_count DESC
LIMIT 3;

-- Q21.Ans: Marvel Studios, Twentieth Century Fox, Warner Bros.  are the top three production houses based on the number of votes received by their movies. 

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/


-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?

SELECT a.name as actor_name, c.total_votes, COUNT(c.movie_id) as movie_count,c.avg_rating as actor_avg_rating,
RANK() OVER( PARTITION BY
            d.category = 'actor'
            ORDER BY 
            c.avg_rating DESC
            ) actor_rank
FROM names a, movie b, ratings c, role_mapping d    
where b.country = 'INDIA'
       and b.id = c.movie_id
       and b.id= d.movie_id
       and a.id = d.name_id
    
group by actor_name
having count(d.movie_id) >= 5
order by actor_avg_rating desc
; 

-- Q22.Ans: Vijay Sethupathi is at the top of the list with movies released in India based on their average ratings.

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 

WITH actress_ranking AS
(
           SELECT     n.NAME AS actress_name,
                      total_votes,
                      Count(r.movie_id) AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie m
           INNER JOIN ratings r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           WHERE      category = 'ACTRESS'
           AND        country = "INDIA"
           AND        languages LIKE '%HINDI%'
           GROUP BY   NAME
           HAVING     movie_count>=3 )
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_ranking LIMIT 5;


-- Q23.Ans: Taapsee Pannu tops the list of actresses in Hindi movies released in India based on their average ratings

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/



/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    title,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN avg_rating < 5 THEN 'Flop movies'
    END AS avg_rating_category
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    genre = 'thriller';

-- Q24.Ans: Differentiated thriller movies in above mentioned format. 

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/



-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
-- Round is good to have and not a must have; Same thing applies to sorting

SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;

-- Q25.Ans: sorted data among genre-wise running total and moving average of the average movie duration

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

-- Top 3 Genres based on most number of movies

WITH top_3_genre AS
( 	
	SELECT genre, COUNT(movie_id) AS number_of_movies
    FROM genre AS g
    INNER JOIN movie AS m
    ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

top_5 AS
(
	SELECT genre,
			year,
			title AS movie_name,
			worlwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
        
	FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
	WHERE genre IN (SELECT genre FROM top_3_genre)
)

SELECT *
FROM top_5
WHERE movie_rank<=5;

-- Q26.Ans: Drama, Comedy, thriller mostly secured top positions by comparing all 3 years.

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.

-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
		COUNT(m.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie AS m 
INNER JOIN ratings AS r 
ON m.id=r.movie_id
WHERE median_rating>=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;

-- Q27.Ans: Star Cinema,Twentieth Century Fox production houses have produced the highest number of hits (median rating >= 8) among multilingual movies. 

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?

-- Type your code below:

SELECT name AS actress_name, SUM(total_votes) AS total_votes,
		COUNT(rm.movie_id) AS movie_count,
		avg_rating AS actress_avg_rating,
        DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS actress_rank
FROM names AS n
INNER JOIN role_mapping AS rm
ON n.id = rm.name_id
INNER JOIN ratings AS r
ON r.movie_id = rm.movie_id
INNER JOIN genre AS g
ON r.movie_id = g.movie_id
WHERE category = 'actress' AND avg_rating > 8 AND genre = 'drama'
GROUP BY name
LIMIT 3;

-- Q28.Ans: Sangeetha Bhat, Fatmire Sahiti, Adriana Matoshi are the top 3 actresses based on number of Super Hit movies in drama genre. 


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH movie_date_info AS
(
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
	 JOIN names AS n 
     ON d.name_id=n.id 
	 JOIN movie AS m 
     ON d.movie_id=m.id
),

date_difference AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_difference
	 GROUP BY name_id
 ),
 
 final_result AS
 (
	 SELECT d.name_id AS director_id,
		 name AS director_name,
		 COUNT(d.movie_id) AS number_of_movies,
		 ROUND(avg_inter_movie_days) AS inter_movie_days,
		 ROUND(AVG(avg_rating),2) AS avg_rating,
		 SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,
		 MAX(avg_rating) AS max_rating,
		 SUM(duration) AS total_duration,
		 ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	 FROM
		 names AS n 
         JOIN director_mapping AS d 
         ON n.id=d.name_id
		 JOIN ratings AS r 
         ON d.movie_id=r.movie_id
		 JOIN movie AS m 
         ON m.id=r.movie_id
		 JOIN avg_inter_days AS a 
         ON a.name_id=d.name_id
	 GROUP BY director_id
 )
 SELECT *	
 FROM final_result
 LIMIT 9;

-- Q29.Ans: mentioned all the details for top 9 directors (based on number of movies).





