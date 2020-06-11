import unittest
try:
    from urls import urlpatterns
    from views import helio_get_view_state, helio_get_controller_data, helio_dispatch_notification

    class DjangoURLTests(unittest.TestCase):
        def test_controller_data_url(self):
            """URL controller/controller.path should resolve to the helio_get_controller_data method."""
            resolution = urlpatterns[0].resolve('controller/the.controller.path')
            self.assertEqual(resolution.func, helio_get_controller_data)
            self.assertEqual(resolution.kwargs, {'controller_path': 'the.controller.path'})

        def test_notification_url(self):
            """URL notification/controller/name should resolve to the helio_dispatch_notification method."""
            resolution = urlpatterns[1].resolve('notification/a.controller.path/the-notification')
            self.assertEqual(resolution.func, helio_dispatch_notification)
            self.assertEqual(resolution.kwargs, {'controller_path': 'a.controller.path',
                                                 'notification_name': 'the-notification'})

        def test_get_view_state_url(self):
            """URL get-view-state should resolve to the helio_get_view_state method."""
            resolution = urlpatterns[2].resolve('get-view-state/')
            self.assertEqual(resolution.func, helio_get_view_state)

except ImportError:
    raise RuntimeWarning("Not testing Django URLs")