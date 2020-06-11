#include "../../g2e/service/ServiceLocator.h"

using g2e::service::Service;

namespace g2e {
namespace service {

ServiceLocator::ServiceLocator() {
}

ServiceLocator::~ServiceLocator() {
	for (auto i=services.begin(); i!=services.end(); i++) delete (*i);
}

Service* ServiceLocator::get(std::string classname) {
	for (auto i=services.begin(); i!=services.end(); i++) {
		if (((Service*)*i)->getClass() == classname) return *i;
	}

	throw std::runtime_error("Could not locate service.");
}

//template <class T>
//g2e::service::Service& ServiceLocator::operator()() {
//	for (auto i=services.begin(); i!=services.end(); i++) {
//		g2e::service::Service* casted = dynamic_cast<T*>(*i);
//		if (casted != 0) return *casted;
//	}
//}

void ServiceLocator::add(g2e::service::Service* ns) {
	services.push_back(ns);
}

} /* namespace service */
} /* namespace g2e */
