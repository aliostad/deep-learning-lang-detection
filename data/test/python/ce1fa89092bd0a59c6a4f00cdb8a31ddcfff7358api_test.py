import unittest

from mockito import *

from meme import Meme

class MemeApiTest(unittest.TestCase):
    
    def test_should_get_meme_by_name(self):
        meme_repository_mock = Mock()
        when(meme_repository_mock).get('some_name').thenReturn('ok')
        
        Meme.meme_repository = meme_repository_mock
        
        assert Meme.get(name='some_name') == 'ok'
    
    def test_should_search_for_memes(self):
        meme_repository_mock = Mock()
        when(meme_repository_mock).search('a query', 10).thenReturn(['search_result1'])
        when(meme_repository_mock).search('a query', 40).thenReturn(['search_result2'])

        Meme.meme_repository = meme_repository_mock

        assert Meme.search('a query') == ['search_result1']
        assert Meme.search('a query', count=40) == ['search_result2']

class MemePostsApiTest(unittest.TestCase):
    
    def test_should_get_one_post(self):
        post_repository_mock = Mock()
        when(post_repository_mock).get('123', '456').thenReturn('post')
        
        Meme.Posts.post_repository = post_repository_mock
        assert Meme.Posts.get(owner_guid='123', pubid='456') == 'post'

    def test_should_get_popular_posts(self):
        post_repository_mock = Mock()
        when(post_repository_mock).popular('en', 10).thenReturn(['popular_posts1'])
        when(post_repository_mock).popular('pt', 10).thenReturn(['popular_posts2'])
        when(post_repository_mock).popular('en', 33).thenReturn(['popular_posts3'])
        when(post_repository_mock).popular('pt', 33).thenReturn(['popular_posts4'])
        
        Meme.Posts.post_repository = post_repository_mock
        
        assert Meme.Posts.popular() == ['popular_posts1']
        assert Meme.Posts.popular(locale='pt') == ['popular_posts2']
        assert Meme.Posts.popular(count=33) == ['popular_posts3']
        assert Meme.Posts.popular(locale='pt', count=33) == ['popular_posts4']
        
    def test_should_search_for_posts(self):
        post_repository_mock = Mock()
        when(post_repository_mock).search('a query', 10).thenReturn(['search_result1'])
        when(post_repository_mock).search('a query', 40).thenReturn(['search_result2'])

        Meme.Posts.post_repository = post_repository_mock

        assert Meme.Posts.search('a query') == ['search_result1']
        assert Meme.Posts.search('a query', count=40) == ['search_result2']
