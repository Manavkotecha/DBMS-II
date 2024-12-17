-- Create Tables
CREATE TABLE Artists (
 Artist_id INT PRIMARY KEY,
 Artist_name NVARCHAR(50)
);
CREATE TABLE Albums (
 Album_id INT PRIMARY KEY,
 Album_title NVARCHAR(50),
 Artist_id INT,
 Release_year INT,
 FOREIGN KEY (Artist_id) REFERENCES Artists(Artist_id)
);
CREATE TABLE Songs (
 Song_id INT PRIMARY KEY,
 Song_title NVARCHAR(50),
 Duration DECIMAL(4, 2),
 Genre NVARCHAR(50),
 Album_id INT,
 FOREIGN KEY (Album_id) REFERENCES Albums(Album_id)
);

INSERT INTO Artists (Artist_id, Artist_name) VALUES
(1, 'Aparshakti Khurana'),
(2, 'Ed Sheeran'),
(3, 'Shreya Ghoshal'),
(4, 'Arijit Singh'),
(5, 'Tanishk Bagchi');
-- Insert Data into Albums Table
INSERT INTO Albums (Album_id, Album_title, Artist_id, Release_year) VALUES (1007, 'Album7', 1, 2015),
(1001, 'Album1', 1, 2019),
(1002, 'Album2', 2, 2015),
(1003, 'Album3', 3, 2018),
(1004, 'Album4', 4, 2020),
(1005, 'Album5', 2, 2020),
(1006, 'Album6', 1, 2009);
-- Insert Data into Songs Table
INSERT INTO Songs (Song_id, Song_title, Duration, Genre, Album_id) VALUES
(101, 'Zaroor', 2.55, 'Feel good', 1001),
(102, 'Espresso', 4.10, 'Rhythmic', 1002),
(103, 'Shayad', 3.20, 'Sad', 1003),
(104, 'Roar', 4.05, 'Pop', 1002),
(105, 'Everybody Talks', 3.35, 'Rhythmic', 1003),
(106, 'Dwapara', 3.54, 'Dance', 1002),
(107, 'Sa Re Ga Ma', 4.20, 'Rhythmic', 1004),
(108, 'Tauba', 4.05, 'Rhythmic', 1005),
(109, 'Perfect', 4.23, 'Pop', 1002),
(110, 'Good Luck', 3.55, 'Rhythmic', 1004);

--Part – A
--1. Retrieve a unique genre of songs.
SELECT DISTINCT Genre FROM Songs;

--2. Find top 2 albums released before 2010.
SELECT TOP 2 * 
FROM Albums
WHERE Release_year < 2010
ORDER BY Release_year;

--3. Insert Data into the Songs Table. (1245, ‘Zaroor’, 2.55, ‘Feel good’, 1005)
INSERT INTO Songs (Song_id, Song_title, Duration, Genre, Album_id) 
VALUES (1245, 'Zaroor', 2.55, 'Feel good', 1005);

--4. Change the Genre of the song ‘Zaroor’ to ‘Happy’
UPDATE Songs 
SET Genre = 'Happy' 
WHERE Song_title = 'Zaroor';

--5. Delete an Artist ‘Ed Sheeran’
DELETE FROM Artists 
WHERE Artist_name = 'Ed Sheeran';

--6. Add a New Column for Rating in Songs Table. [Ratings decimal(3,2)]
ALTER TABLE Songs 
ADD Rating DECIMAL(3,2);

--7. Retrieve songs whose title starts with 'S'.
SELECT * 
FROM Songs 
WHERE Song_title LIKE 'S%';

--8. Retrieve all songs whose title contains 'Everybody'.
SELECT * 
FROM Songs 
WHERE Song_title LIKE '%Everybody%';

--9. Display Artist Name in Uppercase.
SELECT UPPER(Artist_name) AS Artist_name_upper 
FROM Artists;

--10. Find the Square Root of the Duration of a Song ‘Good Luck’
SELECT SQRT(Duration) AS Duration_SQRT 
FROM Songs 
WHERE Song_title = 'Good Luck';

--11. Find Current Date.
SELECT GETDATE() AS Curr_Date;

--12. Find the number of albums for each artist.
SELECT Artist_id, COUNT(*) AS Album_Count 
FROM Albums 
GROUP BY Artist_id;

