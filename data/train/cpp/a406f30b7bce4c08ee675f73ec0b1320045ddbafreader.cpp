#include <SDL.h>
#include <framework/framework.h>
#include <iostream>
#include "lua/lua.hpp"

struct ISampleA
{
    virtual void showA() = 0;
};

struct ISampleAImpl
    :public ISampleA
{
    void* self;
    void showA();
};

void ISampleAImpl::showA()
{
    lua_State* L;
    
    luaL_setmetatable(L, "ISampleA");
    
    //lua_pcall(L, 0, 0, NULL);
}

struct ISampleB
{
    virtual void showB() = 0;
};

struct ISampleC
{
    virtual void showC() = 0;
};

class SampleA
    :public framework::Component, ISampleA
{
    virtual void showA();
    
public:
    static int luaShowA(lua_State* L);
};

int SampleA::luaShowA(lua_State *L)
{
    SampleA* self = (SampleA*)luaL_testudata(L, 1, "SampleA");
    
    self->showA();
    return 0;
}

static struct luaL_Reg sSampleA_Facade_ISampleA[] = {
    {"showA", &SampleA::luaShowA},
    {NULL,NULL}
};

class SampleB
    :public framework::Component, ISampleB
{
    virtual void showB();
};

class SampleC
    :public framework::Component
{
public:
    SampleC();
private:
    SampleA*    m_sampleA;
    SampleB*    m_sampleB;
    ISampleC*   m_ISampleC;
};

SampleC::SampleC()
{
    m_sampleA = new SampleA;
    m_sampleB = new SampleB;
}

void SampleA::showA()
{
    std::cout << "SampleA::showA" << std::endl;
}

void SampleB::showB()
{
    std::cout << "SampleB::showB" << std::endl;
}

class SampleD
    :public framework::Component, ISampleC
{
    SampleC*    m_sampleC;
    
    virtual void showC();
public:
    SampleD();
};

SampleD::SampleD()
{
    m_sampleC = new SampleC;
    
    m_sampleC->delegate<ISampleC>(this);
}

void SampleD::showC()
{
    std::cout << "SampleC::showC" << std::endl;
}

int main(int argc, char* argv[])
{
    USE_NS_FRAMEWORK;
    
    lua_State* state = luaL_newstate();
    
    SampleD* sampleD = new SampleD;
    
    ISampleA* sampleA = sampleD->facade<ISampleA>();
    
    sampleA->showA();
    
    lua_close(state);
    
    return 0;
}
