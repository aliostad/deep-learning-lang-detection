Initialized empty Git repository in /Users/trast/git-smoke/t/trash directory.t0024-crlf-archive/.git/
expecting success: 

	git config core.autocrlf true &&

	printf "CRLF line ending
And another
" > sample &&
	git add sample &&

	test_tick &&
	git commit -m Initial
[master (root-commit) 4f7f1aa] Initial
 Author: A U Thor <author@example.com>
 1 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 sample

ok 1 - setup

expecting success: 

	git archive --format=tar HEAD |
	( mkdir untarred && cd untarred && "$TAR" -xf - ) &&

	test_cmp sample untarred/sample



ok 2 - tar archive

expecting success: 

	git archive --format=zip HEAD >test.zip &&

	( mkdir unzipped && cd unzipped && unzip ../test.zip ) &&

	test_cmp sample unzipped/sample


Archive:  ../test.zip
4f7f1aaec1ee996d8f5e13c2cfbd43a378578e1f
 extracting: sample                  

ok 3 - zip archive

# passed all 3 test(s)
1..3
