import unittest
import src


class FrameControllerTests(unittest.TestCase):

	# test to see if initialization of new user has an empty photo array to start
	def test_init(self):

		# Test variables
		test_frame_controller = src.FrameController.FrameController()

		self.assertTrue(test_frame_controller.current_user_id is None)

		# add a user
		test_frame_controller.add_user(1)

		self.assertTrue(test_frame_controller.current_user_id == 1)
		self.assertTrue(test_frame_controller.current_user_access_type is None)

		# creates a user
		test_frame_controller.get_user_from_db()

		# created user has a photo_access_type
		self.assertTrue(test_frame_controller.current_user_access_type is not None)


	def test_run_frame(self):

		test_frame_controller = src.FrameController.FrameController()

		test_frame_controller.add_user(1)

		test_frame_controller.get_user_from_db()

		# start the frame
		#test_frame_controller.run_raspbian_frame()