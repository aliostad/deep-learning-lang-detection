import unittest

import queries
import handlers
import commands
import repository


def get_faked_rangevote(_id='1', votes=None):
    if votes is None:
        votes = [{'opinions': {'a': 1, 'b': -1}, 'elector': 'G'}, {'opinions': {'a': -1, 'b': 2}, 'elector': 'V'}]
    return {'id': _id, 'votes': votes, 'randomized_choices': ['a', 'b'], 'question': 'Q?', 'choices': ['a', 'b']}


class HandlersTestCase(unittest.TestCase):
    def setUp(self):
        self.mock_repository = repository.MockRepository()

    def test_create_rangevote_handler_save_rangevote_created(self):
        create_rangevote_handler = handlers.CreateRangeVoteHandler(self.mock_repository)

        create_rangevote_handler.handle(commands.CreateRangeVoteCommand(1, 'Q?', ['a', 'b']))

        self.assertEqual(1, self.mock_repository.db[1].uuid)
        self.assertEqual('Q?', self.mock_repository.db[1].question)
        self.assertEqual(['a', 'b'], self.mock_repository.db[1].choices)

    def test_update_rangevote_handler_call_update_method(self):
        update_rangevote_handler = handlers.UpdateRangeVoteHandler(self.mock_repository)

        update_rangevote_handler.handle(
            commands.UpdateRangeVoteCommand(1, 'Q?', ['a', 'b'], votes=[{'elector': 'e', 'opinions': {'a': 0, 'b': 0}}]))

        self.assertEqual(1, self.mock_repository.db[1].uuid)
        self.assertEqual('Q?', self.mock_repository.db[1].question)
        self.assertEqual(['a', 'b'], self.mock_repository.db[1].choices)
        self.assertEqual('e', self.mock_repository.db[1].votes[0].elector)
        self.assertEqual({'a': 0, 'b': 0}, self.mock_repository.db[1].votes[0].opinions)

    def test_create_vote_handler_save_vote_created(self):
        self.mock_repository.db['1'] = get_faked_rangevote(votes=[])
        create_vote_handler = handlers.CreateVoteHandler(self.mock_repository)

        create_vote_handler.handle(commands.CreateVoteCommand('1', 'GV', {'a': 1, 'b': -2}))

        self.assertEqual('GV', self.mock_repository.db['1'].votes[0].elector)
        self.assertDictEqual({'a': 1, 'b': -2}, self.mock_repository.db['1'].votes[0].opinions)


class QueryHandlersTestCase(unittest.TestCase):
    def setUp(self):
        self.mock_repository = repository.MockRepository()

    def test_get_rangevote_handler(self):
        self.mock_repository.db['1'] = get_faked_rangevote()
        get_rangevote_handler = handlers.GetRangeVoteHandler(self.mock_repository)

        rangevote = get_rangevote_handler.handle(queries.GetRangeVoteQuery('1'))

        self.assertEqual(self.mock_repository.db['1']['id'], rangevote['id'])
        self.assertEqual(self.mock_repository.db['1']['question'], rangevote['question'])
        self.assertListEqual(self.mock_repository.db['1']['choices'], rangevote['choices'])

    def test_get_rangevote_results_handler(self):
        self.mock_repository.db['1'] = get_faked_rangevote()
        get_rangevote_results_handler = handlers.GetRangeVoteResultsHandler(self.mock_repository)

        results = get_rangevote_results_handler.handle(queries.GetRangeVoteResultsQuery('1'))
        expected_results = {
            'question': 'Q?',
            'answers': ['b'],
            'ranking': [{'choice': 'b', 'score': 1}, {'choice': 'a', 'score': 0}],
            'number_of_votes': 2
        }
        self.assertDictEqual(results, expected_results)

    def test_get_rangevotes_handler(self):
        self.mock_repository.db['1'] = get_faked_rangevote('1')
        self.mock_repository.db['2'] = get_faked_rangevote('2')
        get_rangevotes_handler = handlers.GetRangeVotesHandler(self.mock_repository)

        results = get_rangevotes_handler.handle(queries.GetRangeVotesQuery())

        self.assertEqual(2, len(results))
