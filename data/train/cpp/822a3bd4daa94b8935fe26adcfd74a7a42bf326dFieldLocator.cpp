//============================================================================
// Datei	: FieldLocator.cpp
// Autor	: Christian Jungblut
// Version	: 1.0
//============================================================================

#include "FieldLocator.h"
#include "..//PositionService/ObjectLocator.h"
#include <stdio.h>

using namespace std;
using namespace cv;

FieldLocator::FieldLocator(){

}

FieldLocator::FieldLocator(IPositionService * _ips){

    ips = _ips;
}

vector<LocatedObject> FieldLocator::locateField(Mat &_src, LocatableObject &_origin, LocatableObject &_reference){

    vector<LocatedObject> result;

	//Alle Objekte finden, die aussehen wie das Muster
    vector<LocatedObject> ori = ips->getAllObjects(_src, _origin);

	if (ori.size() == 1){
        result.push_back(ori[0]);
	}

	//Alle Objekte finden, die aussehen wie das Muster
    vector<LocatedObject> ref = ips->getAllObjects(_src, _reference);

	if (ref.size() == 1){
        result.push_back(ref[0]);
	}

	return  result;
}
