from django.conf.urls import url, include
from rest_framework.routers import DefaultRouter

from .views import FriendAPI, LearningHistoryAPI, LearningProfileAPI, ActivityLogAPI, ScoreCardAPI, \
    LearningQueueAPI, PeopleAPI, TestResultsAPI, SuspiciousAPI, QuestionsAPI

router = DefaultRouter()
router.register(r'friends', FriendAPI)
router.register(r'people', PeopleAPI)
router.register(r'test/results', TestResultsAPI)
router.register(r'questions', QuestionsAPI)
router.register(r'suspicious', SuspiciousAPI)
router.register(r'scorecard', ScoreCardAPI)
router.register(r'learn/history', LearningHistoryAPI)
router.register(r'learn/profile', LearningProfileAPI)
router.register(r'learn/queue', LearningQueueAPI)
router.register(r'activity', ActivityLogAPI)

urlpatterns = [
    url(r'^', include(router.urls)),
]
