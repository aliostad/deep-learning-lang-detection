'''
Created on 17-Jul-2012

@author: vijay
'''

from releasedata.models import ReleasePhase, Release
from effortdata.models import TaskType


def create_releases_data():
    data_1 = Release(relname='4.1 U3, Kl.Nxt', active=True)
    data_1.save()
    data_2 = Release(relname='5.1, MN.Nxt', active=True)
    data_2.save()
    data_3 = Release(relname='WS8', active=True)
    data_3.save()
    data_4 = Release(relname='WS9', active=True)
    data_4.save()
    data_5 = Release(relname='KL Next U3', active=True)
    data_5  .save()



def create_phase_data():

    rel_1 = ReleasePhase(release_phase='WS9', active=True)
    rel_1.save()
    rel_2 = ReleasePhase(release_phase='GA-1(RTM)', active=True)
    rel_2.save()
    rel_3 = ReleasePhase(release_phase='Regression', active=True)
    rel_3.save()
    rel_4 = ReleasePhase(release_phase='RC3', active=True)
    rel_4.save()
    rel_5 = ReleasePhase(release_phase='RTM1', active=True)
    rel_5.save()
    rel_6 = ReleasePhase(release_phase='RTM2', active=True)
    rel_6.save()
    rel_7 = ReleasePhase(release_phase='RTM3', active=True)
    rel_7.save()
    rel_8 = ReleasePhase(release_phase='sanity', active=True)
    rel_8.save()
    rel_9 = ReleasePhase(release_phase='RTM4 Sanity', active=True)
    rel_9.save()
    rel_10 = ReleasePhase(release_phase='WS8', active=True)
    rel_10.save()
    rel_11 = ReleasePhase(release_phase='RTM-Sanity')
    rel_11.save()




def create_taks():
    task_1 = TaskType(name='Automated TestCase Execution')
    task_1.save()
    task_2 = TaskType(name='Manual TestCase Execution')
    task_2.save()
    task_3 = TaskType(name='Setup')
    task_3.save()
    task_4 = TaskType(name='Test Case Debugging')
    task_4.save()
    task_5 = TaskType(name='Automated Framework Development')
    task_5.save()

create_releases_data()
create_phase_data()
create_taks()
