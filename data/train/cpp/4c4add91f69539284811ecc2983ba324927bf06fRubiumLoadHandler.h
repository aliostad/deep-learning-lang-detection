#ifndef LAMINA_LOAD_HANDLER_H
#define LAMINA_LOAD_HANDLER_H

#include "include/cef_load_handler.h"

class RubiumLoadHandler :
   public CefLoadHandler {

public:
   RubiumLoadHandler();
   ~RubiumLoadHandler();

   static RubiumLoadHandler* GetInstance();

   virtual void OnLoadError(CefRefPtr<CefBrowser> browser,
      CefRefPtr<CefFrame> frame,
      ErrorCode errorCode,
      const CefString& errorText,
      const CefString& failedUrl) OVERRIDE;

private:
   // Include the default reference counting implementation.
   IMPLEMENT_REFCOUNTING(RubiumLoadHandler);
};

#endif /* LAMINA_LOAD_HANDLER_H */