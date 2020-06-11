#ifndef LoadCVImage_H
#define LoadCVImage_H

#include "cv.h"
#include "highgui.h"

#include "cvimage.h"

//#include <fstream>
#include <string>

	class LoadCVImage {

	    public:

			//! LoadCVImage();
			/*! LoadCVImage()  -- the standard constructor
			*/
			LoadCVImage();

			//! ~LoadCVImage()  -- the destructor
			~LoadCVImage();

			CVImage* load(const std::string& filename);
			CVImage* load(IplImage* InputImage);
			CVImage* loadfromcamera(IplImage* image);
			
			//bool debug;
				

		private:
			
			CVImage* mp_cvimg;
			
			bool m_checkfileexistence;

	};

#endif
