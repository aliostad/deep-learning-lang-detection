#ifndef LOCATER_H
#define LOCATER_H

#include <QDebug>

#include <typeinfo>
#include <typeindex>
#include <unordered_map>
#include <cassert>

namespace instanceLocater {

class LocatorRegistry {
public:
    typedef std::type_index Key;

    static LocatorRegistry* instance();

    bool hasRegistered(Key key);
    void __register(Key key, void* value);
    void __unregister(Key key);
    void* __get(Key key);
private:
    static LocatorRegistry* singleton;
    std::unordered_map<Key, void*> registry;
};

}

template <class T>
class LocatorRegister {
public:
    LocatorRegister() {
        qDebug() << "LocatorRegister: reg" << typeid(T).name();
        instanceLocater::LocatorRegistry::instance()->__register(std::type_index(typeid(T)), this);
    }
    ~LocatorRegister() {
        qDebug() << "LocatorRegister: unreg" << typeid(T).name();
        instanceLocater::LocatorRegistry::instance()->__unregister(std::type_index(typeid(T)));
    }
};

template <class T>
T* Locator() {
    void* value = instanceLocater::LocatorRegistry::instance()->__get(std::type_index(typeid(T)));
    return static_cast<T*>(value);
}

#endif // LOCATER_H
