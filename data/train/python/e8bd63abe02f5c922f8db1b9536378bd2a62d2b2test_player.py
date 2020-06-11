import mock as m
import players.datastore.player as pio

import players
import players.player as p


def mock_save_ok():
    mock = m.Mock()
    mock.save.return_value = True
    return mock

def mock_save_exception():
    mock = m.Mock()
    mock.save = m.Mock(side_effect=Exception('Boom!'))
    return mock

def interface_playerio():
    return m.Mock(spec=pio.Player)


def test_save_ok():
    mock = mock_save_ok()
    rc = _save(mock)
    assert (rc == True)

def test_save_exception():
    mock = mock_save_exception()
    rc = _save(mock)
    assert (rc == True)

def test_save_with_klass():
    with m.patch("players.datastore.player.Player") as MockPlayer:
        mock_player = MockPlayer.return_value
        mock_player.create.return_value = {}
        mock_player.all.return_value = {}
        mock_player.save.return_value = True

        rc = _save(mock_player)
        assert (rc == True)

def test_interface_playerio():
    rc = _save(interface_playerio())


def _save(mock):
    player = p.Player(mock)
    rc = player.save()
    return rc


def fetch():
    assert True
