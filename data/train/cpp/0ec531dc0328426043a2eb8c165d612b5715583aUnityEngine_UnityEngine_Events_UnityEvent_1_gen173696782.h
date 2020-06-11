#pragma once

#include "il2cpp-config.h"

#ifndef _MSC_VER
# include <alloca.h>
#else
# include <malloc.h>
#endif

#include <stdint.h>

// System.Object[]
struct ObjectU5BU5D_t1108656482;

#include "UnityEngine_UnityEngine_Events_UnityEventBase1020378628.h"

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-offsetof"
#pragma clang diagnostic ignored "-Wunused-variable"
#endif

// UnityEngine.Events.UnityEvent`1<UnityEngine.Vector2>
struct  UnityEvent_1_t173696782  : public UnityEventBase_t1020378628
{
public:
	// System.Object[] UnityEngine.Events.UnityEvent`1::m_InvokeArray
	ObjectU5BU5D_t1108656482* ___m_InvokeArray_4;

public:
	inline static int32_t get_offset_of_m_InvokeArray_4() { return static_cast<int32_t>(offsetof(UnityEvent_1_t173696782, ___m_InvokeArray_4)); }
	inline ObjectU5BU5D_t1108656482* get_m_InvokeArray_4() const { return ___m_InvokeArray_4; }
	inline ObjectU5BU5D_t1108656482** get_address_of_m_InvokeArray_4() { return &___m_InvokeArray_4; }
	inline void set_m_InvokeArray_4(ObjectU5BU5D_t1108656482* value)
	{
		___m_InvokeArray_4 = value;
		Il2CppCodeGenWriteBarrier(&___m_InvokeArray_4, value);
	}
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif
