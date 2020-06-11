#include "api_public.h"
#include "api_local.h"

apiImport_t *ai = (apiImport_t *)0;

__declspec(dllexport) int GetModuleAPI(apiImport_t *apiIn, apiExport_t *apiOut) {

	if(!apiIn || !apiOut) return 0;

	ai = apiIn;

	apiOut->Connect			= ConnectionManager::Connect;
	apiOut->Disconnect		= ConnectionManager::Disconnect;
	apiOut->Login			= ConnectionManager::Login;
	apiOut->Logout			= ConnectionManager::Logout;

	apiOut->ProgressReport	= AchievementManager::ProgressReport;
	apiOut->UnlockAchieve	= AchievementManager::UnlockAchieve;

	return API_VERSION;
}

#ifdef WIN32
BOOL WINAPI DllMain(HINSTANCE hInDLL, DWORD fdwReason, LPVOID lpvReserved) {
	// not used
	return 1;
}
#endif