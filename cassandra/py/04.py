from cassandra.cluster import Cluster
cluster = Cluster(protocol_version = 3)
session = cluster.connect('killrvideo')

print('{0:12} {1:40} {2:5}'.format('Tag', 'ID', 'Title'))
for val in session.execute("select * from videos_by_tag"):
    print('{0:12} {1:40} {2:5}'.format(val[0], val[2], val[3]))

session.execute("""
    insert into videos_by_tag (tag, video_id, added_date, Title) values
    ('cassandra',1645ea59-14bd-11e5-a993-8138354b7e41,'2020-01-29','Cassandra History2');
    """)

result = session.execute("""
    SELECT * FROM videos_by_tag
""")[0]
print result.tag, result.video_id, result.added_date

print('{0:12} {1:40} {2:5}'.format('Tag', 'ID', 'Title'))
for val in session.execute("select * from videos_by_tag"):
    print('{0:12} {1:40} {2:5}'.format(val[0], val[2], val[3]))

session.execute("""
    delete from videos_by_tag
    where tag = 'cassandra' and added_date = '2020-01-29' and video_id =1645ea59-14bd-11e5-a993-8138354b7e41;
    """)

print('{0:12} {1:40} {2:5}'.format('Tag', 'ID', 'Title'))
for val in session.execute("select * from videos_by_tag"):
    print('{0:12} {1:40} {2:5}'.format(val[0], val[2], val[3]))
