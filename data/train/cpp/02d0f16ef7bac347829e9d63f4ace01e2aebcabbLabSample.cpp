#include "StdAfx.h"
#include "LabSample.h"


LabSample::LabSample()
{
	setVialPosition(-1);
	setSampleName("N/A");
}


LabSample::LabSample(int vialPositionIn,string sampleNameIn)
{
	setVialPosition(vialPositionIn);
	setSampleName(sampleNameIn);
}

LabSample::LabSample(LabSample& sample)
{
	setVialPosition(sample.getVialPosition());
	setSampleName(sample.getSampleName());
}

int LabSample::getVialPosition()
{

	return vialPosition;

}

string LabSample::getSampleName()
{
	return sampleName;
}

void LabSample::setSampleName(string nameIn)
{
	sampleName = nameIn;

}

void LabSample::setVialPosition(int vialPositionIn)
{
	vialPosition = vialPositionIn;

}