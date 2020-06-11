/*
 * API.cpp
 *
 *  Created on: 2013. 6. 27.
 *      Author: gubee
 */

#include "API.h"

#if !defined(F_RUNTIME_EMSCRIPTEN) && !defined(F_RUNTIME_FLASCC)
namespace internals {
#define F_API(function)     {#function, ::function}
#define F_API_END           {0, 0}

    struct API {
        const char* name;
        APIPrototype function;
    };

    API apis[] = {
        // StackFrame APIs
        F_API(StackFrame_top),
        F_API(StackFrame_push),
        F_API(StackFrame_pop),

        // List APIs
        F_API(List_new),
        F_API(List_delete),
        F_API(List_append),
        F_API(List_remove),
        F_API(List_removeAt),
        F_API(List_count),
        F_API(List_indexOf),
        F_API(List_at),
        F_API(List_setAt),

        // Map APIs
        F_API(Map_new),
        F_API(Map_delete),
        F_API(Map_insert),
        F_API(Map_remove),
        F_API(Map_count),
        F_API(Map_names),
        F_API(Map_value),

        // Class APIs
        F_API(Class_new),
        F_API(Class_defineMethod),
        F_API(Class_defineProperty),
        F_API(Class_defineSignal),
        F_API(Class_name),
        F_API(Class_base),
        F_API(Class_enumCount),
        F_API(Class_enum),
        F_API(Class_methodCount),
        F_API(Class_method),
        F_API(Class_propertyCount),
        F_API(Class_property),
        F_API(Class_signalCount),
        F_API(Class_signal),

        // Enum APIs
        F_API(Enum_name),
        F_API(Enum_values),

        // Method APIs
        F_API(Method_name),
        F_API(Method_call),

        // Property APIs
        F_API(Property_name),
        F_API(Property_type),
        F_API(Property_isReadOnly),
        F_API(Property_read),
        F_API(Property_write),

        // Signal APIs
        F_API(Signal_name),
        F_API(Signal_connect),
        F_API(Signal_disconnect),
        F_API(Signal_emit),

        // Object APIs
        F_API(Object_new),
        F_API(Object_delete),
        F_API(Object_class),

        F_API_END
    };
}
#endif  // !defined(F_RUNTIME_EMSCRIPTEN) && !defined(F_RUNTIME_FLASCC)
