#ifndef __METHODNORMALINVOKE_H__
#define __METHODNORMALINVOKE_H__

#include "methodInvoke.h"
#include "name.h"

class MethodNormalInvoke : public MethodInvoke {
    // Rule: INVOKE_METHOD_NORM
    private:
        Name* methodInvoked;
    public:
        MethodNormalInvoke(Name* methodInvoked, ArgumentsStar* args) : MethodInvoke(args), methodInvoked(methodInvoked) {}
        ~MethodNormalInvoke() {
            delete methodInvoked;
        }

        Name* getNameOfInvokedMethod() { return methodInvoked; }

        std::string methodInvocationMatchToSignature() {
            return methodInvoked->getNameId()->getIdAsString() + "(" +
                   args->stringifyArgumentsToType() + ")";
        }
};

#endif
