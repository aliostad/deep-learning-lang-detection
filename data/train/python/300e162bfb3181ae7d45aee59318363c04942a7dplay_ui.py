from controller.ControllerError import *

class PlayUi:
	def __init__(self, controller):
		self.__controller = controller

	def print_score(self):
		print('current score: {}\nhighest score: {}'.format(self.__controller.get_current_score(), self.__controller.get_high_score()))

	def run_play(self):
		print('\nYou are in play mode')
		try:
			while True:
				self.print_score()

				word = self.__controller.get_word()

				print('\nscrambled word: {}'.format(word.get_scrambled()))
				result = input('\ngive me the correct word: ')

				self.__controller.modify_points(word, result)

				if not self.__controller.can_continue():
					break

				if self.__controller.new_high_score():
					response = input('\nType <<exit>> to exit play mode: ')

					if response == 'exit':
						break
		except Exception as e:
			print(e)