#ifndef _NAMESPACE_PROTECT_
	#error "Use ThreeKShell.h"
#endif
#include "kl_allocator.h"

class IMenuHandler
{
public:
	virtual fresult OnClick(IMenuItem* sender)=0;
};

/*
template<class T> class MenuHandlerFunctionPtr {
	typedef fresult (T::*MENU_HANDLER_DELEGATE)(IMenuItem* sender);
	MENU_HANDLER_DELEGATE _handler;
public:
	void MenuHandlerFunctionPtr(MENU_HANDLER_DELEGATE handler) {_handler = handler;}
	fresult Execute(T* _this) {return (_this->*_handler)();}
};
*/

template<class T> class MenuHandlerDelegate : public IMenuHandler {
	typedef fresult (T::*MENU_HANDLER_DELEGATE)(IMenuItem* sender);
	MENU_HANDLER_DELEGATE _handler;
	T* _this;
public:
	void _MenuHandlerDelegate(T* __this,MENU_HANDLER_DELEGATE handler) {_handler = handler; _this=__this;}
	fresult Execute(IMenuItem* sender) {return (_this->*_handler)(sender);}
	virtual fresult OnClick(IMenuItem* sender) { return Execute(sender);}
};

//#define CREATE_PFM(R,T,F) 				MenuHandlerFunctionPtr<T>* R = new MenuHandlerFunctionPtr<T>(&T::F)
//#define CREATE_DELEGATE(R,T,_this,F)		MenuHandlerDelegate<T>* R = new MenuHandlerDelegate<T>(_this,&T::F)
//#define CREATE_MENU_HANDLER_ANY(T,_this,F)	new MenuHandlerDelegate<T>(_this,&T::F)
//#define CREATE_MENU_HANDLER(T,F)				new MenuHandlerDelegate<T>(this,&T::F)

#define MENU_HANDLER_DELEGATE_NAME(T) \
	SMenuHandlerDelegate##T##Arr
#define ALLOCATE_MENU_HANDLERS(T,N) \
	static Alloc_t<MenuHandlerDelegate<T>, N> SMenuHandlerDelegate##T##Arr

#define DEFINE_MENU_HANDLER(T) \
	typedef fresult (T::*MENU_HANDLER_DELEGATE##T)(IMenuItem* sender); \
	MenuHandlerDelegate<T>* CreateMenuHandler##T( \
		T* _this, \
		MENU_HANDLER_DELEGATE##T F \
	) \
{ \
	MenuHandlerDelegate<T>* R = MENU_HANDLER_DELEGATE_NAME(T).Allocate("Smth"); \
	R->_MenuHandlerDelegate(_this,F); \
	return R; \
}

#define CREATE_MENU_HANDLER(T,F)	CreateMenuHandler##T(this,&T::F);
