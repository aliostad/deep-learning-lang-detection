#pragma once

#include "htAppWindows.h"

namespace hooktail
{

typedef enum _HT_API_TYPE
{
    HT_API_NONE = 0,
    HT_API_OGL,
    HT_API_DX,
    HT_API_CUDA,
} HT_API_TYPE;


class AppAPI : public AppWindows
{
public:
                                AppAPI(HT_API_TYPE in_type);

    HT_API_TYPE                 GetAPIType() const { return m_apiType; }

protected:

    virtual HRESULT             InitAPI() = 0;
    void                        SetAPIType(const HT_API_TYPE in_type) { m_apiType = in_type; }

    HT_API_TYPE                 m_apiType;
};

inline
AppAPI::AppAPI(HT_API_TYPE in_type) : m_apiType(in_type)
{
    HT_TRACE_IN();
    HT_TRACE_OUT();
}


} // namespace hooktail
