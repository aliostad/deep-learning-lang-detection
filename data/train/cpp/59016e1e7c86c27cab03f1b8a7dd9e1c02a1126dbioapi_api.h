/*-----------------------------------------------------------------------
 * File: BioAPI_API.H
 *
 *-----------------------------------------------------------------------
 */

#ifndef _BioAPIAPI_H
#define _BioAPIAPI_H

/* API Functions */
#ifdef __cplusplus
extern "C" {
#endif

/*************************************************************************/
/*** BioAPI Core Functions ***********************************************/
/*************************************************************************/

BioAPI_RETURN BioAPI BioAPI_Init(
						const BioAPI_VERSION *Version,
						uint32 Reserved1,
						const void *Reserved2,
						uint32 Reserved3,
						const void *Reserved4 );

BioAPI_RETURN BioAPI BioAPI_Terminate(
						void );

BioAPI_RETURN BioAPI BioAPI_ModuleLoad(
						const BioAPI_UUID *ModuleGuid,
						uint32 Reserved,
						BioAPI_ModuleEventHandler AppNotifyCallback,
						void *AppNotifyCallbackCtx );

BioAPI_RETURN BioAPI BioAPI_ModuleUnload(
						const BioAPI_UUID *ModuleGuid,
						BioAPI_ModuleEventHandler AppNotifyCallback,
						void *AppNotifyCallbackCtx );

BioAPI_RETURN BioAPI BioAPI_ModuleAttach(
						const BioAPI_UUID *ModuleGuid,
						const BioAPI_VERSION *Version,
						const BioAPI_MEMORY_FUNCS *MemoryFuncs,
						uint32 DeviceID,
						uint32 Reserved1,
						uint32 Reserved2,
						uint32 Reserved3,
						BioAPI_FUNC_NAME_ADDR *FunctionTable,
						uint32 NumFunctionTable,
						const void *Reserved4,
						BioAPI_HANDLE_PTR NewModuleHandle );

BioAPI_RETURN BioAPI BioAPI_ModuleDetach(
						BioAPI_HANDLE ModuleHandle );

BioAPI_RETURN BioAPI BioAPI_QueryDevice(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_SERVICE_UID_PTR ServiceUID );


/*************************************************************************/
/*** BioAPI Service Functions ********************************************/
/*************************************************************************/

BioAPI_RETURN BioAPI BioAPI_FreeBIRHandle(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_BIR_HANDLE BIRHandle );

BioAPI_RETURN BioAPI BioAPI_GetBIRFromHandle(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_BIR_HANDLE BIRHandle,
						BioAPI_BIR_PTR *BIR );

BioAPI_RETURN BioAPI BioAPI_GetHeaderFromHandle(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_BIR_HANDLE BIRHandle,
						BioAPI_BIR_HEADER_PTR Header );

BioAPI_RETURN BioAPI BioAPI_EnableEvents(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_MODULE_EVENT_MASK *Events );

BioAPI_RETURN BioAPI BioAPI_SetGUICallbacks(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_GUI_STREAMING_CALLBACK GuiStreamingCallback,
						void *GuiStreamingCallbackCtx,
						BioAPI_GUI_STATE_CALLBACK GuiStateCallback,
						void *GuiStateCallbackCtx );

BioAPI_RETURN BioAPI BioAPI_SetStreamCallback(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_STREAM_CALLBACK StreamCallback,
						void *StreamCallbackCtx );

BioAPI_RETURN BioAPI BioAPI_StreamInputOutput(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_DATA_PTR InMessage,
						BioAPI_DATA_PTR OutMessage );

BioAPI_RETURN BioAPI BioAPI_Capture(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_BIR_PURPOSE Purpose,
						BioAPI_BIR_HANDLE_PTR CapturedBIR,
						sint32 Timeout,
						BioAPI_BIR_HANDLE_PTR AuditData );

BioAPI_RETURN BioAPI BioAPI_CreateTemplate(
						BioAPI_HANDLE ModuleHandle,
						const BioAPI_INPUT_BIR *CapturedBIR,
						const BioAPI_INPUT_BIR *StoredTemplate,
						BioAPI_BIR_HANDLE_PTR NewTemplate,
						const BioAPI_DATA *Payload );

BioAPI_RETURN BioAPI BioAPI_Process(
						BioAPI_HANDLE ModuleHandle,
						const BioAPI_INPUT_BIR *CapturedBIR,
						BioAPI_BIR_HANDLE_PTR ProcessedBIR );

BioAPI_RETURN BioAPI BioAPI_VerifyMatch(
						BioAPI_HANDLE ModuleHandle,
						const BioAPI_FAR *MaxFARRequested,
						const BioAPI_FRR *MaxFRRRequested,
						const BioAPI_BOOL *FARPrecedence,
						const BioAPI_INPUT_BIR *ProcessedBIR,
						const BioAPI_INPUT_BIR *StoredTemplate,
						BioAPI_BIR_HANDLE *AdaptedBIR,
						BioAPI_BOOL *Result,
						BioAPI_FAR_PTR FARAchieved,
						BioAPI_FRR_PTR FRRAchieved,
						BioAPI_DATA_PTR *Payload );

BioAPI_RETURN BioAPI BioAPI_IdentifyMatch(
						BioAPI_HANDLE ModuleHandle,
						const BioAPI_FAR *MaxFARRequested,
						const BioAPI_FRR *MaxFRRRequested,
						const BioAPI_BOOL *FARPrecedence,
						const BioAPI_INPUT_BIR *ProcessedBIR,
						const BioAPI_IDENTIFY_POPULATION *Population,
						BioAPI_BOOL Binning,
						uint32 MaxNumberOfResults,
						uint32 *NumberOfResults,
						BioAPI_CANDIDATE_ARRAY_PTR *Candidates,
						sint32 Timeout );

BioAPI_RETURN BioAPI BioAPI_Enroll(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_BIR_PURPOSE Purpose,
						const BioAPI_INPUT_BIR *StoredTemplate,
						BioAPI_BIR_HANDLE_PTR NewTemplate,
						const BioAPI_DATA *Payload,
						sint32 Timeout,
						BioAPI_BIR_HANDLE_PTR AuditData );

BioAPI_RETURN BioAPI BioAPI_Verify(
						BioAPI_HANDLE ModuleHandle,
						const BioAPI_FAR *MaxFARRequested,
						const BioAPI_FRR *MaxFRRRequested,
						const BioAPI_BOOL *FARPrecedence,
						const BioAPI_INPUT_BIR *StoredTemplate,
						BioAPI_BIR_HANDLE_PTR AdaptedBIR,
						BioAPI_BOOL *Result,
						BioAPI_FAR_PTR FARAchieved,
						BioAPI_FRR_PTR FRRAchieved,
						BioAPI_DATA_PTR *Payload,
						sint32 Timeout,
						BioAPI_BIR_HANDLE_PTR AuditData );

BioAPI_RETURN BioAPI BioAPI_Identify(
						BioAPI_HANDLE ModuleHandle,
						const BioAPI_FAR *MaxFARRequested,
						const BioAPI_FRR *MaxFRRRequested,
						const BioAPI_BOOL *FARPrecedence,
						const BioAPI_IDENTIFY_POPULATION *Population,
						BioAPI_BOOL Binning,
						uint32 MaxNumberOfResults,
						uint32 *NumberOfResults,
						BioAPI_CANDIDATE_ARRAY_PTR *Candidates,
						sint32 Timeout,
						BioAPI_BIR_HANDLE_PTR AuditData );

BioAPI_RETURN BioAPI BioAPI_Import(
						BioAPI_HANDLE ModuleHandle,
						const BioAPI_DATA *InputData,
						BioAPI_BIR_BIOMETRIC_DATA_FORMAT InputFormat,
						BioAPI_BIR_PURPOSE Purpose,
						BioAPI_BIR_HANDLE_PTR ConstructedBIR );

BioAPI_RETURN BioAPI BioAPI_SetPowerMode(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_POWER_MODE PowerMode );

BioAPI_RETURN BioAPI BioAPI_DbOpen(
						BioAPI_HANDLE ModuleHandle,
						const uint8 *DbName,
						BioAPI_DB_ACCESS_TYPE AccessRequest,
						BioAPI_DB_HANDLE_PTR DbHandle,
						BioAPI_DB_CURSOR_PTR Cursor );

BioAPI_RETURN BioAPI BioAPI_DbClose(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_DB_HANDLE DbHandle );

BioAPI_RETURN BioAPI BioAPI_DbCreate(
						BioAPI_HANDLE ModuleHandle,
						const uint8 *DbName,
						BioAPI_DB_ACCESS_TYPE AccessRequest,
						BioAPI_DB_HANDLE_PTR DbHandle );

BioAPI_RETURN BioAPI BioAPI_DbDelete(
						BioAPI_HANDLE ModuleHandle,
						const uint8 *DbName );

BioAPI_RETURN BioAPI BioAPI_DbSetCursor(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_DB_HANDLE DbHandle,
						const BioAPI_UUID *KeyValue,
						BioAPI_DB_CURSOR_PTR Cursor );

BioAPI_RETURN BioAPI BioAPI_DbFreeCursor(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_DB_CURSOR_PTR Cursor );

BioAPI_RETURN BioAPI BioAPI_DbStoreBIR(
						BioAPI_HANDLE ModuleHandle,
						const BioAPI_INPUT_BIR *BIRToStore,
						BioAPI_DB_HANDLE DbHandle,
						BioAPI_UUID_PTR Uuid );

BioAPI_RETURN BioAPI BioAPI_DbGetBIR(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_DB_HANDLE DbHandle,
						const BioAPI_UUID *KeyValue,
						BioAPI_BIR_HANDLE_PTR RetrievedBIR,
						BioAPI_DB_CURSOR_PTR Cursor );

BioAPI_RETURN BioAPI BioAPI_DbGetNextBIR(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_DB_CURSOR_PTR Cursor,
						BioAPI_BIR_HANDLE_PTR RetievedBIR,
						BioAPI_UUID_PTR Uuid );

BioAPI_RETURN BioAPI BioAPI_DbQueryBIR(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_DB_HANDLE DbHandle,
						const BioAPI_INPUT_BIR *BIRToQuery,
						BioAPI_UUID_PTR Uuid );

BioAPI_RETURN BioAPI BioAPI_DbDeleteBIR(
						BioAPI_HANDLE ModuleHandle,
						BioAPI_DB_HANDLE DbHandle,
						const BioAPI_UUID *KeyValue );


/*************************************************************************/


#ifdef __cplusplus
}
#endif

#endif /* _BioAPIAPI_H */
