#include "ClientHandler.h"

#include "ClientContextMenuHandler.h"
#include "ClientDialogHandler.h"
#include "ClientDisplayHandler.h"
#include "ClientDownloadHandler.h"
#include "ClientFocusHandler.h"
#include "ClientGeolocationHandler.h"
#include "ClientJSDialogHandler.h"
#include "ClientKeyboardHandler.h"
#include "ClientLifeSpanHandler.h"
#include "ClientLoadHandler.h"
#include "ClientRenderHandler.h"
#include "ClientRequestHandler.h"


ClientHandler::ClientHandler(        
    CefRefPtr<ClientContextMenuHandler> contextMenuHandler,
    CefRefPtr<ClientDialogHandler> dialogHandler,
    CefRefPtr<ClientDisplayHandler> displayHandler,
    CefRefPtr<ClientDownloadHandler> downloadHandler,
    CefRefPtr<ClientFocusHandler> focusHandler,
    CefRefPtr<ClientGeolocationHandler> geolocationHandler,
    CefRefPtr<ClientJSDialogHandler> jsdialogHandler,
    CefRefPtr<ClientKeyboardHandler> keyboardHandler,
    CefRefPtr<ClientLifeSpanHandler> lifeSpanHandler,
    CefRefPtr<ClientLoadHandler> loadHandler,
    CefRefPtr<ClientRenderHandler> renderHandler,
    CefRefPtr<ClientRequestHandler> requestHandler) :   
            m_contextMenuHandler(contextMenuHandler),
            m_dialogHandler(dialogHandler),
            m_displayHandler(displayHandler),
            m_downloadHandler(downloadHandler),
            m_focusHandler(focusHandler),
            m_geolocationHandler(geolocationHandler),
            m_jsdialogHandler(jsdialogHandler),
            m_keyboardHandler(keyboardHandler),
            m_lifeSpanHandler(lifeSpanHandler),
            m_loadHandler(loadHandler),
            m_renderHandler(renderHandler),
            m_requestHandler(requestHandler)
{
    m_lifeSpanHandler->SetNullBrowser(new NullBrowser(this));
}


ClientHandler::~ClientHandler(void)
{
}


CefRefPtr<CefContextMenuHandler> ClientHandler::GetContextMenuHandler()
{
    return m_contextMenuHandler.get();
}


CefRefPtr<CefDialogHandler> ClientHandler::GetDialogHandler()
{
    return m_dialogHandler.get();
}


CefRefPtr<CefDisplayHandler> ClientHandler::GetDisplayHandler()
{
    return m_displayHandler.get();
}


CefRefPtr<CefDownloadHandler> ClientHandler::GetDownloadHandler()
{
    return m_downloadHandler.get();
}


CefRefPtr<CefFocusHandler> ClientHandler::GetFocusHandler()
{
    return m_focusHandler.get();
}


CefRefPtr<CefGeolocationHandler> ClientHandler::GetGeolocationHandler()
{
    return m_geolocationHandler.get();
}


CefRefPtr<CefJSDialogHandler> ClientHandler::GetJSDialogHandler()
{
    return m_jsdialogHandler.get();
}


CefRefPtr<CefKeyboardHandler> ClientHandler::GetKeyboardHandler()
{
    return m_keyboardHandler.get();
}


CefRefPtr<CefLifeSpanHandler> ClientHandler::GetLifeSpanHandler()
{
    return m_lifeSpanHandler.get();
}


CefRefPtr<CefLoadHandler> ClientHandler::GetLoadHandler()
{
    return m_loadHandler.get();
}


CefRefPtr<CefRenderHandler> ClientHandler::GetRenderHandler()
{
    return m_renderHandler.get();
}


CefRefPtr<CefRequestHandler> ClientHandler::GetRequestHandler()
{
    return m_requestHandler.get();
}


bool ClientHandler::OnProcessMessageReceived( 
    CefRefPtr<CefBrowser> browser, CefProcessId source_process, CefRefPtr<CefProcessMessage> message )
{
    return false;
}


CefRefPtr<CefBrowser> ClientHandler::GetBrowser()
{
    return m_lifeSpanHandler->GetBrowser();
}


int ClientHandler::GetBrowserId()
{
    return m_lifeSpanHandler->GetBrowserId();
}
