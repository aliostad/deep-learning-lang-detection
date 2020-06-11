module TestExamples

//let testdata = """ [
//{ 
//{"cmd": "aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa", "err": "", "fix": "aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa"},
//{"cmd": "aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa", "err": "", "fix": "aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa"},
//{"cmd": "aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa", "err": "", "fix": "aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa"}
//>>>>>>> 341df733e4aa5a30c17a4da034a736de53e5410c
//}]"""

let varEqTestData = """ [
[
 {"cmd": "a a a a a a", "err": "", "fix": "x" }, 
 {"cmd": "a a a b a b", "err": "", "fix": "x" },
 {"cmd": "a a a c a c", "err": "", "fix": "x" }
]]"""

let testdata1 = """ [
{ 
 {"cmd": "java file.java", "err": "could not find or locate class", "fix": "java file" }, 
 {"cmd": "java bcd.java", "err": "could not find or locate class", "fix": "java bcd"},
 {"cmd": "java a.java", "err": "could not find or locate class", "fix": "java a"}
}]"""


let testdata = """ [
[
 {"cmd": "java file.java", "err": "could not find or load main class", "fix": "java file" }, 
 {"cmd": "java bcd.java", "err": "could not find or load main class", "fix": "java bcd"},
 {"cmd": "java a.java", "err": "could not find or load main class", "fix": "java a"}
],
[
 {"cmd": "apt-get abc", "err": "command not found", "fix": "sudo apt-get install abc"},
 {"cmd": "apt-get qwerty", "err": "command not found", "fix": "sudo apt-get install qwerty"},
 {"cmd": "apt-get xyzz", "err": "command not found", "fix": "sudo apt-get install xyzz"}
],
[
 {"cmd": "brew upgrade", "err": "Warning: brew upgrade with no arguments will change behaviour soon!", "fix": "brew upgrade -all"},
 {"cmd": "brew upgrade", "err": "Warning: brew upgrade with no arguments will change behaviour soon!", "fix": "brew upgrade -all"},
 {"cmd": "brew upgrade", "err": "Warning: brew upgrade with no arguments will change behaviour soon!", "fix": "brew upgrade -all"}
],
[
{"cmd": "cargo", "err": "", "fix": "cargo build"},
{"cmd": "cargo", "err": "", "fix": "cargo build"},
{"cmd": "cargo", "err": "", "fix": "cargo build"}
],
[
{"cmd": "cargo bla", "err": "'No such subcommand' in command.stderr and 'Did you mean bla')", "fix": "bla"},
{"cmd": "cargo stuff", "err": "'No such subcommand' in command.stderr and 'Did you mean stuff')", "fix": "stuff"},
{"cmd": "cargo other42", "err": "'No such subcommand' in command.stderr and 'Did you mean other42')", "fix": "other42"}
],
[
{"cmd": "cd files", "err": "-bash: cd: files: no such file or directory", "fix": "mkdir files; cd files"},
{"cmd": "cd code", "err": "-bash: cd: code: no such file or dir", "fix": "mkdir code; cd code"},
{"cmd": "cd xray", "err": "-bash: cd: xray: no such file or dir", "fix": "mkdir xray; cd xray"}
],
[
{"cmd": "cd..", "err": "-bash: cd..: command not found", "fix": "cd .."},
{"cmd": "cd..", "err": "-bash: cd..: command not found", "fix": "cd .."},
{"cmd": "cd..", "err": "-bash: cd..: command not found", "fix": "cd .."}
],
[
{"cmd": "cp src dst", "err": "cp: omitting directory `fbxrd'", "fix": "cp -r src dst"},
{"cmd": "cp from to", "err": "cp: omitting directory `qwn'", "fix": "cp -r from to"},
{"cmd": "cp a b", "err": "cp: omitting directory `xyzy'", "fix": "cp -r a b"}
],
[
{"cmd": "g++ blabla.cpp", "err": "In file included from /usr/include/c++/4.4/random:35,
                 from blabla.cpp:3:
/usr/include/c++/4.4/c++0x_warning.h:31:2: error: #error This file requires compiler and library support for the upcoming ISO C++ standard, C++0x. 
This support is currently experimental, and must be enabled with the -std=c++0x or -std=gnu++0x compiler options.", "fix": "g++ -std=c++11 blabla"},
{"cmd": "g++ etc.cpp", "err": "In file included from /usr/include/c++/4.4/random:35,
                 from etc.cpp:3:
/usr/include/c++/4.4/c++0x_warning.h:31:2: error: #error This file requires compiler and library support for the upcoming ISO C++ standard, C++0x. 
This support is currently experimental, and must be enabled with the -std=c++0x or -std=gnu++0x compiler options.", "fix": "g++ -std=c++11 etc"},
{"cmd": "g++ xyzz.cpp", "err": "In file included from /usr/include/c++/4.4/random:35,
                 from xyzz.cpp:3:
/usr/include/c++/4.4/c++0x_warning.h:31:2: error: #error This file requires compiler and library support for the upcoming ISO C++ standard, C++0x. 
This support is currently experimental, and must be enabled with the -std=c++0x or -std=gnu++0x compiler options.", "fix": "g++ -std=c++11 xyzz"}
],
[
{"cmd": "clang++ abcabc", "err": "abcabc.cpp:2:3: warning: 'auto' type specifier is a C++11 extension [-Wc++11-extensions]", "fix": "clang++ -std=c++11 abcabc"},
{"cmd": "clang++ cbad", "err": "cbad.cpp:2:3: warning: 'auto' type specifier is a C++11 extension [-Wc++11-extensions]", "fix": "clang++ -std=c++11 cbad"},
{"cmd": "clang++ xyz", "err": "xyz.cpp:2:3: warning: 'auto' type specifier is a C++11 extension [-Wc++11-extensions]", "fix": "clang++ -std=c++11 xyz"}
],
[
{"cmd": "bash abcabc.sh", "err": "/etc/init.d/abcabc.sh: line 2: $'\r': command not found /etc/init.d/abcabc.sh:", "fix": "dos2unix abcabc.sh; bash abcabc.sh"},
{"cmd": "bash cbad.sh", "err": "/etc/cbad.sh: line 13: $'\r': command not found /etc/cbad.sh", "fix": "dos2unix cbad.sh; bash cbad.sh"},
{"cmd": "bash xyz.sh", "err": "/etc/etc/etc/xyz.sh: line 134: $'\r': command not found /etc/etc/etc/xyz.sh", "fix": "dos2unix xyz.sh; bash xyz.sh"}
],
[
{"cmd": "./manage.py", "err": "-bash: ./manage.py: Permission denied", "fix": "chmod +x manage.py; ./manage.py"},
{"cmd": "./asdf.py", "err": "-bash: ./asdf.py: Permission denied", "fix": "chmod +x asdf.py; ./asdf.py"},
{"cmd": "./xyz.py", "err": "-bash: ./xyz.py: Permission denied", "fix": "chmod +x xyz.py; ./xyz.py"}
],
[
{"cmd": "./manage.py", "err": "-bash: ./manage.py: Permission denied", "fix": "python manage.py"},
{"cmd": "./asdf.py", "err": "-bash: ./asdf.py: Permission denied", "fix": "python asdf.py"},
{"cmd": "./xyz.py", "err": "-bash: ./xyz.py: Permission denied", "fix": "python xyz.py"}
],
[
{"cmd": "./manage.py migrate myapp", "err": "django.db.utils.DatabaseError: table 'myapp_tablename' already exists", "fix": "./manage.py migrate myapp --fake"},
{"cmd": "./manage.py migrate anapp1", "err": "django.db.utils.DatabaseError: table 'anapp1_tablename2' already exists", "fix": "./manage.py migrate anapp1 --fake"},
{"cmd": "./manage.py migrate xyzapp11", "err": "django.db.utils.DatabaseError: table 'xyzapp11_tablename22' already exists", "fix": "./manage.py migrate xyzapp11 --fake"}
],
[
{"cmd": "python manage.py migrate reserve", "err": "south.exceptions.GhostMigrations: ! These migrations are in the database but not on disk: <reserve: 0002_initial> ! with the south_migrationhistory table, or pass --delete-ghost-migrations", "fix": "python manage.py migrate reserve --delete-ghost-migrations"},
{"cmd": "python manage.py migrate reserve", "err": "south.exceptions.GhostMigrations: ! These migrations are in the database but not on disk: <reserve: 0002_initial> ! with the south_migrationhistory table, or pass --delete-ghost-migrations", "fix": "python manage.py migrate reserve --delete-ghost-migrations"},
{"cmd": "python manage.py migrate reserve", "err": "south.exceptions.GhostMigrations: ! These migrations are in the database but not on disk: <reserve: 0002_initial> ! with the south_migrationhistory table, or pass --delete-ghost-migrations", "fix": "python manage.py migrate reserve --delete-ghost-migrations"}
],
[
{"cmd": "git commit file", "err": "error: pathspec 'application/libraries/file' did not match any file(s) known to git.", "fix": "git add file; git commit file"},
{"cmd": "git commit afile1", "err": "error: pathspec 'application/libra/afile1' did not match any file(s) known to git.", "fix": "git add afile1; git commit afile1"},
{"cmd": "git commit bfile12", "err": "error: pathspec 'application/libra2/bfile12' did not match any file(s) known to git.", "fix": "git add bfile12; git commit bfile12"}
],
[
{"cmd": "git branch -d testing", "err": "error: The branch 'testing' is not fully merged. If you are sure you want to delete it, run 'git branch -D testing'.", "fix": "git branch -D testing"},
{"cmd": "git branch -d featurebranch", "err": "error: The branch 'featurebranch' is not fully merged. If you are sure you want to delete it, run 'git branch -D featurebranch'.", "fix": "git branch -D featurebranch"},
{"cmd": "git branch -d bugfix", "err": "error: The branch 'bugfix' is not fully merged. If you are sure you want to delete it, run 'git branch -D bugfix'.", "fix": "git branch -D bugfix"}
],
[
{"cmd": "git branch list", "err": "", "fix": "git branch --delete list; git branch"},
{"cmd": "git branch somelist1", "err": "", "fix": "git branch --delete somelist1; git branch"},
{"cmd": "git branch abc", "err": "", "fix": "git branch --delete abc; git branch"}
],
[
{"cmd": "git diff", "err": "", "fix": "git diff --staged"},
{"cmd": "git diff", "err": "", "fix": "git diff --staged"},
{"cmd": "git diff", "err": "", "fix": "git diff --staged"}
],
[
{"cmd": "git status abcabc", "err": "(use 'git reset HEAD <file>...' to unstage)", "fix": "git reset abc; git checkout abcabc"},
{"cmd": "git status cbad", "err": "(use 'git reset HEAD <file>...' to unstage)", "fix": "git reset cba; git checkout cbad"},
{"cmd": "git status xyz", "err": "(use 'git reset HEAD <file>...' to unstage)", "fix": "git reset xyz; git checkout xyz"}
],
[
{"cmd": "git pull abcabc", "err": "fatal: Not a git repository' in command.stderr and 'Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).", "fix": "git clone abcabc"},
{"cmd": "git pull cbad", "err": "fatal: Not a git repository' in command.stderr and 'Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).", "fix": "git clone cbad"},
{"cmd": "git pull xyz", "err": "fatal: Not a git repository' in command.stderr and 'Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).", "fix": "git clone xyz"}
],
[
{"cmd": "git push", "err": "To https://github.com/lorisdanto/testRepo.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'https://github.com/lorisdanto/testRepo.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.", "fix": "git push --force"},
{"cmd": "git push", "err": "To https://github.com/MichaelBVaughn/someOtherThing.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'https://github.com/MichaelBVaughn/someOtherThing.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.", "fix": "git push --force"},
{"cmd": "git push", "err": "To https://bitbucket.org/MichaelBVaughn/aMiscProj.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'https://bitbucket.org/MichaelBVaughn/aMiscProj.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.", "fix": "git push --force"}
],
[
{"cmd": "git push", "err": "To https://github.com/MichaelBVaughn/testRepo.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'https://github.com/MichaelBVaughn/testRepo.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.", "fix": "git pull"},
{"cmd": "git push", "err": "To https://github.com/MichaelBVaughn/someOtherThing.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'https://github.com/MichaelBVaughn/someOtherThing.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.", "fix": "git pull"},
{"cmd": "git push", "err": "To https://github.com/MichaelBVaughn/aMiscProj.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'https://github.com/MichaelBVaughn/aMiscProj.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.", "fix": "git pull"}
],
[
{"cmd": "git pull", "err": "Updating 1..2
error: Your local changes to the following files would be overwritten by merge:
	foo2.txt
Please, commit your changes or stash them before you can merge.
Aborting
", "fix": "git stash"},
{"cmd": "git pull", "err": "Updating 40..50
error: Your local changes to the following files would be overwritten by merge:
	bar.txt
Please, commit your changes or stash them before you can merge.
Aborting
", "fix": "git stash"},
{"cmd": "git pull", "err": "Updating 200..501
error: Your local changes to the following files would be overwritten by merge:
	et.txt
Please, commit your changes or stash them before you can merge.
Aborting
", "fix": "git stash"}
],
[
{"cmd": "git add . -all", "err": "", "fix": "git add . --all"},
{"cmd": "git add . -all", "err": "", "fix": "git add . --all"},
{"cmd": "git add . -all", "err": "", "fix": "git add . --all"}
],
[
{"cmd": "git checkout gh-pages", "err": "error: Your local changes to the following files would be overwritten by checkout: somefile.txt, Please, commit your changes or stash them before you can switch branches.", "fix": "git checkout -f gh-pages"},
{"cmd": "git checkout proj", "err": "error: Your local changes to the following files would be overwritten by checkout: abc.java, Please, commit your changes or stash them before you can switch branches.", "fix": "git checkout -f proj"},
 {"cmd": "git checkout bravo", "err": "error: Your local changes to the following files would be overwritten by checkout: xyz.fs, Please, commit your changes or stash them before you can switch branches.", "fix": "git checkout -f bravo"}
],
[
{"cmd": "git checkout gh-pages", "err": "error: Your local changes to the following files would be overwritten by checkout: somefile.txt, Please, commit your changes or stash them before you can switch branches." ,"fix": "git reset --hard; git checkout gh-pages"},
{"cmd": "git checkout proj", "err": "error: Your local changes to the following files would be overwritten by checkout: abc.java, Please, commit your changes or stash them before you can switch branches.", "fix": "git reset --hard; git checkout proj"},
{"cmd": "git checkout bravo", "err": "error: Your local changes to the following files would be overwritten by checkout: xyz.fs, Please, commit your changes or stash them before you can switch branches.", "fix": "git reset --hard; git checkout bravo"}
],
[
{"cmd": "go run blabla", "err": "error: go run: no go files listed", "fix": "go run blabla.go"},
{"cmd": "go run abcd", "err": "error: go run: no go files listed", "fix": "go run abcd.go"},
{"cmd": "go run xyz", "err": "error: go run: no go files listed", "fix": "go run xyz.go"}
],
[
{"cmd": "heroku luck", "err": "!    `luck` is not a heroku command.
 !    Perhaps you meant `lock`.
 !    See `heroku help` for a list of available commands.", "fix": "heroku lock"},
{"cmd": "heroku ad", "err": "!    `ad` is not a heroku command.
 !    Perhaps you meant `da`.
 !    See `heroku help` for a list of available commands.", "fix": "heroku da"},
{"cmd": "heroku abc", "err": "!    `abc` is not a heroku command.
 !    Perhaps you meant `cba`.
 !    See `heroku help` for a list of available commands.", "fix": "heroku cba"}
],
[
{"cmd": "lein ropl", "err": "'ropl' is not a task. See 'lein help'.

Did you mean this?
         repl", "fix": "lein repl"},
{"cmd": "lein od", "err": "'od' is not a task. See 'lein help'.

Did you mean this?
         do", "fix": "lein do"},
{"cmd": "lein bar", "err": "'bar' is not a task. See 'lein help'.

Did you mean this?
         jar", "fix": "lein jar"}
],
[
{"cmd": "ls -l .blabla", "err": "", "fix": "ls -lah .blabla"},
{"cmd": "ls -l .abcd", "err": "", "fix": "ls -lah .abcd"},
{"cmd": "ls -l .xyz", "err": "", "fix": "ls -lah .xyz"}
],
[
{"cmd": "grep blabla", "err": "blabla is a directory", "fix": "grep blabla"},
{"cmd": "grep abcd", "err": "abcd is a directory", "fix": "grep abcd"},
{"cmd": "grep xyz", "err": "xyz is a directory", "fix": "grep xyz"}
],
[
{"cmd": "cmd.sh", "err": "-bash: cmd.sh: command not found", "fix": "./cmd.sh"},
{"cmd": "abcc.sh", "err": "-bash: abcc.sh: command not found", "fix": "./abcc.sh"},
{"cmd": "scanner.sh", "err": "-bash: scanner.sh: command not found", "fix": "./scanner.sh"}
],
[
{"cmd": "java foo.java", "err": "Error: Could not find or load main class foo.java", "fix": "java foo"},
{"cmd": "java xyzz.java", "err": "Error: Could not find or load main class xyzz.java", "fix": "java xyzz"},
{"cmd": "java abcdef.java", "err": "Error: Could not find or load main class abcdef.java", "fix": "java abcdef"}
],
[
{"cmd": "javac foo", "err": "error: Class names, 'foo', are only accepted if annotation processing is explicitly requested
1 error", "fix": "javac foo.java"},
{"cmd": "javac barr", "err": "error: Class names, 'barr', are only accepted if annotation processing is explicitly requested
1 error", "fix": "javac barr.java"},
{"cmd": "javac yadda", "err": "error: Class names, 'yadda', are only accepted if annotation processing is explicitly requested
1 error", "fix": "javac yadda.java"}
],
[
{"cmd": "manmkdir", "err": "-bash: manmkdir: command not found", "fix": "man mkdir"},
{"cmd": "manls", "err": "-bash: manmkdir: command not found", "fix": "man ls"},
{"cmd": "manstat", "err": "-bash: manstat: command not found", "fix": "man stat"}
],
[
{"cmd": "mkdir a/b", "err": "mkdir: cannot create directory '/a' : no such file or directory", "fix": "mkdir -p a/b"},
{"cmd": "mkdir bc/cd", "err": "mkdir: cannot create directory '/bc' : no such file or directory", "fix": "mkdir -p bc/cd"},
{"cmd": "mkdir xy/yzz", "err": "mkdir: cannot create directory '/xy' : no such file or directory", "fix": "mkdir -p xy/yzz"}
],
[
{"cmd": "mv a.txt dir/b.txt", "err": "cannot move 'a.txt' to 'dir/b.txt': Not a directory", "fix": "mkdir -p dir; mv a.txt dir/b.txt"},
{"cmd": "mv xyz.fs 1abc/cd.fs", "err": "cannot move 'xyz.fs' to '1abc/cd.fs': Not a directory", "fix": "mkdir -p 1abc; mv xyz.fs 1abc/cd.fs"},
{"cmd": "mv file.tar somestuff/bcd2.tar", "err": "cannot move 'file.tar' to 'somestuff/bcd2.tar': Not a directory", "fix": "mkdir -p somestuff; mv file.tar somestuff/bcd2.tar"}
],
[
{"cmd": "cp a.txt dir/b.txt", "err": "cannot move 'a.txt' to 'dir/b.txt': Not a directory", "fix": "mkdir -p dir; cp a.txt dir/b.txt"},
{"cmd": "cp xyz.fs abcde/cd.fsharp", "err": "cannot move 'xyz/fs' to 'abcde/cd.fsharp: Not a directory", "fix": "mkdir -p abcde; cp xyz.fs abcde/cd.fsharp"},
{"cmd": "cp file.tar somestuff/bcd2.tar", "err": "cannot move 'file.tar' to 'somestuff/bcd2.tar': Not a directory", "fix": "mkdir -p somestuff; cp file.tar somestuff/bcd2.tar"}
],
[
{"cmd": "open www.a.com", "err": "The file /Users/lorisdanto/www.a.com does not exist. Perhaps you meant 'http://www.a.com'?", "fix": "open http://www.a.com"},
{"cmd": "open www.bcd.com", "err": "The file /Users/bob/www.bcd.com does not exist. Perhaps you meant 'http://www.bcd.com'?", "fix": "open http://www.bcd.com"},
{"cmd": "open www.cdef.com", "err": "The file /Users/sumit/www.cde.com does not exist. Perhaps you meant 'http://www.cdef.com'?", "fix": "open http://www.cdef.com"}
],
[
{"cmd": "python blabla", "err": "python: can't open file 'blabla': [Errno 2] No such file or directory", "fix": "python blabla.py"},
{"cmd": "python xyzz", "err": "python: can't open file 'xyzz': [Errno 2] No such file or directory", "fix": "python xyzz.py"},
{"cmd": "python abc", "err": "python: can't open file 'abc': [Errno 2] No such file or directory", "fix": "python abc.py"}
],
[
{"cmd": "rm blabla", "err": "rm: blabla: is a directory", "fix": "rm -rf blabla"},
{"cmd": "rm xyzz", "err": "rm: xyzz: is a directory", "fix": "rm -rf xyzz"},
{"cmd": "rm abc", "err": "rm: abc: is a directory", "fix": "rm -rf abc"}
],
[
{"cmd": "pip instol", "err": "ERROR: unknown command ‘instol’ - maybe you meant ‘install’", "fix": "pip install"},
{"cmd": "pip xyzz", "err": "ERROR: unknown command ‘xyzz’ - maybe you meant ‘zzyx’", "fix": "pip zzyx"},
{"cmd": "pip abc", "err": "ERROR: unknown command ‘abc’ - maybe you meant ‘cba’", "fix": "pip cba"}
],
[
{"cmd": "sed aaa/bbb file.txt", "err": "sed: -e expression #1, char 53: unterminated `s' command", "fix": "sed aaa/bbb/ file.txt"},
{"cmd": "sed ca/bbc arthur.fs", "err": "sed: -e expression #1, char 6: unterminated `s' command", "fix": "sed ca/bbc/ arthur.fs"},
{"cmd": "sed xy/zy loris1b.py", "err": "sed: -e expression #1, char 427: unterminated `s' command", "fix": "sed xy/zy/ loris1b.py"}
],
[
{"cmd": "mknod blabla b 1 2", "err": "mknod: blabla: operation not permitted", "fix": "sudo mknod blabla b 1 2"},
{"cmd": "mknod qwe b 1 2", "err": "mknod: qwe: operation not permitted", "fix": "sudo mknod qwe b 1 2"},
{"cmd": "mknod xyzz b 1 2", "err": "mknod: xyzz: operation not permitted", "fix": "sudo mknod xyzz b 1 2"}
],
[
{"cmd": "test.py", "err": "command not found", "fix": "py.test"},
{"cmd": "test.py", "err": "command not found", "fix": "py.test"},
{"cmd": "test.py", "err": "command not found", "fix": "py.test"}
],
[
{"cmd": "tmux blabla", "err": "could be alp", "fix": "tmux alp"},
{"cmd": "tmux abc", "err": "could be beta", "fix": "tmux beta"},
{"cmd": "tmux xyzz", "err": "could be xray2", "fix": "tmux xray2"}
],
[
{"cmd": "vagrant blabla", "err": "VM must be running to open SSH connection. Run `vagrant up`
                               to start the virtual machine.", "fix": "vagrant up"},
{"cmd": "vagrant abcd", "err": "VM must be running to open SSH connection. Run `vagrant up`
                               to start the virtual machine.", "fix": "vagrant up"},
{"cmd": "vagrant xyz", "err": "VM must be running to open SSH connection. Run `vagrant up`
                               to start the virtual machine.", "fix": "vagrant up"}
],
[
{"cmd": "touch a/b.txt", "err": "touch: a/b.txt: no such file or dir", "fix": "mkdir -p a; touch a/b.txt"},
{"cmd": "touch gamma/beta.jpg", "err": "touch: gamma/beta.jpg: no such file or dir", "fix": "mkdir -p gamma; touch gamma/beta.jpg"},
{"cmd": "touch go/air.fs", "err": "touch: go/air.fs: no such file or dir", "fix": "mkdir -p go; touch go/air.fs"}
],
[
{"cmd": "tsuru app-abcabcabc", "err": "You're not authenticated or your session has expired. Please use \"login\" command for authentication", "fix": "tsuru login"},
{"cmd": "tsuru pool-xyzz", "err": "You're not authenticated or your session has expired. Please use \"login\" command for authentication", "fix": "tsuru login"},
{"cmd": "tsuru prog-log", "err": "You're not authenticated or your session has expired. Please use \"login\" command for authentication", "fix": "tsuru login"}
],
[
{"cmd": "abcdef", "err": "unkown command: Did you mean abcdfe", "fix": "abcdfe"},
{"cmd": "sl", "err": "unkown command: Did you mean ls", "fix": "ls"},
{"cmd": "jara", "err": "unkown command: Did you mean java", "fix": "java"}
],
[
{"cmd": "git config --global core.excludefile .gitignore_global", "err": ".gitignore not updated", "fix": "git config --global core.excludesfile ~/.gitignore_global"},
{"cmd": "git config --global core.excludefile .gitignore_global", "err": ".gitignore not updated", "fix": "git config --global core.excludesfile ~/.gitignore_global"},
{"cmd": "git config --global core.excludefile .gitignore_global", "err": ".gitignore not updated", "fix": "git config --global core.excludesfile ~/.gitignore_global"}
],
[
{"cmd": "git branch -d remotes/origin/bugfix", "err": "failed to delete remote branch", "fix": "git push origin --delete bugfix"},
{"cmd": "git branch -d remotes/origin/prog", "err": "failed to delete remote branch", "fix": "git push origin --delete prog"},
{"cmd": "git branch -d remotes/origin/xyz", "err": "failed to delete remote branch", "fix": "git push origin --delete xyz"}
],
[
{"cmd": "git branch -rd origin/bugfix", "err": "failed to delete remote branch", "fix": "git push origin --delete bugfix"},
{"cmd": "git branch -rd origin/prog", "err": "failed to delete remote branch", "fix": "git push origin --delete prog"},
{"cmd": "git branch -rd origin/xyz", "err": "failed to delete remote branch", "fix": "git push origin --delete xyz"}
],
[
{"cmd": "git push", "err": "unable to push changes remote branch", "fix": "git config --bool core.bare true; git push"},
{"cmd": "git push", "err": "unable to push changes remote branch", "fix": "git config --bool core.bare true; git push"},
{"cmd": "git push", "err": "unable to push changes remote branch", "fix": "git config --bool core.bare true; git push"}
],
[
{"cmd": "git pull https://loris:mypass@github.com/Test/test.git; git checkout 'mybranche1'", "err": "error: pathspec 'mybranche1' did not match any file(s) known to git.", "fix": "git clone <remote> ; git checkout mybranche1"},
{"cmd": "git pull https://marc:mypass@github.com/Test/test.git; git checkout 'prog'", "err": "error: pathspec 'prog' did not match any file(s) known to git.", "fix": "git clone <remote> ; git checkout prog"},
{"cmd": "git pull https://dan:mypass@github.com/Test/test.git; git checkout 'xyz'", "err": "error: pathspec 'xyz' did not match any file(s) known to git.", "fix": "git clone <remote> ; git checkout xyz"}
],
[
{"cmd": "git checkout $blahblah", "err": "fatal: git checkout: updating paths is incompatible with switching branches/forcing", "fix": "git checkout HEAD $blahblah"},
{"cmd": "git checkout $abcd", "err": "fatal: git checkout: updating paths is incompatible with switching branches/forcing", "fix": "git checkout HEAD $abcd"},
{"cmd": "git checkout $xyz", "err": "fatal: git checkout: updating paths is incompatible with switching branches/forcing", "fix": "git checkout HEAD $xyz"}
],
[
{"cmd": "git pull origin master", "err": "error: Couldn't set ORIG_HEAD. fatal: Cannot update the ref 'ORIG_HEAD'.", "fix": "git gc --prune=now"},
{"cmd": "git pull origin master", "err": "error: Couldn't set ORIG_HEAD. fatal: Cannot update the ref 'ORIG_HEAD'.", "fix": "git gc --prune=now"},
{"cmd": "git pull origin master", "err": "error: Couldn't set ORIG_HEAD. fatal: Cannot update the ref 'ORIG_HEAD'.", "fix": "git gc --prune=now"}
],
[
{"cmd": "git pull origin master", "err": "Your local changes to the following files would be overwritten by merge: user.v1234.suo", "fix": "git rm --cached user.v1234.suo"},
{"cmd": "git pull origin master", "err": "Your local changes to the following files would be overwritten by merge: user.abcd.suo", "fix": "git rm --cached user.abcd.suo"},
{"cmd": "git pull origin master", "err": "Your local changes to the following files would be overwritten by merge: user.xyz.suo", "fix": "git rm --cached user.xyz.suo"}
],
[
{"cmd": "git status", "err": "error: index file .git/objects/pack/pack-1 4.idx is too small", "fix": "git config repack.usedeltabaseoffset falsegit repack -a -d"},
{"cmd": "git status", "err": "error: index file .git/objects/pack/pack-2 123.idx is too small", "fix": "git config repack.usedeltabaseoffset falsegit repack -a -d"},
{"cmd": "git status", "err": "error: index file .git/objects/pack/pack-3 21.idx is too small", "fix": "git config repack.usedeltabaseoffset falsegit repack -a -d"}
],
[
{"cmd": "git push", "err": "error: RPC failed; result=22, HTTP code = 411", "fix": "git config http.postBuffer 524288000; git push"},
{"cmd": "git push", "err": "error: RPC failed; result=22, HTTP code = 411", "fix": "git config http.postBuffer 524288000; git push"},
{"cmd": "git push", "err": "error: RPC failed; result=22, HTTP code = 411", "fix": "git config http.postBuffer 524288000; git push"}
],
[
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn clean package"},
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn clean package"},
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn clean package"}
],
[
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn clean build"},
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn clean build"},
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn clean build"}
],
[
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn test"},
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn test"},
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn test"}
],
[
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn install"},
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn install"},
{"cmd": "mvn", "err": "No goals have been specified for this build", "fix": "mvn install"}
],
[
{"cmd": "opam update bla", "err": "[ERROR] No OPAM root found at /Users/michael/.opam.
        Please run 'opam init' to initialize the state of OPAM, or specify '--root'.
        See 'opam init --help' for details.", "fix": "opam init; opam update bla"},
{"cmd": "opam update abc", "err": "[ERROR] No OPAM root found at /Users/michael/.opam.
        Please run 'opam init' to initialize the state of OPAM, or specify '--root'.
        See 'opam init --help' for details.", "fix": "opam init; opam update abc"},
{"cmd": "opam update xyz", "err": "[ERROR] No OPAM root found at /Users/michael/.opam.
        Please run 'opam init' to initialize the state of OPAM, or specify '--root'.
        See 'opam init --help' for details.", "fix": "opam init; opam update xyz"}
],
[
{"cmd": "svn commit bla1bla", "err": "Path pathname is already locked by user 'admin' in filesystem", "fix": "svn cleanup"},
{"cmd": "svn commit abcd", "err": "Path pathname is already locked by user 'admin' in filesystem", "fix": "svn cleanup"},
{"cmd": "svn commit xyz", "err": "Path pathname is already locked by user 'admin' in filesystem", "fix": "svn cleanup"}
],
[
{"cmd": "svn commit blabla", "err": "item b1 is out of date", "fix": "svn update"},
{"cmd": "svn commit abcd", "err": "item ab3 is out of date", "fix": "svn update"},
{"cmd": "svn commit xyz", "err": "item db12 is out of date", "fix": "svn update"}
],
[
{"cmd": "svn revert 6253", "err": "Skipped '6253'", "fix": "svn update -r 6253"},
{"cmd": "svn revert 534", "err": "Skipped '534'", "fix": "svn update -r 534"},
{"cmd": "svn revert 41", "err": "Skipped '41'", "fix": "svn update -r 41"}
],
[
{"cmd": "svn update", "err": "Error updating changes: svn: E155021: The client is too old to work with the working copy at 'bcdef' (format 31).", "fix": "svn upgrade"},
{"cmd": "svn update", "err": "Error updating changes: svn: E155021: The client is too old to work with the working copy at 'abcd' (format 31).", "fix": "svn upgrade"},
{"cmd": "svn update", "err": "Error updating changes: svn: E155021: The client is too old to work with the working copy at 'xyz' (format 31).", "fix": "svn upgrade"}
],
[
{"cmd": "sudo mkdir /a/b/bin", "err": "mkdir: /a/b: No such file or directory mkdir: /a/b/bin: Operation not permitted", "fix": "mkdir -p /a/b/bin"},
{"cmd": "sudo mkdir /w/x/y/dir", "err": "mkdir: /w/x/y: No such file or directory mkdir: /w/x/y/dir: Operation not permitted", "fix": "mkdir -p /w/x/y/dir"},
{"cmd": "sudo mkdir /usr/rish/local/bin22", "err": "mkdir: /usr/rish/local: No such file or directory mkdir: /usr/rish/local/bin22: Operation not permitted", "fix": "mkdir -p /usr/rish/local/bin22"}
],
[
{"cmd": "sudo chown joannak:joannak ~/.config/configstore/insight-bower.json ", "err": "chown: joannak: illegal group name. ", "fix": "sudo chown joannak: ~/.config/configstore/insight-bower.json"},
{"cmd": "sudo chown lorisdan:lorisdan ~/.config/configstore/insight12.json ", "err": "chown: lorisdan: illegal group name. ", "fix": "sudo chown lorisdan: ~/.config/configstore/insight12.json"},
{"cmd": "sudo chown rish:rish ~/.config/configstore/insight1.json ", "err": "chown: rish: illegal group name. ", "fix": "sudo chown rish: ~/.config/configstore/insight1.json"}
]
,
[
{"cmd": "composer asdf", "err": "did you mean one of these? blabla1 blayadda2", "fix": "composer blabla1"},
{"cmd": "composer 1gamma", "err": "did you mean one of these? test game", "fix": "composer test"},
{"cmd": "composer 23xrayy", "err": "did you mean one of these? xyz zyx", "fix": "composer xyz"}
]
,
[
{"cmd": "./manage.py migrate myapp1", "err": "--merge: will just attempt the migration", "fix": "./manage.py migrate --merge myapp1"},
{"cmd": "./manage.py migrate emailprog", "err": "--merge: will just attempt the migration", "fix": "./manage.py migrate --merge emailprog"},
{"cmd": "./manage.py migrate voice", "err": "--merge: will just attempt the migration", "fix": "./manage.py migrate --merge voice"}
]
,
[
{"cmd": "whois en.wikipedia.org", "err": "", "fix": "whois wikipedia.org"},
{"cmd": "whois en.msn.net", "err": "", "fix": "whois msn.net"},
{"cmd": "whois en.google.com", "err": "", "fix": "whois google.com"}
]
,
[
{"cmd": "whois https://en.wikipedia.org", "err": "", "fix": "whois wikipedia.org"},
{"cmd": "whois https://en.msn.net", "err": "", "fix": "whois msn.net"},
{"cmd": "whois https://en.google.com", "err": "", "fix": "whois google.com"}
]
,
[
{"cmd": "untar file.tar", "err": "", "fix": "mkdir file; untar file.tar -C file/"},
{"cmd": "untar test1.tar", "err": "", "fix": "mkdir test1; untar test1.tar -C test1/"},
{"cmd": "untar xyz.tar", "err": "", "fix": "mkdir xyz; untar xyz.tar -C xyz/"}
]
,
[
{"cmd": "unzip file.zip", "err": "", "fix": "mkdir file; unzip file.zip -c file/"},
{"cmd": "unzip test1.zip", "err": "", "fix": "mkdir test1; unzip test1.zip -c test1/"},
{"cmd": "unzip xyz.zip", "err": "", "fix": "mkdir xyz; unzip xyz.zip -c xyz/"}
]
,
[ 
{"cmd": "git pull", "err": "You asked me to pull without telling me which branch you want to merge with, and 'branch.my_branch.merge' in your configuration file does not tell me, either. Please specify which branch you want to use on the command line and try again (e.g. 'git pull <repository> <refspec>'). See git-pull(1) for details. If you often merge with the same branch, you may want to use something like the following in your configuration file:     [branch 'my_branch']    remote = <nickname>    merge = <remote-ref>    [remote '<nickname>']    url = <url>    fetch = <refspec> See git-config(1) for details.", "fix": "git branch --set-upstream-to origin/my_branch"},
{"cmd": "git pull", "err": "You asked me to pull without telling me which branch you want to merge with, and 'branch.feature.merge' in your configuration file does not tell me, either. Please specify which branch you want to use on the command line and try again (e.g. 'git pull <repository> <refspec>'). See git-pull(1) for details. If you often merge with the same branch, you may want to use something like the following in your configuration file:     [branch 'feature']    remote = <nickname>    merge = <remote-ref>    [remote '<nickname>']    url = <url>    fetch = <refspec> See git-config(1) for details.", "fix": "git branch --set-upstream-to origin/feature"},
{"cmd": "git pull", "err": "You asked me to pull without telling me which branch you want to merge with, and 'branch.bugs.merge' in your configuration file does not tell me, either. Please specify which branch you want to use on the command line and try again (e.g. 'git pull <repository> <refspec>'). See git-pull(1) for details. If you often merge with the same branch, you may want to use something like the following in your configuration file:     [branch 'bugs']    remote = <nickname>    merge = <remote-ref>    [remote '<nickname>']    url = <url>    fetch = <refspec> See git-config(1) for details.", "fix": "git branch --set-upstream-to origin/bugs"}
],
[ 
{"cmd": "git pull", "err": "You asked me to pull without telling me which branch you want to merge with, and 'branch.my_branch.merge' in your configuration file does not tell me, either. Please specify which branch you want to use on the command line and try again (e.g. 'git pull <repository> <refspec>'). See git-pull(1) for details. If you often merge with the same branch, you may want to use something like the following in your configuration file:     [branch 'my_branch']    remote = <nickname>    merge = <remote-ref>    [remote '<nickname>']    url = <url>    fetch = <refspec> See git-config(1) for details.", "fix": "git branch -u origin/my_branch"},
{"cmd": "git pull", "err": "You asked me to pull without telling me which branch you want to merge with, and 'branch.feature.merge' in your configuration file does not tell me, either. Please specify which branch you want to use on the command line and try again (e.g. 'git pull <repository> <refspec>'). See git-pull(1) for details. If you often merge with the same branch, you may want to use something like the following in your configuration file:     [branch 'feature']    remote = <nickname>    merge = <remote-ref>    [remote '<nickname>']    url = <url>    fetch = <refspec> See git-config(1) for details.", "fix": "git branch -u origin/feature"},
{"cmd": "git pull", "err": "You asked me to pull without telling me which branch you want to merge with, and 'branch.bugs.merge' in your configuration file does not tell me, either. Please specify which branch you want to use on the command line and try again (e.g. 'git pull <repository> <refspec>'). See git-pull(1) for details. If you often merge with the same branch, you may want to use something like the following in your configuration file:     [branch 'bugs']    remote = <nickname>    merge = <remote-ref>    [remote '<nickname>']    url = <url>    fetch = <refspec> See git-config(1) for details.", "fix": "git branch -u origin/bugs"}
],
[
{"cmd": "Javac Foo", "err":"error: Class names, 'Foo', are only accepted if annotation processing is explicitly requested", "fix": "Javac Foo.java"},
{"cmd": "Javac Blah", "err":"error: Class names, 'Blah', are only accepted if annotation processing is explicitly requested", "fix": "Javac Blah.java"},
{"cmd": "Javac Etc123456", "err":"error: Class names, 'Etc123456', are only accepted if annotation processing is explicitly requested", "fix": "Javac Etc123456.java"},
{"cmd":"javac Foo Bar", "err":"error: Class names, 'Foo,Bar', are only accepted if annotation processing is explicitly requested", "fix":"javac Foo.java Bar.java"},
{"cmd":"javac Foo123 Bar123", "err":"error: Class names, 'Foo123,Bar123', are only accepted if annotation processing is explicitly requested", "fix":"javac Foo123.java Bar123.java"},
{"cmd":"javac AFileForStuffOkay AnotherFileForStuff", "err":"error: Class names, 'AFileForStuffOkay,AnotherFileForStuff', are only accepted if annotation processing is explicitly requested", "fix":"javac AFileForStuffOkay.java AnotherFileForStuff.java"},
{"cmd":"javac Foo Bar Yadda","err":"error: Class names, 'Foo,Bar,Yadda', are only accepted if annotation processing is explicitly requested","fix":"javac Foo.java Bar.java Yadda.java"},
{"cmd":"javac FileOne11 FileTwo22 FileThree33","err":"error: Class names, 'FileOne11,FileTwo22,FileThree33', are only accepted if annotation processing is explicitly requested","fix":"javac FileOne11.java FileTwo22.java FileThree33.java"},
{"cmd":"javac ClassFile1One11 AnotherClassFile2Two22 ThirdClassFile3Three33","err":"error: Class names, 'ClassFile1One11,AnotherClassFile2Two22,ThirdClassFile3Three33', are only accepted if annotation processing is explicitly requested","fix":"javac ClassFile1One11.java AnotherClassFile2Two22.java ThirdClassFile3Three33.java"}
]
]"""

