from domain.Word import *
from controller.ControllerError import *
from random import *
from domain.ValidationError import *
from repository.RepositoryError import *

class WordController:
	def __init__(self, repository):
		self.__repository = repository

	def read_data(self):
		try:
			self.__repository.read_data()
		except RepositoryError as e:
			self.__repository.write_data()
			
			raise ControllerError(e)
		

	def get_sorted_list(self):
		return sorted(self.__repository.get_list(), key = lambda word: word.get_value())

	def add_word(self, word_value, word_points):
		try:
			word = Word(word_value, int(word_points))

			self.__repository.add_word(word)
		except ValidationError as e:
			raise ControllerError(e)
		except RepositoryError as e:
			raise ControllerError(e)
		except ValueError:
			raise ControllerError('Give me and integer as number of points')

	def get_current_score(self):
		return self.__repository.get_score()

	def get_high_score(self):
		return self.__repository.get_highest_score()

	def get_word(self):
		if len(self.__repository.get_list()) == 0:
			raise ControllerError('No words available')

		index = randint(0, len(self.__repository.get_list()) - 1)

		return self.__repository.get_list()[index]

	def modify_points(self, real_word, given_word):
		if real_word == given_word:
			self.__repository.add_points(real_word.get_points())
		else:
			self.__repository.add_points(-1)

	def can_continue(self):
		return self.__repository.get_score() > 0

	def new_high_score(self):
		if self.__repository.get_score() > self.__repository.get_highest_score():
			self.__repository.set_high_score(self.__repository.get_score())

			return True

		return False