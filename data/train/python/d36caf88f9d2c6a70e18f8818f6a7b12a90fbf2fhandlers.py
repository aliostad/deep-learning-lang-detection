import git
import sys
import os.path

## helper functions (non-handler)

def script_dir():
  path = os.path.abspath(os.path.realpath(sys.argv[0]))
  return os.path.split(path)[0]

## update handlers

def update_git_pull(_dispatch, repo_path, remote_name = 'origin'):
  repo = git.Repo(repo_path)
  repo.remote(remote_name).pull()

## test functions

def dump_dispatch(_dispatch):
  for k in _dispatch.registry:
    print(k, _dispatch.registry[k])

def echo(_dispatch, *args):
  print(' '.join([str(x) for x in args]))

## basic utilities

def ident(_dispatch, arg):
  return arg

## file system handlers

def fs_scr_root(_dispatch):
  return script_dir()

def fs_join(_dispatch, *args):
  return os.path.normpath(os.path.join(*args))


handler_registry = (
  ('update/pull', update_git_pull),
  ('test/dump/dispatch', dump_dispatch),
  ('test/echo', echo),
  ('ident', ident),
  ('fs/scr_root', fs_scr_root),
  ('fs/join', fs_join)
)

