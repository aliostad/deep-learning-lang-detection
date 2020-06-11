/// \file descriptionlocator.cpp
/// \brief Implementation file for V-ART class "DescriptionLocator".
/// \version $Revision: 1.1 $

#include "vart/descriptionlocator.h"
#include "vart/scenenode.h"

//#include <iostream>
//using namespace std;

VART::DescriptionLocator::DescriptionLocator(const std::string& description)
                                                                    : targetDescription(description)
{
}

//virtual
void VART::DescriptionLocator::OperateOn(const SceneNode* snPtr)
{
    if (snPtr->GetDescription() == targetDescription)
    {
        notFinished = false;
        nodePtr = snPtr;
    }
}
