from linode import api as linode_api


class APICallMethod:
    """Imitates a method of the Handler class, and calls a specific API method."""
    def __init__(self, api_conn, method_name):
        self._api_conn = api_conn
        self._method = getattr(self._api_conn, method_name)
    def __call__(self, **kwargs):
        return self._method(**kwargs)


class Handler:
    """Passes on API calls to the linode library.
    
       You must set `api_key` before calling any API methods.
       
       The API methods you can call are the same as those offered by `linode.api.Api`."""
    def __init__(self):
        self.api_key = None
        self._api = None
    def __getattr__(self, name):
        return APICallMethod(self._get_api(), name)
    def _get_api(self):
        if self.api_key is None:
            raise RuntimeError("You must set the Handler's `api_key` attribute before using it")
        if self._api is None:
            self._api = linode_api.Api(self.api_key)
        return self._api


api_handler = Handler()
