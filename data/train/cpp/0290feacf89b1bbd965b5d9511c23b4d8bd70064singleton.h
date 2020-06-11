#ifndef SINGLETON_H
#define SINGLETON_H

template <typename T> class Singleton{
private:
    struct Handler{
        T* instance;
        Handler():instance(0){}
        ~Handler(){ if (instance) delete instance; }
    };
    static Handler handler;
protected:
    Singleton(){}
    ~Singleton(){}
public:
    static T* getInstance(){
        if (!handler.instance) handler.instance = new T;
        return (static_cast<T*>(handler.instance));
    }
    static void libererInstance(){
        if (handler.instance){
            delete handler.instance;
            handler.instance = 0;
        }
    }
};

template <typename T>
typename Singleton<T>::Handler Singleton<T>::handler = Singleton<T>::Handler();

#endif // SINGLETON_H