let unfixed ="""
[
[
{"cmd":"ping http://www.a.net", "err":"ping: cannot resolve http://www.a.net: Unknown host"},
{"cmd":"ping https://bitbucket.com", "err":"ping: cannot resolve https://github.com: Unknown host"},
{"cmd":"ping http://www.qwantz.com", "err":"ping: cannot resolve http://www.qwantz.com: Unknown host"},
],
[
{"cmd":"traceroute http://www.a.net", "err":"traceroute: unknown host http://www.a.net"},
{"cmd":"traceroute https://bitbucket.com", "err":"traceroute: unknown host https://bitbucket.com"},
{"cmd":"traceroute https://www.qwantz.com", "err":"traceroute: unknown host http://www.qwantz.com"},
],
[
{"cmd":"scp q.txt w@z.net", "err":""},
{"cmd":"scp file.py user@host.com", "err":""},
{"cmd":"scp program.jar admin@server.org", "err":""},
],
[
{"cmd":"scp q.txt w@z.net", "err":""},
{"cmd":"scp file.py user@host.com", "err":""},
{"cmd":"scp program.jar admin@server.org", "err":""},
],
[
{"cmd":"tar xvzf a.tar.bz2" "err":"gzip: stdin: not in gzip format
tar: Child returned status 1
tar: Error is not recoverable: exiting now"},
{"cmd":"tar -xvzf dirArchive.tar.bz2" "err":"gzip: stdin: not in gzip format
tar: Child returned status 1
tar: Error is not recoverable: exiting now"},
{"cmd":"tar xvzf files.tar.bz2" "err":"gzip: stdin: not in gzip format
tar: Child returned status 1
tar: Error is not recoverable: exiting now"}
],
[
{"cmd":"tar xvjf w.tar.gz", "err":"bzip2: (stdin) is not a bzip2 file
tar: Child returned status 2
ter: Error is not recoverable: exiting now"},
{"cmd":"tar -xvjf fileArchive.tar.gz", "err":"bzip2: (stdin) is not a bzip2 file
tar: Child returned status 2
ter: Error is not recoverable: exiting now"},
{"cmd":"tar xvjf dir.tar.gz", "err":"bzip2: (stdin) is not a bzip2 file
tar: Child returned status 2
ter: Error is not recoverable: exiting now"}
],
[
{"cmd":"scp q.txt w@z.net", "err":""},
{"cmd":"scp file.py user@host.com", "err":""},
{"cmd":"scp program.jar admin@server.org", "err":""}
],
[
{"cmd":"cd Program Files (x86)", "err":"-bash: syntax error near unexpected token `('"},
{"cmd":"cd My Bins (x86)", "err":"-bash: syntax error near unexpected token `('"},
{"cmd":"cd Steam Library (x86)", "err":"-bash: syntax error near unexpected token `('"}
],
[
{"cmd":"dmesg", "err":"Unable to obtain kernel buffer: Operation not permitted"}
],
[
{"cmd":"rm --weirdFilename", "err":"rm: illegal option -- -
usage: rm [-f | -i] [-dPRrvW] file ...
unlink file"},
{"cmd":"rm --aFile", "err":"rm: illegal option -- -
usage: rm [-f | -i] [-dPRrvW] file ...
unlink file"}
{"cmd":"rm --bla", "err":"rm: illegal option -- -
usage: rm [-f | -i] [-dPRrvW] file ...
unlink file"}
]
]"""

