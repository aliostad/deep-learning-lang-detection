from mock import MagicMock
import unittest
from src.job.job import Job
from src.webserver.controllers.job import JobController

def mock_job_controller(job_controller):
    job_controller.redirect = MagicMock()
    job_controller.url_for = MagicMock()
    job_controller.job_repository = MagicMock()
    job_controller.prompt_for_password = MagicMock()
    job_controller.abort = MagicMock()
    job_controller.user_is_authenticated = MagicMock()
    job_controller.render = MagicMock()
    job_controller.get_job_from_request = MagicMock()
    return job_controller

class TestJobCreation(unittest.TestCase):

    def test_job_with_a_non_active_status_returns_404(self):
        controller = mock_job_controller(JobController(database = None))
        controller.job_repository.find.return_value = Job(id = 1, status = 'pending')
        controller.view(id = 1)
        assert controller.abort.call_args[0][0] == 404

    def test_job_with_an_active_status_does_not_return_404(self):
        controller = mock_job_controller(JobController(database = None))
        controller.job_repository.find.return_value = Job(id = 2, status = 'active')
        controller.view(id = 2)
        assert controller.abort.called == False

    def test_job_with_a_non_active_status_can_not_be_previewed_if_incorrect_token_supplied(self):
        controller = mock_job_controller(JobController(database = None))
        controller.job_repository.find.return_value = Job(id = 1, status = 'pending', edit_url = 'banana')
        controller.preview(id = 1, token = 'apple')
        assert controller.abort.called == True

    def test_job_with_a_non_active_status_can_be_previewed_if_correct_token_supplied(self):
        controller = mock_job_controller(JobController(database = None))
        controller.job_repository.find.return_value = Job(id = 1, status = 'pending', edit_url = 's3cR3t')
        controller.preview(id = 1, token = 's3cR3t')
        assert controller.abort.called == False

    def test_job_is_saved_when_user_is_authenticated(self):
        controller = mock_job_controller(JobController(database = None))
        controller.user_is_authenticated = MagicMock(return_value = True)
        controller.create()
        assert controller.job_repository.save.called == True

    def test_job_is_not_saved_when_user_is_not_authenticated(self):
        controller = mock_job_controller(JobController(database = None))
        controller.user_is_authenticated = MagicMock(return_value = False)
        controller.create()
        assert controller.job_repository.save.called == False
