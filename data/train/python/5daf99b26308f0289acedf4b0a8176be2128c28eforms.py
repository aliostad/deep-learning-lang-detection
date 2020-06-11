from django import forms
from repositories.models import Repository, Credential
from repositories.managers import RepositoryManager
import repository

class RepositoryChoiceField(forms.ModelChoiceField):
    def label_from_instance(self, obj):
        return obj.name

class RepositoryForm(forms.ModelForm):
    class Meta:
        model = Repository

    # Repository managers are defined in repositories.repository.__init__
    manager_choices = [ (k,k) for k in repository.managers.keys() ]
    manager = forms.ChoiceField(choices=manager_choices)

class CredentialForm(forms.ModelForm):
    class Meta:
        model = Credential

    repository = RepositoryChoiceField(queryset=Repository.objects)

