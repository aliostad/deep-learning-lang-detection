__author__ = 'Sergey Matyunin'

import copy
#from intermediate_saver import IntermediateSaver
class IntermediateSaver:
    def __init__(self, list_members_to_save, list_locals_to_save):
        self.list_members_to_save = list_members_to_save
        self.list_locals_to_save = list_locals_to_save
        self.data_members = []
        self.data_locals = []
        
        
    def save_members(self, obj):
        self.data_members.append({i:copy.copy(getattr(obj, i, None)) for i in self.list_members_to_save})
        
        
    def save_locals(self, locals_dict):
        self.data_locals.append({i:copy.copy(locals_dict.get(i, None)) for i in self.list_locals_to_save})