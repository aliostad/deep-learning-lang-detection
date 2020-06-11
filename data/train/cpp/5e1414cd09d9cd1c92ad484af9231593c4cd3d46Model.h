#ifndef __MODEL__MODEL_H__
#define __MODEL__MODEL_H__

#include <vector>
#include <memory>

#include <boost/utility.hpp>

#include "dxf_machine/model/entities/Entity.h"

namespace dxf_machine { namespace model {

/**
 * struct of object collections
**/
struct Model : private boost::noncopyable
{
    typedef entities::Entity EntityT;
    typedef std::vector<EntityT::PtrT> EntVecT;
    typedef std::shared_ptr<EntVecT> EntVecPtrT;
    
    Model();
    
    EntVecPtrT entities;
};

}}

#endif // __MODEL__MODEL_H__
