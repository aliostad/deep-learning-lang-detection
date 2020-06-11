Coyotes::Application.routes.draw do
	devise_for :users

	post 'events/manage/upload_image' => 'manage_events#upload_image'
	post 'events/manage/update' => 'manage_events#update_event'
	post 'events/manage/remove_event' => 'manage_events#remove_event'
	post 'events/manage/schedule' => 'manage_events#schedule_event'
	get 'events/manage/search' => 'manage_events#search'
	get 'events/manage/recent' => 'manage_events#recent_events'
	post 'events/manage/create' => 'manage_events#create'
	get 'events/manage' => 'manage_events#index'

	# menu legacy routes
		get 'menu' => redirect('/menus')
		get 'dinnermenu' => redirect('/menus')
	# /menu legacy routes

	post 'menus/manage/update' => 'manage_menus#update'
	get 'menus/manage' => 'manage_menus#menus'
	get 'menus' => 'menu#menus'

	# event legacy routes
		get 'eventlist' => redirect('/events')
		get 'upcomingevents' => redirect('/events')
		get 'upcomingevents/:year/:month' => redirect('/events#!%{year}-%{month}')
		get 'viewevent/:event_id' => redirect('/events')
	# /event legacy routes

	get 'karaoke' => 'events#karaoke'

	get 'coyotes-idol' => 'events#coyotes_idol'
	get 'coyotesidol' => redirect('/coyotes-idol')
	get 'coyotes_idol' => redirect('/coyotes-idol')

	get 'events/:year/:month' => redirect('/events#!%{year}-%{month}')
	get 'events' => 'events#index'

	get 'location' => 'application#location'
	get 'sports' => 'application#sports'

	get 'catering/manage' => 'manage_menus#catering'
	get 'catering' => 'menu#catering'

	get 'feedback' => 'feedback#index'
	post 'feedback/create' => 'feedback#create'

	get 'legal' => 'application#legal'
	post 'activity' => 'application#activity'

	get 'blank' => 'application#blank'

	post 'frontpage/manage/save-hours' => 'manage_frontpage#save_hours'
	get 'frontpage/manage' => 'manage_frontpage#index'
	get 'frontpage' => 'frontpage#index'

	match '/404', :to => 'errors#not_found'
	match '/500', :to => 'errors#error'

	root :to => 'frontpage#index'
end
