import unittest
from erikash.social.SessionFactory import SessionFactory
from erikash.social.SqlTraderRepository import SqlTraderRepository
from erikash.social.domain.Trader import Trader

__author__ = 'erik'


class TraderRepositoryTests(unittest.TestCase):
    def test_can_persist_trader_with_open_positions(self):
        session_factory = SessionFactory()
        trader_repository = SqlTraderRepository(session_factory.create_session())
        trader = Trader()
        trader.open_position("EURUSD", 10000)
        trader_repository.append(trader)

        trader_repository.commit()

        trader_repository = SqlTraderRepository(session_factory.create_session())
        traders = trader_repository.get_all_traders()
        assert len(traders) > 0

        position = trader.open_positions[0]
        assert position.instrument == "EURUSD"
        assert position.amount == 10000

if __name__ == '__main__':
    unittest.main()