from suggest import suggest
from hypothesis import given
from hypothesis.strategies import text, integers
import re
import string

def check(repository, s):
    # We expect the suggestions to be like
    # T - 1, T - 123, Ti - 1234, user1 - 123, etc.
    pat = re.compile('\S+ - \d+')
    return pat.match(s) and s not in repository
    
def test_suggest():
    # Test from known repository
    for _ in range(10000):
        with open('list_names') as f:
            repository = [name.rstrip('\n') for name in f]
            for name in repository:
                suggestions = suggest(repository, name)
                for s in suggestions:
                    assert check(repository, s)

# https://hypothesis.readthedocs.org/en/latest/index.html
hyp_repository = []
max_lengths = []
@given(name=text(alphabet=string.printable), max_length=integers(min_value=5, max_value=255))
def build_hypothesis_repository(name, max_length):
    global hyp_repository, max_lengths
    hyp_repository.append(name)
    max_lengths.append(max_length)

def test_suggest_hypothesis():
    build_hypothesis_repository()
    for name, max_length in zip(hyp_repository, max_lengths):
        suggestions = suggest(hyp_repository, name, max_length=max_length)
        for s in suggestions:
            assert check(hyp_repository, s)
