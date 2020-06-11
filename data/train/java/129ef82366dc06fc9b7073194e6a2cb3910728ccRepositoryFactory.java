package isw2.rrmasg.services;

import isw2.rrmasg.domain.playlist.IPlaylistRepository;
import isw2.rrmasg.domain.song.ISongRepository;
import isw2.rrmasg.domain.user.IUserRepository;
import isw2.rrmasg.persistence.mysql.PlaylistRepositoryMySQL;
import isw2.rrmasg.persistence.mysql.SongRepositoryMySQL;
import isw2.rrmasg.persistence.mysql.UserRepositoryMySQL;

public class RepositoryFactory {
	private static IUserRepository userRepository;
	private static IPlaylistRepository playlistRepository;
	private static ISongRepository songRepository;

	public static IUserRepository getUserRepository() {
		if (userRepository == null) {
			userRepository = new UserRepositoryMySQL();
		}
		return userRepository;
	}

	public static IPlaylistRepository getPlaylistRepository() {
		if (playlistRepository == null) {
			playlistRepository = new PlaylistRepositoryMySQL();
		}
		return playlistRepository;
	}

	public static ISongRepository getSongRepository() {
		if (songRepository == null) {
			songRepository = new SongRepositoryMySQL();
		}
		return songRepository;
	}

	public static void resetRepositories() {
		userRepository = new UserRepositoryMySQL();
		playlistRepository = new PlaylistRepositoryMySQL();
		songRepository = new SongRepositoryMySQL();
	}
}
