name:chunk/1
def:chunk(Continuation) -> chunk_ret()
types:
      Continuation = continuation()

name:chunk/2
def:chunk(Continuation, N) -> chunk_ret()
types:
      Continuation = continuation(),
      N = infinity | pos_integer()

name:close/1
def:close(Continuation) -> 'ok' | {'error', Reason}
types:
      Continuation = continuation(),
      Reason = file:posix()

name:open/1
def:open(Filename) -> open_ret()
types:
      Filename = string() | atom()

name:open/2
def:open(Filename, N) -> open_ret()
types:
      Filename = string() | atom(),
      N = integer()

