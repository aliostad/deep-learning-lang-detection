#if !defined(__SWL_BASE__MVC_MODEL__H_)
#define __SWL_BASE__MVC_MODEL__H_ 1


#include "swl/base/IObserver.h"


namespace swl {

//--------------------------------------------------------------------------
// class MvcModel

class SWL_BASE_API MvcModel: public IObserver
{
public:
	typedef IObserver base_type;

protected:
	MvcModel()  {}
public:
	virtual ~MvcModel()  {}

private:
	MvcModel(const MvcModel &);
	MvcModel & operator=(const MvcModel &);

public:
};

}  // namespace swl


#endif  // __SWL_BASE__MVC_MODEL__H_
