#include "PendingLoad.hpp"
#include "Bitmap.hpp"


using namespace ol;


OlLoadResult PendingFileLoad::
ExecuteLoading( Bitmap &bmp ) {
   return bmp.Load( filename )? OL_LR_SUCCESS : OL_LR_FAILURE;
}



OlLoadResult PendingFileAlphaLoad::
ExecuteLoading( Bitmap &bmp ) {
   return bmp.Load( filename, alphaFilename )? OL_LR_SUCCESS : OL_LR_FAILURE;
}



OlLoadResult PendingDataLoad::
ExecuteLoading( Bitmap &bmp ) {
   return OL_LR_FAILURE;
   //bmp.Load( data, textureInfo );
}



template< class Type >
OlLoadResult PendingFunctorLoad <Type>::
ExecuteLoading( Bitmap &bmp ) {
   return bmp.Load( width, height, functor )? OL_LR_SUCCESS : OL_LR_FAILURE;
}
