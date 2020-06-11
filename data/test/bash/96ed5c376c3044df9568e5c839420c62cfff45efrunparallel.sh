## Initialization of dataset.
R --no-save < Phase0.R >& Phase0.out

## Ideally want to do the following many (100 to 1000) times.
###########################################################################
## Initialization of run.
R --no-save "--args 1" < Phase1.R >& Phase1.out

## Permutation runs. Parallelize.
## Do the next line n.split = 10 times (see groups.txt created by Phase1).
R --no-save "--args 1" < Phase2.R >& Phase21.out
R --no-save "--args 2" < Phase2.R >& Phase22.out
## ...
R --no-save "--args 10" < Phase2.R >& Phase210.out

## Wrapup. Wait for all the Phase2 jobs to complete.
R --no-save "--args 1" < Phase3.R >& Phase3.out
###########################################################################
