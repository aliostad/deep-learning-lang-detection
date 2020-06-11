#ifndef __INVOKEACCESSEDMETHOD_H__
#define __INVOKEACCESSEDMETHOD_H__

#include "methodInvoke.h"
#include "fieldAccess.h"

class InvokeAccessedMethod : public MethodInvoke {
    // Rule: INVOKE_METHOD_ACCESS
    private:
        FieldAccess* accessedMethod;
    public:
        InvokeAccessedMethod(FieldAccess* accessedMethod, ArgumentsStar* args) :
                             MethodInvoke(args), accessedMethod(accessedMethod) {}
        ~InvokeAccessedMethod() {
            delete accessedMethod;
        }

        FieldAccess* getAccessedMethod() { return accessedMethod; }

        std::string methodInvocationMatchToSignature() {
            return accessedMethod->getAccessedFieldId()->getIdAsString() + "(" +
                   args->stringifyArgumentsToType() + ")";
        }
};

#endif
