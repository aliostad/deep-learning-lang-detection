#include <Windows.h>
#include "Session.hpp"
#include "ApiKey.h"

Session::Session()
{
	// API Keyの初期値を設定
	this->SetApiKey(API_KEY, API_SECRET);
	this->ClearAccessToken();
}

void Session::SetApiKey(const TCHAR * const ApiKey, const TCHAR * const ApiSecret)
{
#if defined(UNICODE)
	int Length;

	if(ApiKey != nullptr)
	{
		Length = ::wcslen(ApiKey);
		::WideCharToMultiByte(437, 0, ApiKey, Length, this->ApiKey, sizeof(this->ApiKey), nullptr, nullptr);
	}
	if(ApiSecret != nullptr)
	{
		Length = ::wcslen(ApiSecret);
		::WideCharToMultiByte(437, 0, ApiSecret, Length, this->ApiSecret, sizeof(this->ApiSecret), nullptr, nullptr);
	}
#else
	if(ApiKey != nullptr)
	{
		::strcpy_s(this->ApiKey, sizeof(this->ApiKey), API_KEY);
	}
	if(ApiSecret != nullptr)
	{
		::strcpy_s(this->ApiSecret, sizeof(this->ApiSecret), API_SECRET);
	}
#endif
}

void Session::ClearAccessToken()
{
	::memset(this->AccessToken, 0, sizeof(this->AccessToken));
	::memset(this->AccessTokenSecret, 0, sizeof(this->AccessTokenSecret));
}
