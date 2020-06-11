##!/usr/bin/env python
import django.dispatch

from jobsboard.models import *

job_pre_status_changed = django.dispatch.Signal(providing_args=['old_job', 'new_job'])
job_post_status_changed = django.dispatch.Signal(providing_args=['old_job', 'new_job'])

applicant_pre_status_changed = django.dispatch.Signal(providing_args=['job', 'applicant', 'old_status', 'new_status'])
applicant_post_status_changed = django.dispatch.Signal(providing_args=['job', 'applicant', 'old_status', 'new_status'])

company_pre_edit = django.dispatch.Signal(providing_args=['name', 'added_by'])
