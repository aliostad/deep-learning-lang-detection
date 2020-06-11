#ifndef __RTL_STUB_H__
#define __RTL_STUB_H__

#include "RTL.h"

//==================================DATA======================================//
#pragma data_seg(".data")
//============================================================================//
#define FUNCTION_POINTER(X) f##X X = 0

//Init
FUNCTION_POINTER(RTL_Init);

//Byte Copy
FUNCTION_POINTER(RTL_Copy);

//Byte Translation
FUNCTION_POINTER(RTL_BytesToUnit);
FUNCTION_POINTER(RTL_ByteOffsetToUnitOffset);
FUNCTION_POINTER(RTL_BytesToSectors);
FUNCTION_POINTER(RTL_BytesToPages);
FUNCTION_POINTER(RTL_ByteOffsetToLBA);

//String operations
FUNCTION_POINTER(STRING_Compare);
FUNCTION_POINTER(STRING_Append);
FUNCTION_POINTER(STRING_Copy);

//Heap operations
FUNCTION_POINTER(HEAP_Alloc);
FUNCTION_POINTER(HEAP_Free);

//List operations
FUNCTION_POINTER(LIST_Init);
FUNCTION_POINTER(LIST_IsEmpty);
FUNCTION_POINTER(LIST_InsertHead);
FUNCTION_POINTER(LIST_InsertTail);
FUNCTION_POINTER(LIST_Remove);
FUNCTION_POINTER(LIST_First);
FUNCTION_POINTER(LIST_Next);

//Console operations
FUNCTION_POINTER(CONSOLE_Init);
FUNCTION_POINTER(CONSOLE_SetCursor);
FUNCTION_POINTER(CONSOLE_GetX);
FUNCTION_POINTER(CONSOLE_GetY);
FUNCTION_POINTER(CONSOLE_Clear);
FUNCTION_POINTER(CONSOLE_Write);
FUNCTION_POINTER(CONSOLE_NewLine);
FUNCTION_POINTER(CONSOLE_WriteLn);
FUNCTION_POINTER(CONSOLE_WriteNumber);

//==================================CODE======================================//
#pragma code_seg(".code")
//============================================================================//

#define LoadExportedFunction(Y, X)	string X##_name = STRING(#X); \
					X = (f##X) XKY_LDR_GetProcedureAddress((Y), &X##_name); \
					if(!X) return false

PUBLIC bool LoadRTL(VIRTUAL _load_address)
{
	string RTL_module = STRING("COMMONS\\RTL.x");

	if(XKY_LDR_LoadUserModule(&RTL_module, XKY_ADDRESS_SPACE_GetCurrent(), _load_address))
	{
		//Init
		LoadExportedFunction(_load_address, RTL_Init);

		//Byte Copy
		LoadExportedFunction(_load_address, RTL_Copy);

		//Byte Translation
		LoadExportedFunction(_load_address, RTL_BytesToUnit);
		LoadExportedFunction(_load_address, RTL_ByteOffsetToUnitOffset);
		LoadExportedFunction(_load_address, RTL_BytesToSectors);
		LoadExportedFunction(_load_address, RTL_BytesToPages);
		LoadExportedFunction(_load_address, RTL_ByteOffsetToLBA);

		//String operations
		LoadExportedFunction(_load_address, STRING_Compare);
		LoadExportedFunction(_load_address, STRING_Append);
		LoadExportedFunction(_load_address, STRING_Copy);

		//Heap operations
		LoadExportedFunction(_load_address, HEAP_Alloc);
		LoadExportedFunction(_load_address, HEAP_Free);

		//List operations
		LoadExportedFunction(_load_address, LIST_Init);
		LoadExportedFunction(_load_address, LIST_IsEmpty);
		LoadExportedFunction(_load_address, LIST_InsertHead);
		LoadExportedFunction(_load_address, LIST_InsertTail);
		LoadExportedFunction(_load_address, LIST_Remove);
		LoadExportedFunction(_load_address, LIST_First);
		LoadExportedFunction(_load_address, LIST_Next);

		//Console operaons
		LoadExportedFunction(_load_address, CONSOLE_Init);
		LoadExportedFunction(_load_address, CONSOLE_SetCursor);
		LoadExportedFunction(_load_address, CONSOLE_GetX);
		LoadExportedFunction(_load_address, CONSOLE_GetY);
		LoadExportedFunction(_load_address, CONSOLE_Clear);
		LoadExportedFunction(_load_address, CONSOLE_Write);
		LoadExportedFunction(_load_address, CONSOLE_NewLine);
		LoadExportedFunction(_load_address, CONSOLE_WriteLn);
		LoadExportedFunction(_load_address, CONSOLE_WriteNumber);

		return RTL_Init();
	}

	return false;
}

#endif //__RTL_STUB_H__
