#include "PortableServer.h" // Parent Inclusion 


#ifndef _PORTABLESERVER_SERVANT_LOCATOR_H_
#define _PORTABLESERVER_SERVANT_LOCATOR_H_


extern const ::CORBA::TypeCode_ptr _tc_ServantLocator;


class ServantLocator : public virtual PortableServer::ServantManager
//MLG 
//public virtual CORBA::Object
//EMLG
{

	public:
		typedef ServantLocator_ptr _ptr_type;
		typedef ServantLocator_var _var_type;

	// Constructors & operators 
	protected:
		ServantLocator() {};
		virtual ~ServantLocator() {};

	private:		
		void operator= (ServantLocator_ptr obj) {};


	public: // Static members
		static PortableServer::ServantLocator_ptr _narrow(const ::CORBA::Object_ptr obj) ;
		static PortableServer::ServantLocator_ptr _unchecked_narrow(const ::CORBA::Object_ptr obj) ;
		static PortableServer::ServantLocator_ptr _duplicate(PortableServer::ServantLocator_ptr val);
		static PortableServer::ServantLocator_ptr _nil();

	public: //Operations, Constants & Attributes Declaration 
		
                typedef void* Cookie;

		virtual PortableServer::Servant preinvoke(const PortableServer::ObjectId& oid,
		                                          PortableServer::POA_ptr adapter,
		                                          const char* operation,
		                                          PortableServer::ServantLocator::Cookie& the_cookie) = 0;
		
		virtual void postinvoke(const PortableServer::ObjectId& oid,
		                        PortableServer::POA_ptr adapter,
		                        const char* operation,
		                        PortableServer::ServantLocator::Cookie the_cookie,
		                        PortableServer::Servant the_servant) = 0;


}; // end of ServantLocatorheader definition

class _ServantLocatorHelper{

		public:
		static ::CORBA::TypeCode_ptr type();

		static const char* id(){ return "IDL:omg.org/PortableServer/ServantLocator:1.0"; }

		static void read(::TIDorb::portable::InputStream& is, PortableServer::ServantLocator_ptr& val);

		static void write(::TIDorb::portable::OutputStream& os, const PortableServer::ServantLocator_ptr val);

		static PortableServer::ServantLocator_ptr narrow(const ::CORBA::Object_ptr obj, bool is_a);
};// End of helper definition


#endif //_PORTABLESERVER_SERVANT_LOCATOR_H_  
