# -*- coding: utf-8 -*-

from __future__ import unicode_literals

from django import forms
from django.contrib import admin

from . import models


class GitHubStatsRepositoryAdminForm(forms.ModelForm):
    class Meta:
        model = models.GitHubStatsRepository
        fields = ('label', 'full_name', 'token')
        widgets = {
            'token': forms.PasswordInput(),
        }


class GitHubStatsRepositoryAdmin(admin.ModelAdmin):
    form = GitHubStatsRepositoryAdminForm


admin.site.register(models.GitHubStatsRepository, GitHubStatsRepositoryAdmin)
