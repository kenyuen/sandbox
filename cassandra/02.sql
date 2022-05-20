-- partitions
USE killrvideo;

DESCRIBE TABLE videos;

/*
   partition key = video_id
   # of partitions = 5
 */

SELECT token(video_id), video_id
FROM videos;

CREATE TABLE videos_by_tag ( 
    tag text ,
    video_id timeuuid , 
    added_date timestamp , 
    Title text,
    primary key (tag, video_id)
    ) ;

COPY videos_by_tag(tag, video_id, added_date, title)
     FROM '/home/ubuntu/labwork/data-files/videos-by-tag.csv'
     WITH HEADER = TRUE;

SELECT * from videos_by_tag
    WHERE tag='cassandra';

SELECT * from videos_by_tag
    WHERE tag='datastax';

SELECT * from videos_by_tag
    WHERE Title='Cassandra Intro' allow filtering;