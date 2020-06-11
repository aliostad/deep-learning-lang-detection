__author__ = 'Hossein Zolfi <hossein.zolfi@gmail.com>'

from transaction_command import TransactionCommand
from lib import TransactionRepository

class WithdrawCommand(TransactionCommand):
    def __init__(self, account, amount):
        self.__account = account
        self.__amount = amount

    def apply_to(self, repository):
        """
        :type repository: TransactionRepository
        """
        repository.add_amount(self.__account, -self.__amount)

    @property
    def amount(self):
        return self.__amount

    @property
    def order(self):
        return 1
