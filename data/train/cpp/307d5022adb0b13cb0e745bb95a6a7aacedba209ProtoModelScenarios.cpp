//
//  ProtoModelScenarios.cpp
//  Protocol
//
//  Created by Wahid Tanner on 9/24/14.
//

#include <string>

#include "../Submodules/Designer/Designer/Designer.h"

#include "../Protocol/ProtoModel.h"

using namespace std;
using namespace MuddledManaged;

DESIGNER_SCENARIO( ProtoModel, "Construction/Normal", "ProtoModel can be constructed." )
{
    Protocol::ProtoModel model("test.proto");

    verifyEqual("", model.package());
}

DESIGNER_SCENARIO( ProtoModel, "Operation/Properties", "ProtoModel knows current package." )
{
    Protocol::ProtoModel model("test.proto");
    string package = "MuddledManaged.Protocol";

    model.setPackage(package);
    verifyEqual(package, model.package());
}