--13. Retrieve the Album_id which has more than 5 songs in it.
SELECT Album_id 
FROM Songs 
GROUP BY Album_id 
HAVING COUNT(*) > 5;

--14. Retrieve all songs from the album 'Album1'. (using Subquery)
SELECT * 
FROM Songs 
WHERE Album_id = (SELECT Album_id FROM Albums WHERE Album_title = 'Album1');

--15. Retrieve all albums name from the artist ‘Aparshakti Khurana’ (using Subquery)
SELECT Album_title 
FROM Albums 
WHERE Artist_id = (SELECT Artist_id FROM Artists WHERE Artist_name = 'Aparshakti Khurana');

--16. Retrieve all the song titles with its album title.
SELECT S.Song_title, A.Album_title 
FROM Songs S 
JOIN Albums A ON S.Album_id = A.Album_id;

--17. Find all the songs which are released in 2020.
SELECT S.* 
FROM Songs S 
JOIN Albums A ON S.Album_id = A.Album_id 
WHERE A.Release_year = 2020;

--18. Create a view called ‘Fav_Songs’ from the songs table having songs with song_id 101-105.
CREATE VIEW Fav_Songs as 
SELECT * 
FROM Songs 
WHERE Song_id BETWEEN 101 AND 105;

--19. Update a song name to ‘Jannat’ of song having song_id 101 in Fav_Songs view.
UPDATE Songs 
SET Song_title = 'Jannat' 
WHERE Song_id = 101;

--20. Find all artists who have released an album in 2020. 
SELECT DISTINCT Artist_name 
FROM Artists A 
JOIN Albums AL ON A.Artist_id = AL.Artist_id 
WHERE AL.Release_year = 2020;

--21. Retrieve all songs by Shreya Ghoshal and order them by duration. 
SELECT S.* 
FROM Songs S 
JOIN Albums A ON S.Album_id = A.Album_id 
JOIN Artists AR ON A.Artist_id = AR.Artist_id 
WHERE AR.Artist_name = 'Shreya Ghoshal' 
ORDER BY S.Duration;

--Part – B
--22. Retrieve all song titles by artists who have more than one album. 
SELECT DISTINCT S.Song_title 
FROM Songs S 
JOIN Albums A ON S.Album_id = A.Album_id 
WHERE A.Artist_id IN (SELECT Artist_id FROM Albums GROUP BY Artist_id HAVING COUNT(*) > 1);

--23. Retrieve all albums along with the total number of songs. 
SELECT A.Album_title, COUNT(S.Song_id) AS Total_Songs 
FROM Albums A 
LEFT JOIN Songs S ON A.Album_id = S.Album_id 
GROUP BY A.Album_title;

--24. Retrieve all songs and release year and sort them by release year. 
SELECT S.Song_title, A.Release_year 
FROM Songs S 
JOIN Albums A ON S.Album_id = A.Album_id 
ORDER BY A.Release_year;

--25. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs.
SELECT Genre, COUNT(*) AS Song_Count 
FROM Songs 
GROUP BY Genre 
HAVING COUNT(*) > 2;

--26. List all artists who have albums that contain more than 3 songs.
SELECT DISTINCT AR.Artist_name 
FROM Artists AR 
JOIN Albums AL ON AR.Artist_id = AL.Artist_id 
WHERE AL.Album_id IN (SELECT Album_id FROM Songs GROUP BY Album_id HAVING COUNT(*) > 3);

--Part – C
--27. Retrieve albums that have been released in the same year as 'Album4'
SELECT Album_title 
FROM Albums 
WHERE Release_year = (SELECT Release_year FROM Albums WHERE Album_title = 'Album4');

--28. Find the longest song in each genre
SELECT Genre, MAX(Duration) AS Longest_Duration 
FROM Songs 
GROUP BY Genre;

--29. Retrieve the titles of songs released in albums that contain the word 'Album' in the title.
SELECT S.Song_title 
FROM Songs S 
JOIN Albums A ON S.Album_id = A.Album_id 
WHERE A.Album_title LIKE '%Album%';

--30. Retrieve the total duration of songs by each artist where total duration exceeds 15 minutes
SELECT AR.Artist_name, SUM(S.Duration) AS Total_Duration 
FROM Songs S 
JOIN Albums AL ON S.Album_id = AL.Album_id 
JOIN Artists AR ON AL.Artist_id = AR.Artist_id 
GROUP BY AR.Artist_name 
HAVING SUM(S.Duration) > 15;
