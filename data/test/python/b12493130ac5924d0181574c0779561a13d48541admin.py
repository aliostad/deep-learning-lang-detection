from django.contrib import admin
from repositories.models import Repository, Credential
from repositories.forms import RepositoryForm, CredentialForm

class RepositoryAdmin(admin.ModelAdmin):
    form = RepositoryForm
    list_display = ('name', 'manager', 'endpoint')

class CredentialAdmin(admin.ModelAdmin):
    form = CredentialForm
    list_display = ('repository_name', 'public_key')

    def repository_name(sef, obj):
        return obj.repository.name

admin.site.register(Repository, RepositoryAdmin)
admin.site.register(Credential, CredentialAdmin)