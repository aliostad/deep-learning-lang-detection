for repo in "group-b" "group-c" "group-f" "group-g" "group-i" "group-m"
do sqlite3 -csv ../data/databases/${repo}.db "select * from milestone;" > ../data/dmp/${repo}_milestone.csv
sqlite3 -csv ../data/databases/${repo}.db "select * from issue;" > ../data/dmp/${repo}_issue.csv
sqlite3 -csv ../data/databases/${repo}.db "select * from event;" > ../data/dmp/${repo}_event.csv
sqlite3 -csv ../data/databases/${repo}.db "select * from comment;" > ../data/dmp/${repo}_comment.csv
sqlite3 -csv ../data/databases/${repo}.db "select * from commits;" > ../data/dmp/${repo}_commits.csv
done
find ../data/dmp/ -size  0 -exec rm '{}' \;