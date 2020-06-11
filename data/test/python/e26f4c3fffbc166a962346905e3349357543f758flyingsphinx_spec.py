import sys
import os
import fudge

sys.path.insert(0, os.path.abspath('..'))
import flyingsphinx

@fudge.patch('flyingsphinx.API')
def test_info_api_call(api_class):
  api = fudge.Fake('API')
  api_class.is_callable().calls(lambda: api)

  api.expects('get').with_args('/')

  flyingsphinx.info()

@fudge.patch('flyingsphinx.API')
def test_info_result(api_class):
  api = fudge.Fake('API')
  api_class.is_callable().calls(lambda: api)
  api.provides('get').with_args('/').returns({'bar': 'baz'})

  assert flyingsphinx.info() == {'bar': 'baz'}
