// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#include "Web.h"

namespace Eegeo
{
    namespace Web
    {
        class IWebLoadRequestCompletionCallback
        {
        public:
        	virtual ~IWebLoadRequestCompletionCallback() {;}
            virtual void operator()(IWebLoadRequest& webLoadRequest) = 0;
        };

        template <class T> class TWebLoadRequestCompletionCallback : public IWebLoadRequestCompletionCallback
        {
        private:
            void (T::*m_callback)(IWebLoadRequest& webLoadRequest);
            T* m_context;
        public:
            TWebLoadRequestCompletionCallback(T* context, void (T::*callback)(IWebLoadRequest& webLoadRequest))
            : m_context(context)
            , m_callback(callback)
            {
            }
            
            virtual void operator()(IWebLoadRequest& webLoadRequest)
            {
                (*m_context.*m_callback)(webLoadRequest);
            }
        };
    }
}
