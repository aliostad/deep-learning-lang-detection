from __future__ import absolute_import

from django import forms
from django.contrib import admin

from cobra.core.loading import get_model

Repository = get_model('svnkit', 'Repository')

class RepositoryForm(forms.ModelForm):
    password = forms.CharField(
        max_length=512, required=False, widget=forms.PasswordInput)

    class Meta:
        model = Repository
        exclude = ('uuid', 'last_synced')


class RepositoryAdmin(admin.ModelAdmin):
    form = RepositoryForm

    fieldsets = (
        (None, {'fields': ('project', 'root', 'uri', 'prefix', 'is_private')}),
        (u'Credentials', {'fields': ('username', 'password')}),
    )


admin.site.register(Repository, RepositoryAdmin)
