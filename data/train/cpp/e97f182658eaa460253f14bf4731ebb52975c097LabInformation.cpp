#include "StdAfx.h"
#include "LabInformation.h"


LabInformation::LabInformation():sampleInformation(),sampleResults(),TNCalibrationCurve()
{

}



LabInformation::LabInformation(LabSample& sampleInformation):sampleInformation(sampleInformation.getVialPosition(),sampleInformation.getSampleName()),
	                                                                      sampleResults()
{

}

LabInformation::LabInformation(LabSample& sampleInformation,LabResults& sampleResults,CalibrationCurve& calibrationCurve):sampleInformation(sampleInformation),
	sampleResults(sampleResults),TNCalibrationCurve(calibrationCurve)
{

}

LabSample& LabInformation::getSampleInformation()
{
	return sampleInformation;
}

LabResults& LabInformation::getSampleResults()
{
	return sampleResults;
}

void LabInformation::setLabResults(LabResults& sampleResultsIn)
{
	sampleResults.setAreas(sampleResultsIn.getAreas());
	sampleResults.setConcentrations(sampleResultsIn.getConcentrations());
}

void LabInformation::setLabSample(LabSample& sampleInformationIn)
{
	sampleInformation.setSampleName(sampleInformationIn.getSampleName());
	sampleInformation.setVialPosition(sampleInformationIn.getVialPosition());
}

void LabInformation::setTNCalibrationCurve(CalibrationCurve& calibrationCurve)
{
	TNCalibrationCurve.setAreaMultiplier(calibrationCurve.getAreaMultiplier());
	TNCalibrationCurve.setConcentrationMultiplier(calibrationCurve.getConcentrationMultiplier());
}

CalibrationCurve LabInformation::getTNCalibrationCurve()
{
	return TNCalibrationCurve;
}