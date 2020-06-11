'''
Created on Jan 10, 2013

@author: dough
'''
from source_factory import SourceFactory
from view_sources_controller import ViewSourcesController
from schedule_recording_controller import ScheduleRecordingController
from view_schedules_controller import ViewSchedulesController

class ApplicationBoundary(object):
    '''
    classdocs
    '''

    def __init__(self):
        '''
        Constructor
        '''
        # application setup/configuration        
        sf = SourceFactory()
        master_source_list = []
        channels_conf_file = open('/home/dough/Downloads/channels.conf')
        master_source_list += sf.produce_batch(channels_conf_file)
        self.view_sources_controller = ViewSourcesController(master_source_list)        
        self.master_recording_schedule_list = []
        self.schedule_recording_controller = ScheduleRecordingController(master_source_list, 
                                                                         self.master_recording_schedule_list)
        self.view_schedules_controller = ViewSchedulesController(self.master_recording_schedule_list)
    
    def list_sources(self, request):
        return self.view_sources_controller.list_sources(request)
    
    def list_schedules(self, request):
        return self.view_schedules_controller.list_schedules(request)
    
    def schedule(self, recording_schedule_request):
        return self.schedule_recording_controller.schedule(recording_schedule_request)