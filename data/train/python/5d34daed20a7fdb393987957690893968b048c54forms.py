import re

from django import forms
from django.forms import ModelForm
from django.utils.translation import ugettext_lazy as _

from django.contrib import auth
from django.contrib.auth.models import User

from account.conf import settings
from account.models import EmailAddress, Account

from .models import Profile, NYTBrokerInfo, Broker

class ProfileForm(ModelForm):
    class Meta:
        model = Profile
        exclude = ('user',)
    
class SettingsForm(ModelForm):
    class Meta:
        model = Account
        exclude = ('user',)

# we used to display the account_brokers page with this form
# deprecated
"""class BrokerForm(forms.Form):
    def __init__(self, *args, **kwargs):
        super(BrokerForm, self).__init__(*args, **kwargs)
        # auto-populate the form fields
        for broker in Broker.objects.all():
            self.fields[broker.short_name] = forms.BooleanField()"""

class AddNYTBrokerInfoForm(ModelForm):
    class Meta:
        model = NYTBrokerInfo
        exclude = ('generic_info', 'ftp_login', 'ftp_password')
            
class EditNYTBrokerInfoForm(ModelForm):
    class Meta:
        model = NYTBrokerInfo
        exclude = ('generic_info',)