__author__ = 'thomas'
from django.conf.urls import patterns, url

from .views import ImageDescriptionLabellingView, SaveLabelsView, GenderTrainingLabellingView, SaveLabelsGenderTrainingView


urlpatterns = patterns('',
	url(r'^image-description-labelling/', ImageDescriptionLabellingView.as_view(), name='image_description_labelling'),
	url(r'^gender-training-labelling/', GenderTrainingLabellingView.as_view(), name='gender_training_labelling'),
	url(r'^save-labels/', SaveLabelsView.as_view(), name='save_labels'),
	url(r'^save-gender-training-labels', SaveLabelsGenderTrainingView.as_view(), name='save_gender_training_labels')
)