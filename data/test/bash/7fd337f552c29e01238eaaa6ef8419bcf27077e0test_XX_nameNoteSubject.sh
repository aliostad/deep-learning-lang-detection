#!/bin/sh

# load predicates
tmp/commands/ts-load-raw.sh dams $BASE/../sample/predicates/nameNoteSubject.nt

function f
{
	ARK=$1
	FILE=$2
	tmp/commands/ts-post.sh $ARK $FILE
	tmp/commands/ts-delete.sh $ARK
	tmp/commands/ts-put.sh $ARK $FILE
}

# load records
f bd52568274 $BASE/../sample/object/new/damsNote.rdf.xml
f bd9113515d $BASE/../sample/object/new/damsCustodialResponsibilityNote.rdf.xml
f bd3959888k $BASE/../sample/object/new/damsPreferredCitationNote.rdf.xml
f bd1366006j $BASE/../sample/object/new/damsScopeContentNote.rdf.xml
f bd7509406v $BASE/../sample/object/new/madsName.rdf.xml
f bd1707307x $BASE/../sample/object/new/damsBuiltWorkPlace.rdf.xml
f bd0410365x $BASE/../sample/object/new/damsCulturalContext.rdf.xml
f bd7816576v $BASE/../sample/object/new/damsFunction.rdf.xml
f bd65537666 $BASE/../sample/object/new/damsIconography.rdf.xml
f bd2662949r $BASE/../sample/object/new/damsScientificName.rdf.xml
f bd0069066b $BASE/../sample/object/new/damsStylePeriod.rdf.xml
f bd8772217q $BASE/../sample/object/new/damsTechnique.rdf.xml
f bd6724414c $BASE/../sample/object/new/madsComplexSubject.rdf.xml
f bd0478622c $BASE/../sample/object/new/madsConferenceName.rdf.xml
f bd8021352s $BASE/../sample/object/new/madsCorporateName.rdf.xml
f bd1775562z $BASE/../sample/object/new/madsFamilyName.rdf.xml
f bd9796116g $BASE/../sample/object/new/madsGenreForm.rdf.xml
f bd8533304b $BASE/../sample/object/new/madsGeographic.rdf.xml
f bd7509406v $BASE/../sample/object/new/madsName.rdf.xml
f bd72363644 $BASE/../sample/object/new/madsOccupation.rdf.xml
f bd93182924 $BASE/../sample/object/new/madsPersonalName.rdf.xml
f bd59394235 $BASE/../sample/object/new/madsTemporal.rdf.xml
f bd46424836 $BASE/../sample/object/new/madsTopic.rdf.xml
f bd6212468x $BASE/../sample/object/new/damsObject.rdf.xml