//{
//{"cmd": "./program `python print 'Aa' * 1200`", "err": "python: can't open file 'print': [Errno 2] No such file or directory", "fix": "./program `python -c \"print 'Aa' * 1200\"`"},
//{"cmd": "./program `python print 'A' * 100`", "err": "python: can't open file 'print': [Errno 2] No such file or directory", "fix": "./program `python -c \"print 'A' * 100\"`"},
//{"cmd": "./program `python print 'bbb' * 'abc'`", "err": "python: can't open file 'print': [Errno 2] No such file or directory", "fix": "./program `python -c \"print 'bbb' * abc\"`"},
//},
//{
//{"cmd": "./program `python print 'Aa' * 1200`", "err": "python: can't open file 'print': [Errno 2] No such file or directory", "fix": "python -c \\"print 'Aa' * 1200\\" | ./program"},
//{"cmd": "./program `python print 'A' * 100`", "err": "python: can't open file 'print': [Errno 2] No such file or directory", "fix": "python -c \\"print 'A' * 100\\" | ./program"},
//{"cmd": "./program `python print 'bbb' * 'abc'`", "err": "python: can't open file 'print': [Errno 2] No such file or directory", "fix": "python -c \\"print 'bbb' * abc\\" | ./program"},
//},
//{
//{"cmd": "sudo -u www-data grep -a 't=' /var/www/temp/w1_slave | cut -f2 -d= > /var/www/temp/temp.txt", "err": "Permission Denied", "fix": "sudo -u www-data sh -c "grep -a 't=' /var/www/temp/w1_slave | cut -f2 -d= > /var/www/temp/temp.txt""},
//{"cmd": "sudo -u www-data grep -a 't=' /var/w/temp/w1234_slave3 | cut -f2 -d= > /var/w/temp/temp1.txt", "err": "Permission Denied", "fix": "sudo -u www-data sh -c "grep -a 't=' /var/w/temp/w1234_slave3 | cut -f2 -d= > /var/w/temp/temp1.txt""},
//{"cmd": "sudo -u www-data grep -a 't=' /var/wwdw/temp/w1_sladve | cut -f2 -d= > /var/wwdw/temp/temp23.txt", "err": "Permission Denied", "fix": "sudo -u www-data sh -c "grep -a 't=' /var/wwdw/temp/w1_sladve | cut -f2 -d= > /var/wwdw/temp/temp23.txt""},
//},
//,
//{
//{"cmd": "java -Djava.library.path="path to a dll" -jar myjar.jar", "err": "", "fix": "java -Djava.library.path="%PATH%;path to a dll" -jar myjar.jar"},
//{"cmd": "java -Djava.library.path="path to a dll" -jar myjar1.jar", "err": "", "fix": "java -Djava.library.path="%PATH%;path to a dll" -jar myjar1.jar"},
//{"cmd": "java -Djava.library.path="path to a dll" -jar myjar12.jar", "err": "", "fix": "java -Djava.library.path="%PATH%;path to a dll" -jar myjar12.jar"}
//}