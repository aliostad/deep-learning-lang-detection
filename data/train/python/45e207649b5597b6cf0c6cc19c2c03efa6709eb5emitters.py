''' Core mDS API emitters.

@author: Sana Dev Team
Created on May 20, 2011
'''

from piston.emitters import *

class APIResponseEmitter(Emitter):
    """
    Emitter for the Django serialized format.
    """
    def render(self, request, format='xml'):
        if isinstance(self.data, HttpResponse):
            return self.data
        elif isinstance(self.data, (int, str)):
            response = self.data
        else:
            response = serializers.serialize(format, self.data, indent=True)

        return response

class DispatchEmitter(Emitter):
    
    def emit(self, method='GET'):
        if method == 'POST': 
            cleaned_dispatch = self._post_dispatch()
        else:
            cleaned_dispatch = self._get_dispatch()
        return cleaned_dispatch
    
    def _post_dispatch(self):
        self.full_clean()
        if self.is_valid():
            return self.cleaned_data
        else:
            return {}
        
    def _get_dispatch(self):
        cleaned_dispatch = {}
        for field in self.fields:
            value = field.widget.to_python()
        if value:
            cleaned_dispatch[field.__name__] = value
        return cleaned_dispatch