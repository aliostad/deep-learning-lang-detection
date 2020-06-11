# -*- coding: utf-8 -*-

from getopt import GetoptError

from couchapp import dispatch
from couchapp.commands import globalopts
from couchapp.errors import AppError, CommandLineError
from nose.tools import raises
from mock import Mock, patch


def test_parseopts_short_flag():
    opts = {}
    args = dispatch.parseopts(['-v', 'generate', 'app', 'test-app'], globalopts, opts)
    assert args == ['generate', 'app', 'test-app']
    assert opts['debug'] is None
    assert opts['help'] is None
    assert opts['version'] is None
    assert opts['verbose'] == True
    assert opts['quiet'] is None


def test_parseopts_long_flag():
    opts = {}
    args = dispatch.parseopts(['--version'], globalopts, opts)
    assert args == []
    assert opts['debug'] is None
    assert opts['help'] is None
    assert opts['version'] == True
    assert opts['verbose'] is None
    assert opts['quiet'] is None


def test_parseopts_invalid_flag():
    @raises(GetoptError)
    def short():
        dispatch.parseopts(['-X'], globalopts, {})

    @raises(GetoptError)
    def long():
        dispatch.parseopts(['--unkown'], globalopts, {})

    short()
    long()


def test_parseopts_list_option():
    listopts = [('l', 'list', [], 'Test for list option')]
    opts = {}
    dispatch.parseopts(['-l', 'foo', '-l', 'bar'], listopts, opts)
    assert opts['list'] == ['foo', 'bar']


def test_parseopts_int_option():
    intopts = [('i', 'int', 100, 'Test for int option')]
    opts = {}
    dispatch.parseopts(['-i', '200'], intopts, opts)
    assert opts['int'] == 200


def test_parseopts_str_option():
    stropts = [('s', 'str', '', 'Test for int option')]
    opts = {}
    dispatch.parseopts(['-s', 'test'], stropts, opts)
    assert opts['str'] == 'test'


def test__parse_invalid_flag():
    @raises(CommandLineError)
    def short():
        dispatch._parse(['-X'])

    @raises(CommandLineError)
    def app_arg():
        dispatch._parse(['init', '-X'])

    @raises(CommandLineError)
    def long():
        dispatch._parse(['--unkown'])

    short()
    app_arg()
    long()


def test__parse_help():
    cmd, options, cmdoptions, args = dispatch._parse(['help'])
    assert cmd == 'help'

    cmd, options, cmdoptions, args = dispatch._parse([])
    assert cmd == 'help'

    cmd, options, cmdoptions, args = dispatch._parse(['-h'])
    assert cmd == 'help'
    assert options['help'] == True


def test__parse_subcmd_options():
    cmd, options, cmdoptions, args = dispatch._parse(['push', '-b', 'http://localhost'])
    assert cmd == 'push'
    assert cmdoptions['browse'] == True


@patch('couchapp.dispatch.set_logging_level')
def test__dispatch_debug(set_logging_level):
    assert dispatch._dispatch(['-d']) == 0
    set_logging_level.assert_called_with(1)


def test__dispatch_help():
    assert dispatch._dispatch(['-h']) == 0


@patch('couchapp.dispatch.set_logging_level')
def test__dispatch_verbose(set_logging_level):
    assert dispatch._dispatch(['-v']) == 0
    set_logging_level.assert_called_with(1)


def test__dispatch_version():
    assert dispatch._dispatch(['--version']) == 0


@patch('couchapp.dispatch.set_logging_level')
def test__dispatch_quiet(set_logging_level):
    assert dispatch._dispatch(['-q']) == 0
    set_logging_level.assert_called_with(0)


@raises(CommandLineError)
def test__dispatch_unknown_command():
    dispatch._dispatch(['unknown_command'])


@patch('couchapp.dispatch.commands')
@patch('couchapp.dispatch.Config')
def test__dispatch_inapp(conf, commands):
    conf = conf()
    conf.app_dir = '/mock_dir'
    mock_func = Mock(return_value=10)
    commands.table = {'mock': (mock_func, [], 'just for testing')}
    commands.incouchapp = ['mock']
    commands.globalopts = globalopts

    assert dispatch._dispatch(['mock']) == 10
    mock_func.assert_called_with(conf, conf.app_dir)


@patch('couchapp.dispatch.commands')
@patch('couchapp.dispatch.Config')
def test__dispatch_update_commands(conf, commands):
    conf = conf()
    mock_func = Mock(return_value=10)
    mock_mod = Mock()
    mock_mod.cmdtable = {'mock': (mock_func, [], 'just for testing')}
    conf.extensions = [mock_mod]
    commands.table = {}
    commands.globalopts = globalopts

    assert dispatch._dispatch(['mock']) == 10
    assert commands.table == mock_mod.cmdtable
    assert mock_func.called


@patch('couchapp.dispatch.logger')
@patch('couchapp.dispatch._dispatch')
def test_dispatch_AppError(_dispatch, logger):
    args = ['strange']
    _dispatch.side_effect = AppError('some error')

    assert dispatch.dispatch(args) == -1
    _dispatch.assert_called_with(args)


@patch('couchapp.dispatch.logger')
@patch('couchapp.dispatch._dispatch')
def test_dispatch_CLIError(_dispatch, logger):
    '''
    Test case for CommandLineError
    '''
    args = ['strange']
    _dispatch.side_effect = CommandLineError('some error')

    assert dispatch.dispatch(args) == -1
    _dispatch.assert_called_with(args)


@patch('couchapp.dispatch.logger')
@patch('couchapp.dispatch._dispatch')
def test_dispatch_KeyboardInterrupt(_dispatch, logger):
    '''
    Test case for KeyboardInterrupt
    '''
    args = ['strange']
    _dispatch.side_effect = KeyboardInterrupt()

    assert dispatch.dispatch(args) == -1
    _dispatch.assert_called_with(args)


@patch('couchapp.dispatch.logger')
@patch('couchapp.dispatch._dispatch')
def test_dispatch_other_error(_dispatch, logger):
    '''
    Test case for general Exception
    '''
    args = ['strange']
    _dispatch.side_effect = Exception()

    assert dispatch.dispatch(args) == -1
    _dispatch.assert_called_with(args)
