#! /usr/bin/tcsh -f

set PROGRAM         = Reaction.exe

set MOLECULEDATA   = $REACTION_BASE/data/mol
set MOLECULEINPUTS = $MOLECULEDATA/inputs
set MOLECULESCRIPTS = $MOLECULEDATA/scripts

set REACTIONDATA   = $REACTION_BASE/data/rxn
set REACTIONINPUTS = $REACTIONDATA/inputs
set REACTIONSCRIPTS = $REACTIONDATA/scripts
set MAUSS           = $REACTIONDATA/Warnatz

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


$PROG xxx Operate $SAVE    $S ReadRxn Reaction Molecule $REACTIONDATA/Warnatz/MEC-H2-O2.sdf None
@ S++
$PROG xxx Change  $SAVE    $S ReadRxn Reaction Molecule $REACTIONDATA/Warnatz/MEC-C1.sdf None
$PROG xxx Change  $SAVE    $S ReadRxn Reaction Molecule $REACTIONDATA/Warnatz/MEC-C2-gly-V1.sdf None
$PROG xxx Change  $SAVE    $S ReadRxn Reaction Molecule $REACTIONDATA/Warnatz/MEC-C3.sdf None
$PROG xxx Change  $SAVE    $S ReadRxn Reaction Molecule $REACTIONDATA/Warnatz/MEC-C4.sdf None
$PROG xxx Change  $SAVE    $S ReadRxn Reaction Molecule $REACTIONDATA/Warnatz/MEC.sdf None

$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/MaussReactionClass.inp $REACTIONDATA/Warnatz/MEC-H2-O2.inp 0
$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/MaussReactionClass.inp $REACTIONDATA/Warnatz/MEC-C1.inp 0
$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/MaussReactionClass.inp $REACTIONDATA/Warnatz/MEC-C2-gly-V1.inp 0
$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/MaussReactionClass.inp $REACTIONDATA/Warnatz/MEC-C3.inp 0
$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/MaussReactionClass.inp $REACTIONDATA/Warnatz/MEC-C4.inp 0

$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/MaussThirdBodyClass.inp $REACTIONDATA/Warnatz/MEC-H2-O2-ThirdBody.inp 0
$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/MaussThirdBodyClass.inp $REACTIONDATA/Warnatz/MEC-C1-ThirdBody.inp 0
$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/MaussThirdBodyClass.inp $REACTIONDATA/Warnatz/MEC-C2-ThirdBody.inp 0
$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/MaussThirdBodyClass.inp $REACTIONDATA/Warnatz/MEC-C3-ThirdBody.inp 0

$PROG xxx Change  $SAVE    $S Read $REACTIONDATA/Warnatz/RxnTransferClass.inp $REACTIONDATA/Warnatz/RxnTransfer.inp 0
$PROG xxx Change  $SAVE    $S RunAlgorithm MoveIt 0
