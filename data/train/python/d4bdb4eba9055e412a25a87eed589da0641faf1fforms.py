from django import forms
import vidscraper

from djvidscraper.models import Video


class CreateVideoForm(forms.ModelForm):
    def save(self, commit=True, request=None):
        kwargs = {
            'video': vidscraper.auto_scrape(self.cleaned_data['original_url']),
            'commit': False,
        }

        if request and request.user.is_authenticated():
            kwargs['owner'] = request.user

        instance = Video.from_vidscraper_video(**kwargs)

        def save_m2m():
            instance.save_m2m()

        if commit:
            instance.save()
            save_m2m()
        else:
            self.save_m2m = save_m2m
        return instance


class CreateFeedForm(forms.ModelForm):
    def save(self, commit=True, request=None):
        if request and request.user.is_authenticated():
            self.instance.owner = request.user

        instance = super(CreateFeedForm, self).save(commit)

        if commit:
            instance.start_import()
        else:
            old_save_m2m = self.save_m2m

            def save_m2m():
                old_save_m2m()
                instance.start_import()
            self.save_m2m = save_m2m
        return instance
