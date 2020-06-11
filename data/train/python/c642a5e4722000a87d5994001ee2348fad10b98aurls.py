from django.conf.urls import patterns, url

from conference_site.apps.management.views import ManageIncludedSubmissionsView, ManageAssignedReviewersView, ManageAddReviewerView, ManagePapersView, \
    ManageDeadlinesView, CreateProgram, ManageUsers, LoginAsUser, ManageEmailTemplates, ManageConference, ManageEmailQueue, ManageActiveConference

urlpatterns = patterns('',
                       url(r'^$', ManageIncludedSubmissionsView.as_view(), name="manage_included"),
                       url(r'^reviewers/$', ManageAssignedReviewersView.as_view(), name="manage_reviewers"),
                       url(r'^add-reviewer/$', ManageAddReviewerView.as_view(), name="manage_add_reviewer"),
                       url(r'^papers/$', ManagePapersView.as_view(), name="manage_papers"),
                       url(r'^deadlines/$', ManageDeadlinesView.as_view(), name="manage_deadlines"),
                       url(r'^create-program/$', CreateProgram.as_view(), name="manage_program"),
                       url(r'^users/$', ManageUsers.as_view(), name="manage_users"),
                       url(r'^emails/$', ManageEmailTemplates.as_view(), name="manage_emails"),
                       url(r'^email-queue/$', ManageEmailQueue.as_view(), name="manage_email_queue"),
                       url(r'^conference/$', ManageConference.as_view(), name="manage_conference"),
                       url(r'^active-conference/$', ManageActiveConference.as_view(), name="manage_active_conference"),
                       url(r'^login_as/(?P<pk>\d+)/$', LoginAsUser.as_view(), name='manage_login_as'),
                       )
