
class Application: 
	"""
		Class that handles application logic.
	"""
	def run(self):
		"""
			Handles applcation run.
		"""
		try: 
			self.media.run()
		except RuntimeError:
			self.exit()


	def __init__ (self, media, user_repository, data_repository, bill_repository):
		"""
			Handles application logic init. Binds itself to media. Takes parameter for media class instance.
			Sets menu tree data repository. Takes parameter data repository.
			Sets user data repository. Takes parameter user repository.
			Sets bill data repository. Takes parameter bill repository.
		"""
		self.media = media
		self.media.bind_application(self)
		self.user_repository = user_repository
		self.data_repository = data_repository
		self.bill_repository = bill_repository

	def authenticate_user(self, user,password):
		"""
			Authenticate user.
		"""

		details = self.user_repository.authenticate_user(user, password)

		if details == False:
			return False
		else:
			self.user_id = details
			return True

	def logout_user(self): 
		self.user_id = None

	def get_data(self):
		"""
			Gets menu tree data.
		"""
		return self.data_repository.get_data()

	def get_rent_items(self):
		"""
			Gets rent items data
		"""
		
		return self.data_repository.get_rent_items(self.get_user_id())

	def get_bill(self):
		"""
			Get bill data
		"""
		return self.bill_repository.get_data()

	def add_item(self, data): 
		"""
			Add item to bill. Takes parameter item data.
		"""
		self.bill_repository.add(data)

	def remove_item(self,index): 
		"""
			Removes a given index item from bill. Takes parameter index.
		"""
		self.bill_repository.remove(index)

	def clear_items(self):
		"""
			Clear items from bill.
		"""
		self.bill_repository.clear()
	
	def checkout(self):
		"""
			Marks the data as rent to user.
		"""
		user_id= self.get_user_id()
		data = self.bill_repository.get_data()

		for item in data:
			self.data_repository.borrow(user_id, item["id"])

		self.bill_repository.clear()

	def return_item(self, index): 
		"""
			Marks the item as returned by user
		"""
		self.data_repository.return_item(self.get_user_id(), index)

	def exit(self):
		"""
			Handles graceful exit. 
		"""
		self.user_repository.exit()
		self.bill_repository.exit()
		self.data_repository.exit()
		self.media.exit()
