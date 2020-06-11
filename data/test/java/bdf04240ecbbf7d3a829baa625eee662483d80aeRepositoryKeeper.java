package com.thoughtriott.metaplay.data.wrappers;

import com.thoughtriott.metaplay.data.repositories.jpa.*;
import com.thoughtriott.metaplay.utilities.DateFormatter;
import org.springframework.beans.factory.annotation.Autowired;

//import com.thoughtriott.metaplay.data.repositories.mongo.AudioFileRepository;

public abstract class RepositoryKeeper {

	@Autowired
	protected AccountRepository accountRepository;
	
	@Autowired
	protected AlbumRepository albumRepository;
	
	@Autowired
	protected ArtistRepository artistRepository;
	
	@Autowired
	protected GenreRepository genreRepository;
	
	@Autowired
	protected LocationRepository locationRepository;
	
	@Autowired
	protected MemberRepository memberRepository;
	
	@Autowired
	protected PlaylistRepository playlistRepository;
	
	@Autowired
	protected PlaylistTrackRepository playlistTrackRepository;
	
	@Autowired
	protected RecordLabelRepository recordLabelRepository;
	
	@Autowired
	protected RoleRepository roleRepository;
	
	@Autowired
	protected RequestRepository requestRepository;
	
	@Autowired
	protected TrackRepository trackRepository;
	
	@Autowired
	protected DateFormatter dateFormatter;

//	@PersistenceContext
//	protected EntityManager em;
	
}
