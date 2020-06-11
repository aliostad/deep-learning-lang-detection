import unittest
import football_data_api

class MyTestCase(unittest.TestCase):
    def test_something(self):
        api=football_data_api.FootballDataAPI()
        api.competitions("")
        api.allTeam('426')
        api.leagueTable('426','1')
        api.fixtureForCertainCompetition("426","p6","8")
        api.fixtureForSetCompetition('p6','')
        api.fixtureForOneTeam('66','2016','p6','home')
        api.fixtureForOne("149461",'')
        api.team('66')
        api.players('66')

if __name__ == '__main__':
    unittest.main()
