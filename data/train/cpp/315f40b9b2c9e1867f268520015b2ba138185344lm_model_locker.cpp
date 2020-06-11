
#include "landscape_model/sources/ph/lm_ph.hpp"

#include "landscape_model/sources/model_locker/lm_model_locker.hpp"

#include "landscape_model/sources/landscape_model/lm_landscape_model.hpp"


/*---------------------------------------------------------------------------*/

namespace Plugins {
namespace Core {
namespace LandscapeModel {

/*---------------------------------------------------------------------------*/


ModelLocker::ModelLocker( boost::intrusive_ptr< LandscapeModel >& _landscapeModel )
	:	m_lockerHolder( &_landscapeModel->getMutex() )
	,	m_landscapeModel( _landscapeModel )
{
} // ModelLocker::ModelLocker


/*---------------------------------------------------------------------------*/


ModelLocker::~ModelLocker()
{
} // ModelLocker::~ModelLocker


/*---------------------------------------------------------------------------*/


boost::intrusive_ptr< ILandscapeModel >
ModelLocker::getLandscapeModel() const
{
	return m_landscapeModel;

} // ModelLocker::getLandscape


/*---------------------------------------------------------------------------*/

} // namespace LandscapeModel
} // namespace Core
} // namespace Plugins

/*---------------------------------------------------------------------------*/
