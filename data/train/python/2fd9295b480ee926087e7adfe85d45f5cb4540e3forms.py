from django import forms

from myapp.models import Comment


class CommentCreateForm(forms.ModelForm):

    class Meta:
        model = Comment
        fields = [
            'body',
        ]

    def save(self, commit=True):
        comment = super(CommentCreateForm, self).save(commit=False)
        if commit:
            comment.save()
        return comment

class CommentUpdateForm(forms.ModelForm):

    class Meta:
        model = Comment
        fields = [
            'body',
        ]

    def save(self, commit=True):
        comment = super(CommentCreateForm, self).save(commit=False)
        if commit:
            comment.save()
        return comment
