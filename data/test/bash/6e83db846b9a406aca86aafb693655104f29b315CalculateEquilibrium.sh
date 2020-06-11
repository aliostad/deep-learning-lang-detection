#! /usr/bin/tcsh -f
set PROGRAM         = Reaction.exe

set MOLECULEDATA     = $REACTION_BASE/data/mol
set MOLECULEINPUTS   = $MOLECULEDATA/inputs
set MOLECULESCRIPTS  = $MOLECULEDATA/scripts
set GENERIC          = $REACTION_BASE/data/generic

set PROGRAM = Reaction.exe

if( $#argv <  3) then
echo   " Usage: $0 SaveFileRoot  SaveFileCount [ProgramName]"
echo   "        SaveFileRoot:          The rootname of the save file"
echo   "        SaveFileCount:         The count of the current save file"
echo   "        EquilibriumInfoFile    The information needed by the calculation routine"
echo   ""
echo   " This increments the SaveFileCount by 1"
exit(1)
endif

set SAVE         = $1
set SAVECOUNT    = $2
set FILE         = $3

$PROGRAM xxx Operate $SAVE    $SAVECOUNT Read $MOLECULEINPUTS/CalculateEquilibriumClass.inp $FILE 0
@ SAVECOUNT++
$PROGRAM xxx Change  $SAVE    $SAVECOUNT RunAlgorithm Expression 0
$PROGRAM xxx Change  $SAVE    $SAVECOUNT RunAlgorithm MoveIt 0
$PROGRAM xxx Change  $SAVE    $SAVECOUNT Store Molecule Molecule InstanceNameList
