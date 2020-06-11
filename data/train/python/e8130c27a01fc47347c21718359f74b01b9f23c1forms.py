from django.forms import ModelForm
from .models import Upload


class UploadForm(ModelForm):
    class Meta:
        model = Upload

    # Overriding save allows us to add the user from the request
    def save(self, user, commit=True):
        # get the instance so we can add the user to it.
        instance = super(UploadForm, self).save(commit=False)
        instance.user = user

        # Do we need to save all changes now?
        if commit:
            instance.save()
            self.save_m2m()

        return instance
