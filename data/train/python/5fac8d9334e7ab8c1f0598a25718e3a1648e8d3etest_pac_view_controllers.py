import unittest
from pac import dispatcher
from pac.view_controllers import MainViewController
from pac.view_models import MainViewModel

class TestViewControllerHandler(unittest.TestCase):
    def test_get_matched_view_model(self):
        view_controller = MainViewController()

        self.assertTrue(isinstance(view_controller.view_model, MainViewModel))

    def test_view_model_has_html_property(self):
        view_controller = MainViewController()

        self.assertEqual(view_controller.view_model.html_view, '/edit/main_view.html')

    def test_get_unknown_view_controller(self):
        work_as_intended = False
        try:
            dispatcher.get_view_controller('a_b_c_d_e_f')
        except NotImplementedError:
            work_as_intended = True

        self.assertTrue(work_as_intended)

  