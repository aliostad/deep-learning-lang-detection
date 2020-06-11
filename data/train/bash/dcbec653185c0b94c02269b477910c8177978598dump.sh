for repo in "group1" "group2" "group3" "group4" "group5" "group6" "group7" "group8" "group9"
do sqlite3 -csv ${repo}.db "select * from milestone;" > ./dmp/${repo}_milestone.csv
sqlite3 -csv ${repo}.db "select * from issue;" > ./dmp/${repo}_issue.csv
sqlite3 -csv ${repo}.db "select * from event;" > ./dmp/${repo}_event.csv
sqlite3 -csv ${repo}.db "select * from comment;" > ./dmp/${repo}_comment.csv
sqlite3 -csv ${repo}.db "select * from commits;" > ./dmp/${repo}_commits.csv
done
find ./dmp/ -size  0 -exec rm '{}' \;
