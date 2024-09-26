# ---------------------------------------------DATA CLEANING ----------------------------------------------------------------
# ------------------------------------- SPOTIFY MOST STREAMED SONGS 2024 ----------------------------------------------------------------

--  Creating a Copy  --
CREATE TABLE most_streamed_songs_cleaned
LIKE most_streamed_songs;

INSERT INTO most_streamed_songs_cleaned
SELECT * FROM most_streamed_songs;
----------------------------------------------------------------------------------------------------------------------------

-- Blanks Into NULL --
UPDATE most_streamed_songs_cleaned
SET 
Track = CASE WHEN Track = '' THEN NULL ELSE Track END,
Artist = CASE WHEN Artist = '' THEN NULL ELSE Artist END,
All_Time_Rank = CASE WHEN All_Time_Rank = '' THEN NULL ELSE All_Time_Rank END,
Track_Score = CASE WHEN Track_Score = '' THEN NULL ELSE Track_Score END,
Spotify_Streams = CASE WHEN Spotify_Streams = '' THEN NULL ELSE Spotify_Streams END,
Spotify_Playlist_Count = CASE WHEN Spotify_Playlist_Count = '' THEN NULL ELSE Spotify_Playlist_Count END,
Spotify_Playlist_Reach = CASE WHEN Spotify_Playlist_Reach = '' THEN NULL ELSE Spotify_Playlist_Reach END,
Spotify_popularity = CASE WHEN Spotify_popularity = '' THEN NULL ELSE Spotify_popularity END,
Youtube_Views = CASE WHEN Youtube_Views = '' THEN NULL ELSE Youtube_Views END,
Youtube_Likes = CASE WHEN Youtube_Likes = '' THEN NULL ELSE Youtube_Likes END;

----------------------------------------------------------------------------------------------------------------------------------

-- Delete Duplicates --

CREATE TABLE `most_streamed_songs_cleaned2` (
  `Track` varchar(50) DEFAULT NULL,
  `Artist` varchar(100) DEFAULT NULL,
  `Release_Date` date DEFAULT NULL,
  `All_Time_Rank` varchar(50) DEFAULT NULL,
  `Track_Score` float DEFAULT NULL,
  `Spotify_Streams` bigint DEFAULT NULL,
  `Spotify_Playlist_Count` bigint DEFAULT NULL,
  `Spotify_Playlist_Reach` bigint DEFAULT NULL,
  `Spotify_popularity` int DEFAULT NULL,
  `Youtube_Views` bigint DEFAULT NULL,
  `Youtube_Likes` bigint DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO most_streamed_songs_cleaned2
SELECT * ,
row_number() OVER(PARTITION BY Artist , Track , Release_Date , All_Time_Rank , Track_Score ,
 Spotify_Streams , Spotify_Playlist_Count , Spotify_Playlist_Reach , Spotify_popularity 
,Youtube_Views , Youtube_Likes order by All_Time_Rank) AS rn
from most_streamed_songs_cleaned;

SELECT *
FROM most_streamed_songs_cleaned2
WHERE row_num >1 ;

DELETE 
FROM most_streamed_songs_cleaned2
WHERE row_num >1;
----------------------------------------------------------------------------------------------------------------------------------

-- Standardizing --
DESCRIBE most_streamed_songs_cleaned;

UPDATE most_streamed_songs_cleaned
SET Release_Date = STR_TO_DATE(Release_Date , '%m/%d/%Y');
ALTER TABLE most_streamed_songs_cleaned
MODIFY Release_Date Date;

ALTER TABLE most_streamed_songs_cleaned
MODIFY Track_Score float;

UPDATE most_streamed_songs_cleaned
SET Spotify_Streams = REPLACE(Spotify_Streams , ',' , '' ),
Spotify_Playlist_Count = REPLACE(Spotify_Playlist_Count , ',' , '' ),
Spotify_Playlist_Reach = REPLACE(Spotify_Playlist_Reach , ',' , '' ),
Youtube_Views = REPLACE(Youtube_Views , ',' , '' ),
Youtube_Likes = REPLACE(Youtube_Likes , ',' , '' );

ALTER TABLE most_streamed_songs_cleaned
MODIFY Track_Score float,
MODIFY Spotify_Streams BIGINT,
MODIFY Spotify_Playlist_Count BIGINT,
MODIFY Spotify_Playlist_Reach BIGINT,
MODIFY Spotify_popularity int,
MODIFY Youtube_Views BIGINT,
MODIFY Youtube_Likes BIGINT;

---------------------------------------------------------------------------------------------------------------------------

-- Replace Null Values in a Column --
SELECT Artist , AVG(Spotify_Popularity)
FROM most_streamed_songs_cleaned
WHERE Spotify_popularity IS NOT NULL
GROUP BY Artist;

UPDATE most_streamed_songs_cleaned AS p
JOIN(
SELECT Artist , AVG(Spotify_popularity) AS Average_Popularity
FROM most_streamed_songs_cleaned
WHERE Spotify_popularity IS NOT NULL
GROUP BY Artist
) AS Avg_Popularity
ON p.Artist = Avg_Popularity.Artist
SET p.Spotify_popularity = avg_popularity.Average_Popularity
WHERE p.Spotify_popularity IS NULL;

------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE most_streamed_songs_cleaned2
DROP column row_num;

ALTER TABLE most_streamed_songs_cleaned2
RENAME most_streamed_songs_cleaned;

drop table most_streamed_songs_cleaned
