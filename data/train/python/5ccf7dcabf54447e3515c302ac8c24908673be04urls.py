from django.conf.urls import patterns, url
from django.contrib.auth.decorators import login_required

from jobseeker.views import JobseekerRegistration, SavePersonalDetails, SaveCurrentEmployerDetails,\
  SaveEducationalDetails, SaveResumeDetails, SavePhotoDetails, JobSeekerView, EditDetails,\
JobSearch, ApplyJobs,Companies, ActivityLog, JobDetails, SaveUserLoginDetails, JobseekerDashboard

urlpatterns = patterns('',
    url(r'^registration/$', JobseekerRegistration.as_view(), name="jobseeker_registration"),
    url(r'^dashboard/$', login_required(JobseekerDashboard.as_view(), login_url="/login/"), name="jobseeker_dashboard"),
    url(r'^save_user_login_details/$', SaveUserLoginDetails.as_view(), name="save_user_login_details"),
    url(r'^save_personal_details/$', SavePersonalDetails.as_view(), name="save_personal_details"),
    url(r'^save_current_employer_details/$', SaveCurrentEmployerDetails.as_view(), name="save_current_employer_details"),
    url(r'^save_educational_details/$', SaveEducationalDetails.as_view(), name="save_educational_details"),
    url(r'^save_resume_details/$', SaveResumeDetails.as_view(), name="save_resume_details"),
    url(r'^save_photo_details/$', SavePhotoDetails.as_view(), name="save_photo_details"),
    url(r'^jobseeker_details/$', JobSeekerView.as_view(), name="jobseeker_details"),
    url(r'^edit_details/(?P<jobseeker_id>\d+)/$', EditDetails.as_view(), name="edit_details"),
    url(r'^get_companies/$', Companies.as_view(), name="get_companies"),
  	url(r'^job_search/$', JobSearch.as_view(), name='job_search'),
    url(r'^jobseeker_log/$', login_required(ActivityLog.as_view(), login_url="/login/"), name='jobseeker_log'),  	
    url(r'^apply/(?P<job_id>\d+)/$', login_required(ApplyJobs.as_view(), login_url="/login/"), name='apply_jobs'),
    url(r'^view_job_details/(?P<job_id>\d+)/$', JobDetails.as_view(), name='view_job_details'),
)