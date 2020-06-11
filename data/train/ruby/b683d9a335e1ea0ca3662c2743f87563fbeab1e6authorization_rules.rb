authorization do
	role :client do
		has_permission_on :dashboard, :to => :read		
		has_permission_on :audio_playlists, :to => [:read,  :export, :export_to_excel, 	:print]
		has_permission_on :album_playlists, :to => [:read, :export, :export_to_excel, :print]
		has_permission_on :users, :to => [:edit_own_password, :update_own_password]		
  end
	
	role :video_programmer do
	  has_permission_on :dashboard, :to => :manage
		
		has_permission_on :movies, :to => [:manage, :check_airline_rights, :check_screener_remarks, :check_movie_type, :update_date]
		has_permission_on :masters, :to => [:manage, :duplicate]
		has_permission_on :screeners, :to => [:manage, :duplicate]
		has_permission_on :videos, :to => :manage
		has_permission_on :movie_playlist_items, :to => :manage	
		has_permission_on :video_playlist_items, :to => :manage	
		has_permission_on :video_master_playlist_items, :to => :manage	
		has_permission_on :screener_playlist_items, :to => :manage	
			
		has_permission_on :movie_playlists, :to => [:read, :create, :update, :print, :add_movie, :add_movie_to_playlist, 
		            :sort, :export_to_excel, :add_multiple_movies, :duplicate]
		            
		has_permission_on :video_playlists, :to => [:read, :create, :update, :print, :add_video, :add_video_to_playlist, 
                :sort, :export_to_excel, :add_multiple_videos, :duplicate]

		has_permission_on :video_master_playlists, :to => [:read, :create, :update, :print, :add_master, :add_master_to_playlist, 
                :sort, :export_to_excel, :add_multiple_masters, :set_video_master_playlist_item_mastering, :duplicate]

		has_permission_on :screener_playlists, :to => [:manage,:print, :add_screener, :add_screener_to_playlist, 
                :sort, :export_to_excel, :add_multiple_screeners, :set_screener_playlist_item_mastering, :duplicate]
		            
		has_permission_on :users, :to => [:edit_own_password, :update_own_password]
	  
  end
	
  role :programmer do
		has_permission_on :dashboard, :to => :manage
    has_permission_on :vos, :to => :manage  
    has_permission_on :settings, :to => :manage
    has_permission_on :airlines, :to => :manage
		has_permission_on :albums, :to => [:manage, :amazon_cd_covers, :show_genre, :show_synopsis, :show_tracks, :show_playlists, :show_tracks_translation, :sort, :restore, :add_track, :set_album_synopsis]
		has_permission_on :tracks, :to => [:manage, :show_lyrics_form, :show_playlists, :show_genre, :restore]
		has_permission_on :categories, :to => :manage
		has_permission_on :supplier_categories, :to => :manage
		has_permission_on :genres, :to => :manage
		has_permission_on :labels, :to => :manage
		has_permission_on :languages, :to => :manage
		has_permission_on :origins, :to => :manage
		has_permission_on :programs, :to => :manage
		
		#movies
		has_permission_on :movies, :to => [:manage, :check_airline_rights, :check_screener_remarks, :check_movie_type, :update_date]
		has_permission_on :videos, :to => [:manage]
		has_permission_on :suppliers, :to => :manage
		has_permission_on :airline_rights_countries, :to => :manage
		has_permission_on :publishers, :to => :manage
		has_permission_on :import_album, :to => [:read, :find_release, :import_release]
		has_permission_on :album_playlist_items, :to => :manage
		has_permission_on :audio_playlist_tracks, :to => :manage
		has_permission_on :audio_playlists, :to => [:manage, 
		            :add_track, :add_track_to_playlist, :duplicate,
		            :edit_audio_playlist_mastering, :export, 
		            :export_to_excel, :find_track,:set_audio_playlist_track_mastering, 
								:print, :sort, :splits, :set_audio_playlist_track_split, 
								:set_audio_playlist_track_vo_duration, :download_mp3]
								
		has_permission_on :album_playlists, :to => [:manage,:print, :add_album, :add_album_to_playlist, 
		            :sort, :edit_synopsis, :export_to_excel, :export_albums_programmed_per_airline_to_excel, 
		            :duplicate, :set_album_playlist_item_category_id, :set_audio_playlist_track_split, 
		            :export_by_airline, :set_album_synopsis, :download_mp3]

		has_permission_on :users, :to => [:edit_own_password, :update_own_password]
		
  end
  
  # permissions on other roles, such as
  role :administrator do
		has_permission_on :dashboard, :to => :manage
    has_permission_on :splits, :to => :manage
		has_permission_on :vo_durations, :to => :manage
    has_permission_on :vos, :to => :manage  
    has_permission_on :settings, :to => :manage  
    has_permission_on :airlines, :to => :manage
		has_permission_on :albums, :to => [:manage, :admin_delete, :amazon_cd_covers, :show_genre, 
		              :show_synopsis, :show_tracks, :show_playlists, :show_tracks_translation, :sort, :restore, :add_track, :set_album_synopsis]
		has_permission_on :tracks, :to => [:manage, :admin_delete, :show_lyrics_form, :show_playlists, :show_genre]
		has_permission_on :categories, :to => :manage
		has_permission_on :supplier_categories, :to => :manage
		has_permission_on :genres, :to => :manage
		has_permission_on :labels, :to => :manage
		has_permission_on :languages, :to => :manage
		has_permission_on :master_languages, :to => :manage
		has_permission_on :origins, :to => :manage
		has_permission_on :programs, :to => :manage
		
		#movies
		has_permission_on :movies, :to => [:manage, :admin_delete, :check_airline_rights, :check_screener_remarks, 
		    :check_movie_type, :update_date, :restore]
		has_permission_on :masters, :to => [:manage, :admin_delete, :restore, :duplicate]
		has_permission_on :screeners, :to => [:manage, :admin_delete, :restore, :duplicate]
		has_permission_on :videos, :to => [:manage, :admin_delete, :restore]
		has_permission_on :suppliers, :to => :manage		
		has_permission_on :airline_rights_countries, :to => :manage
		has_permission_on :movie_genres, :to => :manage
		has_permission_on :video_genres, :to => :manage
		has_permission_on :video_parent_genres, :to => :manage
		has_permission_on :movies_settings, :to => :manage
		has_permission_on :commercial_run_times, :to => :manage
		has_permission_on :video_playlist_types, :to => :manage
		has_permission_on :master_playlist_types, :to => :manage
		has_permission_on :master_languages, :to => :manage
		
		has_permission_on :publishers, :to => :manage
		has_permission_on :album_playlist_items, :to => :manage
		has_permission_on :audio_playlist_tracks, :to => :manage	
		has_permission_on :movie_playlist_items, :to => :manage	
		has_permission_on :video_playlist_items, :to => :manage	
		has_permission_on :video_master_playlist_items, :to => :manage	
		has_permission_on :screener_playlist_items, :to => :manage	
	
		has_permission_on :users, :to => [:manage,:edit_own_password, :update_own_password, :enable, :disable]
		has_permission_on :rights, :to => :manage
		has_permission_on :roles, :to => :manage
		has_permission_on :import_album, :to => [:read, :find_release, :import_release]
		
		has_permission_on :audio_playlists, :to => [:manage, :add_track, :add_track_to_playlist, :duplicate,
		            :edit_audio_playlist_mastering, :export, :export_to_excel, :find_track, :lock, 
		            :unlock,:set_audio_playlist_track_mastering, :set_audio_playlist_track_split, 
								:print, :sort, :splits,:set_audio_playlist_track_vo_duration, :download_mp3]
								
		has_permission_on :album_playlists, :to => [:manage,:print, :add_album, :add_album_to_playlist, :lock, 
		:unlock, :sort, :edit_synopsis, :export_to_excel, :export_albums_programmed_per_airline_to_excel, 
		:duplicate, :set_album_playlist_item_category_id, :export_by_airline, :set_album_synopsis, :download_mp3]
		
		has_permission_on :movie_playlists, :to => [:manage,:print, :add_movie, :add_movie_to_playlist, 
		            :sort, :export_to_excel, :add_multiple_movies, :duplicate]
		            
    has_permission_on :video_playlists, :to => [:manage,:print, :add_video, :add_video_to_playlist, 
                :sort, :export_to_excel, :add_multiple_videos, :duplicate]

		has_permission_on :video_master_playlists, :to => [:manage,:print, :add_master, :add_master_to_playlist, 
                :sort, :export_to_excel, :add_multiple_masters, :set_video_master_playlist_item_mastering, :duplicate]

		has_permission_on :screener_playlists, :to => [:manage,:print, :add_screener, :add_screener_to_playlist, 
                :sort, :export_to_excel, :add_multiple_screeners, :set_screener_playlist_item_mastering, :duplicate]

  end
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
	
end
