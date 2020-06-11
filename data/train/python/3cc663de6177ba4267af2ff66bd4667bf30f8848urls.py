from django.conf.urls import url, include
from wordtrainer.trainer_site.views import AppView
from wordtrainer.vocabulary.api import WordListResource, WordPairResource
from wordtrainer.vocabulary.api import TrainingItemResource
from tastypie.api import Api

api = Api(api_name = "v1")
api.register(WordListResource())
api.register(WordPairResource())
api.register(TrainingItemResource())


word_list_resource = WordListResource()

urlpatterns = (
    url(r'^api/', include(api.urls)),
    url(r'^$', AppView.as_view(), name='wordtrainer-app'),
)
