from django.conf.urls import patterns, url, include

__author__ = 'm'


urlpatterns = patterns('students.views',
                       url(r'labs/new/$', 'labsview.new'),
                       url(r'labs/save/$', 'labsview.save'),
                       url(r'labs/delete/$', 'labsview.delete'),
                       url(r'labs/clear-image/$', 'labsview.clear_image'),
                       url(r'labs/save-order/$', 'labsview.lab_save_order'),
                       url(r'labs/save-task-marks/$', 'labsview.save_task_marks'),
                       url(r'labs/$', 'labsview.index'),

                       url(r'tasks/new/$', 'tasksview.new'),
                       url(r'tasks/save/$', 'tasksview.save'),
                       url(r'tasks/delete/$', 'tasksview.delete'),
                       )
