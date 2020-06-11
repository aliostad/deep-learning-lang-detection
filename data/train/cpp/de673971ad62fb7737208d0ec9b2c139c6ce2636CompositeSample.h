/***************************************************************************
                             SRC/mixmod/Kernel/IO/CompositeSample.h  description
    copyright            : (C) MIXMOD Team - 2001-2016
    email                : contact@mixmod.org
 ***************************************************************************/

/***************************************************************************
    This file is part of MIXMOD
    
    MIXMOD is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    MIXMOD is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with MIXMOD.  If not, see <http://www.gnu.org/licenses/>.

    All informations available on : http://www.mixmod.org                                                                                               
***************************************************************************/
#ifndef XEMCOMPOSITESAMPLE_H_
#define XEMCOMPOSITESAMPLE_H_
/**@file XEMCompositeSample.h
 * @brief Composite sample class for heterogeneous data.
 * @author Parmeet Bhatia
 */
#include "mixmod/Kernel/IO/Sample.h"

namespace XEM {

class BinarySample;
class GaussianSample;

class CompositeSample : public Sample {

public:
	
	//Default constructor
	CompositeSample();
	//Initialization constructor
	CompositeSample(Sample*, Sample*);
	/**type-cast overloading for Binary sample*/
	operator BinarySample*();
	/**type-cast overloading for Gaussian sample*/
	operator GaussianSample*();

	/** get gaussian sample*/
	virtual GaussianSample* getGaussianSample() const {
		return (GaussianSample*) _sampleComponent[1];
	}

	/** get Binary sample*/
	virtual BinarySample* getBinarySample() const {
		return (BinarySample*) _sampleComponent[0];
	}
	virtual ~CompositeSample();
	
protected:
	
	vector<Sample*> _sampleComponent;
};

inline CompositeSample::operator BinarySample *() {
	return _sampleComponent[0]->getBinarySample();
}

inline CompositeSample::operator GaussianSample *() {
	return _sampleComponent[1]->getGaussianSample();
}

}

#endif /* XEMCOMPOSITESAMPLE_H_ */
