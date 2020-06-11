from multipledispatch import dispatch
from models import Rock, Paper, Scissors

@dispatch(Rock, Rock)
def draw(x, y): return None

@dispatch(Rock, Paper)
def draw(x, y): return y

@dispatch(Rock, Scissors)
def draw(x, y): return x

@dispatch(Paper, Rock)
def draw(x, y): return x

@dispatch(Paper, Paper)
def draw(x, y): return None

@dispatch(Paper, Scissors)
def draw(x, y): return x

@dispatch(Scissors, Rock)
def draw(x, y): return y

@dispatch(Scissors, Paper)
def draw(x, y): return x

@dispatch(Scissors, Scissors)
def draw(x, y): return None

@dispatch(object, object)
def draw(x, y):
    if not isinstance(x, (Rock, Paper, Scissors)):
        raise TypeError("Unknown first thing")
    else:
        raise TypeError("Unknown second thing")