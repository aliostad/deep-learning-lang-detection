/*
 Title: LoadCell.h
  Author/Date: gNSortino@yahoo.com / 2014-07-26
  Description: This library will take the input from an 
    FC22 MSI Load Cell (0.5V - 4.5V) and convert it into lbf
	configuration inputs:
		inV:
			the supply voltage (should be 5 volts)
		noLoadCalcV:
			the no load calculated voltage
		loadMassV:
			the full load mass voltage
		loadMassLBF:
			the full load mass in pounds force
	measurement input:
		loadCellAnalogIn:
	output:
		mass:
			outputs the calculated mass given the aforementioned
			inputs.
    Note that this library will not setup any pins. It
	is expected that these will be defined by the calling 
	program.
	Change Log:
		GNS 2014-07-26: initial version
*/

#include "Arduino.h"
#include "LoadCell.h"

/*
	Calibration parameters for the load cell
*/
LoadCell::LoadCell(float inV, float noLoadCalcV, float loadMassV, float loadMassLBF)
{
	// Calculate the ratiometric scale factor given the fact that
	// the nominal input voltage should be 5V (per datasheet)
	_ratiometricScaleFactor = (inV / 5.0);
	
	_calibratedSpan = (loadMassV / loadMassLBF) * _ratiometricScaleFactor;
	_noLoadCalcV = noLoadCalcV;
	
}

/*
	Load cell voltage is a linear function defined as: Y = mX+b
	where:
		Y= measured voltage
		m = mV/lbf
		X= Force input
		b =output at zero load input
*/
float LoadCell::getForce (int loadCellAnalogIn)
{
	float vCalc = getVoltage (loadCellAnalogIn);
	return ((vCalc - _noLoadCalcV) / _calibratedSpan);
}

float LoadCell::getVoltage (int loadCellAnalogIn)
{
  float voltage = ((5.0 * loadCellAnalogIn) / 1023.0);
  return voltage;
  
}