-- Clustering columns drives orders after partitioning columns and queries must follow that order.

DROP TABLE videos_by_tag;

CREATE TABLE videos_by_tag ( 
    tag text ,
    video_id timeuuid , 
    added_date timestamp , 
    Title text,
    primary key ((tag), added_date, video_id))
    WITH CLUSTERING ORDER BY (added_date DESC)
    ;

COPY videos_by_tag(tag, video_id, added_date, title)
   FROM '/home/ubuntu/labwork/data-files/videos-by-tag.csv'
   WITH HEADER = TRUE;

SELECT * from videos_by_tag;   

select * from videos_by_tag 
where tag IN ('cassandra')
order by added_date asc;

select * from videos_by_tag
where tag='cassandra';

select * from videos_by_tag
where added_date > '2013-01-01'
allow filtering;


