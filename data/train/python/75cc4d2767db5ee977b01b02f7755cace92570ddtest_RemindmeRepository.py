'''
Testing RemindmeRepository model.

Objectives:
 - ensure a consistent interface is maintained
'''

import unittest
from remindme.Remindme import Remindme
from remindme.RemindmeRepository import RemindmeRepository


class Test_RemindmeRepository_Model(unittest.TestCase):
    '''Tests against the RemindmeRepository model
    (remindme.models.RemindmeRepository).'''

    def setUp(self):
        self.db_file = "./test/_test.RemindmeRepository.db"
        self.repository = RemindmeRepository(self.db_file)
        self.data = [
            { "title": "my title is awesome", "content": "and so is my content" },
            { "title": "boring but real title", "content": "get some content for me" },
            { "title": "pizza lover", "content": "some good pizza for me" }
        ]
        for d in self.data:
            self.repository.create_remindme(d["title"], d["content"])

    def test_constructor_restores_remindmes(self):
        num_remindmes = self.repository.count()
        same_repo = RemindmeRepository(self.db_file)
        num_restored_remindmes = same_repo.count()
        self.assertEqual(num_remindmes, num_restored_remindmes,
            '''RemindmeRepository#__init__ fails to restores remindmes''')

    def test_insert_remindme(self):
        title = "gotcha boy"
        content = "pink stars are awesome"
        remindme = Remindme(title, content, self.repository)
        status = self.repository.insert_remindme(remindme)
        self.assertTrue(status,
            '''RemindmeRepository#insert_remindme(remindme) failed to insert
            remindme''')
        found_remindme = self.repository.find_by_title(title)
        self.assertEqual(content, found_remindme.get_content(),
            '''RemindmeRepository#insert_remindme(remindme) failed to insert
            remindme''')

    def test_insert_remindmes_with_same_title(self):
        title = "same old title"
        remindme_1 = Remindme(title, "some content", self.repository)
        remindme_2 = Remindme(title, "other content", self.repository)
        status = self.repository.insert_remindme(remindme_1)
        self.assertTrue(status,
            '''Unexpected error with RemindmeRepository#insert_remindme''')
        status = self.repository.insert_remindme(remindme_2)
        self.assertFalse(status,
            '''RemindmeRepository#insert_remindme fails to return False when
            a remindme fails to be inserted''')

    def test_create_remindme(self):
        title = "some good title, boo"
        content = "got some content for you!"
        remindme = self.repository.create_remindme(title, content)
        self.assertTrue(isinstance(remindme, Remindme),
            '''RemindmeRepository#create_remindme does NOT
            return an instance of Remindme''')

    def test_create_remindmes_with_same_title(self):
        title = "some random content for everyone"
        content = "got some content for you!"
        remindme = self.repository.create_remindme(title, content)
        self.assertTrue(isinstance(remindme, Remindme),
            '''Unexpected error with RemindmeRepository#create_remindme''')
        remindme = self.repository.create_remindme(title, "soem other content")
        self.assertFalse(remindme,
            '''RemindmeRepository#create_remindme fails to return False when a
            remindme with same title is being created''')

    def test_remove_remindme(self):
        remindme_to_remove = self.repository.get_remindmes()[0]
        status = self.repository.remove_remindme(remindme_to_remove)
        self.assertTrue(status,
            '''RemindmeRepository#remove_remindme fails to return True when
            removing a remindme''')
        remindmes = self.repository.get_remindmes()
        found_remindme = (len([r for r in remindmes
            if r.get_title() == remindme_to_remove.get_title()]) == 0)
        self.assertTrue(found_remindme,
            '''RemindmeRepository#remove_remindme fails to remove remindme''')
        status = self.repository.remove_remindme(remindme_to_remove)
        self.assertFalse(status,
            '''RemindmeRepository#remove_remindme fails to return False when
            removing an already removed remindme''')

    def test_remove_remindmes(self):
        remindmes = self.repository.get_remindmes()
        status = self.repository.remove_remindmes()
        num_remindmes = self.repository.count()
        self.assertEqual(0, num_remindmes,
            '''RemindmeRepository#remove_remindmes fails to remove all
            remindmes''')
        self.assertTrue(status,
            '''RemindmeRepository#remove_remindmes fails to return True
            when removing remindes''')
        for r in remindmes:
            self.repository.insert_remindme(r)

    def test_find(self):
        title = "SoME CoMlex! Title tHaT MuST be UniqUE"
        remindme = Remindme(title, "some damn content", self.repository)
        self.repository.insert_remindme(remindme)
        found_remindmes = self.repository.find(lambda r: r.get_title() == title)
        self.assertEqual(1, len(found_remindmes),
            '''RemindmeRepository#find fails to get remindme qualifying a lambda''')
        self.assertEqual(remindme, found_remindmes[0],
            '''RemindmeRepository#find fails to get the remindme''')
