from ProvidenceClarity import PCController, PCAdapter


class AnalyzerController(PCController):

    _subcontrollers = {'mapper':['mapper','MapperController'],
                       'object':['object','ObjectAnalyzerController'],
                       'reducer':['reducer','ReducerController'],
                       'relation':['relation','RelationAnalyzerController'],
                       'graph':['graph','GraphAnalyzerController']}
    
    
class AnalyzerAdapter(PCAdapter):
    pass
    
    
_controller = AnalyzerController