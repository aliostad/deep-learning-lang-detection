#! /usr/bin/tcsh -f
set PROGRAM          = Reaction.exe

set MOLECULEDATA     = $REACTION_BASE/data/mol
set MOLECULEINPUTS   = $MOLECULEDATA/inputs
set MOLECULESCRIPTS  = $MOLECULEDATA/scripts

set REACTIONDATA     = $REACTION_BASE/data/rxn
set REACTIONINPUTS   = $REACTIONDATA/inputs
set REACTIONSCRIPTS  = $REACTIONDATA/scripts

set GENERIC          = $REACTION_BASE/data/generic

if( $#argv <  3) then
echo   " Usage: $0 SaveFileRoot  SaveFileCount [ProgramName]"
echo   "        SaveFileRoot:          The rootname of the save file"
echo   "        SaveFileCount:         The count of the current save file"
echo   "        FileName:              File with Reverse Calculation information"
echo   ""
echo   " This increments the SaveFileCount by 1"
exit(1)
endif

set SAVE         = $1
set SAVECOUNT    = $2
set FILE         = $3

$PROGRAM xxx Operate $SAVE  $SAVECOUNT Read $REACTIONINPUTS/InitReverseCalculationClass.inp \
       $REACTIONINPUTS/InitReverseCalculation.inp 0
@ SAVECOUNT++
$PROGRAM xxx Change  $SAVE  $SAVECOUNT Read $REACTIONINPUTS/CalculateReverseClass.inp $FILE 0
$PROGRAM xxx Change  $SAVE  $SAVECOUNT FillRxn Molecule StandardReaction InstanceNameList
$PROGRAM xxx Change  $SAVE  $SAVECOUNT RunAlgorithm Expression 0
$PROGRAM xxx Change  $SAVE  $SAVECOUNT RunAlgorithm MoveIt 0
$PROGRAM xxx Change  $SAVE  $SAVECOUNT Store Reaction Reaction InstanceNameList
