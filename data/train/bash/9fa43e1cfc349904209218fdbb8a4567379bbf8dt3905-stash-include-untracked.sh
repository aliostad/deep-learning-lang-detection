ok 1 - stash save --include-untracked some dirty working directory
ok 2 - stash save --include-untracked cleaned the untracked files
ok 3 - stash save --include-untracked stashed the untracked files
ok 4 - stash save --patch --include-untracked fails
ok 5 - stash save --patch --all fails
ok 6 - stash pop after save --include-untracked leaves files untracked again
ok 7 - stash save -u dirty index
ok 8 - stash save --include-untracked dirty index got stashed
ok 9 - stash save --include-untracked -q is quiet
ok 10 - stash save --include-untracked removed files
ok 11 - stash save --include-untracked removed files got stashed
ok 12 - stash save --include-untracked respects .gitignore
ok 13 - stash save -u can stash with only untracked files different
ok 14 - stash save --all does not respect .gitignore
ok 15 - stash save --all is stash poppable
# passed all 15 test(s)
1..15
