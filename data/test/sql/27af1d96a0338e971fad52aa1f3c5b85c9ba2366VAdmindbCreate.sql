CREATE TABLE CPUStats(nodeAddr VARCHAR(50),user FLOAT,nice FLOAT,system FLOAT,ioWait FLOAT,steal FLOAT,idle  FLOAT, readTime integer);

CREATE TABLE IOReport(nodeAddr VARCHAR(50),tps FLOAT,rtps FLOAT,wtps FLOAT,bread FLOAT,bwrtn FLOAT,readTime integer);

CREATE TABLE Paging(nodeAddr VARCHAR(50),pgpgin FLOAT,pgpgout FLOAT,fault FLOAT, readTime integer);

CREATE TABLE Memory(nodeAddr VARCHAR(50),kbMemfree FLOAT,kbMemused FLOAT,Memused FLOAT,kbBuffers FLOAT,kbCached FLOAT,kbCommit FLOAT, readTime integer);

CREATE TABLE Process(nodeAddr VARCHAR(50),runq_sz FLOAT,plist_sz FLOAT,ldavg FLOAT,blocked FLOAT,readTime integer);

CREATE TABLE Disk(nodeAddr VARCHAR(50),size FLOAT,used FLOAT,avail FLOAT, readTime VARCHAR(50));

