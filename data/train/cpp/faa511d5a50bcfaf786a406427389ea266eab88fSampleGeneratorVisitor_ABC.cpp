#include "rtql8Manipulability/sampling/SampleGeneratorVisitor_ABC.h"
#include "rtql8Manipulability/sampling/SampleGenerator.h"
#include "rtql8Manipulability/sampling/Sample.h"
#include "kinematics/BodyNode.h"

using namespace rtql8::kinematics;
using namespace Eigen;

SampleGeneratorVisitor_ABC::SampleGeneratorVisitor_ABC()
{
	// NOTHING
}

SampleGeneratorVisitor_ABC::~SampleGeneratorVisitor_ABC()
{
	// NOTHING
}

void SampleGeneratorVisitor_ABC::Visit(BodyNode* /*limb*/, Sample& /*sample*/) 
{
	// NOTHING
}

