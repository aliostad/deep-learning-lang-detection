from django.dispatch import receiver

from src.domain.event.commands import CreateEvent, AssociateArtistWithEvent, RefreshEventPlaylist, \
  CreatePlaylistForEvent
from src.domain.event.entities import Event
from src.libs.common_domain import aggregate_repository


@receiver(CreateEvent.command_signal)
def create_event(_aggregate_repository=None, **kwargs):
  if not _aggregate_repository: _aggregate_repository = aggregate_repository
  command = kwargs['command']

  request = Event.from_attrs(**command.data)
  _aggregate_repository.save(request, -1)


@receiver(AssociateArtistWithEvent.command_signal)
def associate_artist_with_event(_aggregate_repository=None, **kwargs):
  if not _aggregate_repository: _aggregate_repository = aggregate_repository

  command = kwargs['command']
  ag = _aggregate_repository.get(Event, kwargs['aggregate_id'])

  artist_id = command.data['artist_id']

  if artist_id not in ag._artist_ids:
    version = ag.version

    ag.associate_artist(artist_id)

    _aggregate_repository.save(ag, version)


@receiver(RefreshEventPlaylist.command_signal)
def refersh_event_playlist(_aggregate_repository=None, **kwargs):
  if not _aggregate_repository: _aggregate_repository = aggregate_repository

  ag = _aggregate_repository.get(Event, kwargs['aggregate_id'])

  version = ag.version

  ag.refresh_playlist()

  _aggregate_repository.save(ag, version)


@receiver(CreatePlaylistForEvent.command_signal)
def create_playlist_for_event(_aggregate_repository=None, **kwargs):
  if not _aggregate_repository: _aggregate_repository = aggregate_repository

  ag = _aggregate_repository.get(Event, kwargs['aggregate_id'])

  version = ag.version

  ag.create_playlist()

  _aggregate_repository.save(ag, version)
