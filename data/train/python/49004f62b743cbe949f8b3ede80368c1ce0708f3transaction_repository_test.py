from lib.path import extract_file_extension
from lib.transaction_repository import TransactionRepository

__author__ = 'Hossein Zolfi <hossein.zolfi@gmail.com>'

def test_add_amount():
    repository = TransactionRepository()
    repository.add_amount('2', '13.0')
    repository.add_amount('2', '17.0')
    repository.add_amount(7,    -19.0)
    repository.add_amount(7,    21.0)
    repository.add_amount(5,    23.0)
    repository.add_amount(29,   -31.0)

    assert repository.get_account_amount(2)    == 30
    assert repository.get_account_amount('2')  == 30

    assert repository.get_account_amount('7')  == 2

    assert repository.get_account_amount('29') == -31

def test_get_formatted_transactions_asc():
    repository = TransactionRepository()
    repository.add_amount('1234567890123456', 1)
    repository.add_amount('1234567890123457', 1)
    repository.add_amount('1234567890123458', 1)

    assert list(repository.get_formatted_transactions()) == [
        (1234567890123456, 1.0), (1234567890123457, 1.0), (1234567890123458, 1.0)
    ]

def test_get_formatted_transactions_desc():
    repository = TransactionRepository()
    repository.add_amount('1234567890123458', 1)
    repository.add_amount('1234567890123457', 1)
    repository.add_amount('1234567890123456', 1)

    assert list(repository.get_formatted_transactions()) == [
        (1234567890123456, 1.0), (1234567890123457, 1.0), (1234567890123458, 1.0)
    ]

def test_get_formatted_transactions_randomly():
    repository = TransactionRepository()
    repository.add_amount('2',  1)
    repository.add_amount('3',  1)
    repository.add_amount('5',  1)

    repository.add_amount('13',  1)
    repository.add_amount('11',  1)
    repository.add_amount('7',  1)

    repository.add_amount('31',  1)
    repository.add_amount('41',  1)
    repository.add_amount('43',  1)

    repository.add_amount('2',  1)
    repository.add_amount('3',  1)
    repository.add_amount('5',  1)

    assert list(repository.get_formatted_transactions()) == [
        (2, 2), (3, 2), (5, 2), (7, 1), (11, 1), (13, 1), (31, 1), (41, 1), (43, 1)
    ]
