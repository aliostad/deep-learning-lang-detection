from django import forms
from apps.wisys.models import SettingsLogo
from django.contrib.sites.models import Site

class SystemLogoForm(forms.ModelForm):
    class Meta:
        model = SettingsLogo

    def save(self, commit=True):
        obj = super(SystemLogoForm, self).save(commit=False)
        obj.id = 1
        obj.save()



class SitenameForm(forms.ModelForm):
    class Meta:
        model = Site


        def save(self, commit=True):
            obj = super(SitenameForm, self).save(commit=False)
            obj.id = 1
            obj.save()