from django.conf.urls import patterns, url
from sfa_score.views import IndexTemplateView, ManageTemplateView
from sfa_score.models import Agegroup, Grade, Discipline, Pupil, Score

urlpatterns = patterns('sfa_score.views',
    #url(r'^$', direct_to_template, {'template': 'sfa_score/index.html', 'extra_context': {'groups': Group.objects.all(), 'disciplines': Discipline.objects.all(), }, }, name='index'),
    url(r'^$', IndexTemplateView.as_view(), name = 'index'),
    
    #url(r'^manage/$', direct_to_template, {'template': 'sfa_score/manage/index.html', 'extra_context': {'groups': Group.objects.all(), }, }, name='manage'),
    url(r'^manage/$', ManageTemplateView.as_view(), name = 'manage'),
    
	#url(r'^generate_lists/$', direct_to_template, {'template': 'sfa_score/generate_lists.html', 'extra_context': {'disciplines': Discipline.objects.all(), 'groups': [{'group': group, 'pupils': [{'pupil': pupil, 'scores': [Score.objects.get_or_create(pupil=pupil, discipline=discipline)[0] for discipline in Discipline.objects.all()], } for pupil in Pupil.objects.get(group=group)], } for group in Group.objects.all()], }, }),
    url(r'^change_pupils/$', 'change_pupils', name='change_pupils'),
    url(r'^generate_certificate/$', 'generate_certificate', name='generate_certificate'),
    url(r'^generate_certificate_background/$', 'generate_certificate_background', name='generate_certificate_background'),
    url(r'^generate_lists/$', 'generate_lists', name='generate_lists'),
    url(r'^manage/upload_pupils/$', 'manage_upload_pupils', name='manage_upload_pupils'),
    url(r'^manage/edit_group/$', 'manage_edit_group', name='manage_edit_group'),
)
