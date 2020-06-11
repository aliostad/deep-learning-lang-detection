
from epyrpc.api.ApiParamError import ApiParamError
from epyrpc.api.UnknownApiError import UnknownApiError
from epyrpc.api.eApiType import eApiType

class ApiFactory(object):
    r"""
    @summary: Create the API objects for use with the IPC.
    """
    @staticmethod
    def get(e_api_type, *args, **kwargs):
        r"""
        @param e_api_type: Subjective 'type' of API.
        @see: eApiType.
        """
        if not eApiType.isValid(e_api_type):
            raise ApiParamError(e_api_type, eApiType)
        if e_api_type == eApiType.EO_V1:
            from epyrpc.api.eo_v1.impl.head.Api import api as HeadAPI
            api_ = HeadAPI(*args, **kwargs)
            return api_
        elif e_api_type == eApiType.EO_V1__HANDLER:
            from epyrpc.api.eo_v1.impl.neck.Api import api as NeckAPI
            api_ = NeckAPI(*args, **kwargs)
            return api_
        raise UnknownApiError("%(T)s" % {"T":type(eApiType)})
