
class Endpoint:
    """ Represents a URL endpoint """
    
    def __init__(self, url, **kwargs):
        """ Initialize the Endpoint """
        if hasattr(url, 'url'):
            url = url.url
        self.url = url
        
        self.methodToController = {}
        for key in kwargs:
            self.methodToController[key.upper()] = kwargs[key]
        
    def register(self, app):
        """ Register the Endpoint with the server """
        for method in self.methodToController:
            controller = self.methodToController[method]
            app.add_url_rule(self.url, str(controller.perform), controller.perform, methods=[method])