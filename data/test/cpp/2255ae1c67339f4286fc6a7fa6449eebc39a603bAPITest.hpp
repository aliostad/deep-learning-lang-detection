#ifndef PublicAPIUnitTest_H
#define PublicAPIUnitTest_H

//Main boost include
#include <boost/test/unit_test.hpp>


#ifdef __APPLE__
#define GRPIMAGEFILEPATH "../../Documentation/SampleContent/SampleImage.grp"
#define PALLETTEFILEPATH "../../Documentation/SampleContent/SamplePalette.pal"

#else
#define GRPIMAGEFILEPATH "../Documentation/SampleContent/SampleImage.grp"
#define BADGRPIMAGEFILEPATH "/asdmalskd-sd_--dsdf--w-w-.grp"

#define PALLETTEFILEPATH "../Documentation/SampleContent/SamplePalette.pal"
#define BADPALLETTEFILEPATH "/lksmdalksmdlkamsda.pal"
#endif


#endif