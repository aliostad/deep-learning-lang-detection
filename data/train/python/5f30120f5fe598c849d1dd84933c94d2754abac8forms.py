from __future__ import unicode_literals, print_function, generators, division
from django import forms
from django.db import transaction

__author__ = 'pahaz'


class TaggedModelForm(forms.ModelForm):
    tags = forms.CharField(max_length=200, required=False)

    def save(self, commit=True):
        if commit:
            with transaction.atomic():
                instance = super(TaggedModelForm, self).save(True)
                self.instance.tags = self.cleaned_data['tags']
        else:
            instance = super(TaggedModelForm, self).save(False)
            # We're not committing. Add a method to the form to allow deferred
            # saving of m2m data.
            super_save_m2m = self.save_m2m

            def save_m2m():
                super_save_m2m()
                self.instance.tags = self.cleaned_data['tags']

            self.save_m2m = save_m2m
        return instance
