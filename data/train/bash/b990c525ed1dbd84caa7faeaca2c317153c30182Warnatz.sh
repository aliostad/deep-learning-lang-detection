#! /usr/bin/tcsh -f

set MOLECULEDATA   = $REACTION_BASE/data/mol
set MOLECULEINPUTS = $MOLECULEDATA/inputs
set MOLECULESCRIPTS = $MOLECULEDATA/scripts

set REACTIONDATA   = $REACTION_BASE/data/rxn
set REACTIONINPUTS = $REACTIONDATA/inputs
set REACTIONSCRIPTS = $REACTIONDATA/scripts

set GENERIC         = $REACTION_BASE/data/generic

if( $#argv <  2) then
echo   " Usage: $0 SaveFileRoot  SaveFileCount [ProgramName]"
echo   "        SaveFileRoot:          The rootname of the save file"
echo   "        SaveFileCount:         The count of the current save file"
echo   "        [ProgramName]:           The executable to use (default Reaction.exe)"
echo   ""
echo   " This increments the SaveFileCount by 1"
exit(1)
endif

set PROG = Reaction.exe
if($#argv ==  3) then
    $PROG = $3
endif

set SAVE         = $1
set S            = $2


rm *.dbf

$REACTIONSCRIPTS/ReactionSetup.sh $SAVE $S $PROG
@ S++

$MOLECULESCRIPTS/ReadMolecules0.sh $SAVE $S $PROG
@ S++

$MOLECULESCRIPTS/ReadMolecules0.sh $SAVE $S $PROG
@ S++
$REACTIONSCRIPTS/MaussWarnatzConstants.sh $SAVE $S $PROG
