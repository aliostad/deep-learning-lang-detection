def url_routes(map):

	
	#Hompeage

	map.connect('', controller = 'homepage.views:ViewHomepage')
	map.connect('recent', controller = 'homepage.views:RecentUpdates')
	map.connect('autobot', controller = 'autobot.views:Autobot')

    #Login
	map.connect('login', controller = 'accounts.views:Login')
	map.connect('login/response', controller = 'accounts.views:LoginResponse')
	map.connect('logout', controller = 'accounts.views:Logout')
	map.connect('register', controller = 'accounts.views:Register')
	
	#Profiles
	map.connect('profile/*username', controller = 'profiles.views:ViewProfile')
	map.connect('edit_profile', controller = 'profiles.views:EditProfile')
	map.connect('edit_sponsor_settings', controller = 'profiles.views:EditSponsorSettings')
	
	#Subjects
	map.connect('subjects/*subjects', controller = 'editor.views:EditSubjects')
	map.connect('subjects', controller = 'editor.views:EditSubjects')
	
	#Store
	map.connect('preview/proficiency', controller = 'store.views:ChooseProficiency')
	#map.connect('sponsor/*user', controller = 'store.views:Sponsorship')

	#Sponsors
	map.connect('sponsors', controller = 'store.views:CommunitySponsor') # business sponsors
	map.connect('sponsors/:sponsor', controller = 'profiles.views:ViewSponsorProfile') # business sponsors
	map.connect('sponsor/*user', controller = 'store.views:Sponsorship') # personal sponsor signup
		
	#Preview
	map.connect('preview/profile', controller = 'profiles.views:PreviewViewProfile')
	map.connect('preview/employer/profile', controller = 'profiles.views:ViewEmployerProfile')
	map.connect('preview/employer/profile/browse', controller = 'profiles.views:BrowseProfiles')
	map.connect('preview/employer/load_profile', controller = 'profiles.views:LoadUserProfile')

	#Demo
	map.connect('demo', controller = 'quiztaker.views:PQDemo')
	map.connect('preview/ad_embed', controller = 'quiztaker.views:PQDemo')
	map.connect('st_quiz', controller = 'quiztaker.views:ViewSnaptalentQuiz')
	map.connect('st_quiz/close', controller = 'quiztaker.views:ViewNone')	
	
	# Taking Quizzes
	map.connect('quiz/*quiz', controller = 'quiztaker.views:TakeQuiz')
	map.connect('quiz', controller = 'quiztaker.views:TakeQuiz') # Can these two be combined with ?
	map.connect('widget', controller = 'quiztaker.views:Widget')	
	map.connect('quiz_item', controller = 'quiztaker.views:QuizItemTemplate')		
	map.connect('intro', controller = 'quiztaker.views:PQIntro')
	map.connect('quiz_complete', controller = 'quiztaker.views:QuizComplete')
	map.connect('quiz_frame', controller = 'quiztaker.views:QuizFrame')

	map.connect('js/quiz', controller = 'widget.handler:QuizJS') # no argument
	map.connect('js/quiz/:quiz_topic', controller = 'widget.handler:QuizJS')
	map.connect('css/quiz', controller = 'widget.handler:QuizCSS')
		

	# Induction & Building Quizzes
	map.connect('edit/:subject', controller = 'editor.views:QuizEditor')
	map.connect('editor', controller = 'editor.views:Editor')
	map.connect('editor/induction', controller = 'editor.views:InductionInterface')		
	map.connect('editor/item', controller = 'editor.views:RawItemTemplate')

	# RPC Handlers
	map.connect('quiztaker/rpc', controller = 'quiztaker.rpc:RPCHandler')
	map.connect('editor/rpc/get', controller = 'editor.rpc:RPCMethods')		
	map.connect('editor/rpc/post', controller = 'editor.rpc:RPCMethods')	
	map.connect('editor/rpc/post*data', controller = 'editor.rpc:RPCMethods')	
	map.connect('editor/rpc', controller = 'editor.rpc:RPCHandler')	#deprecated
	map.connect('employer/rpc', controller = 'employer.rpc:RPCHandler')	
	map.connect('employer/rpc/post', controller = 'employer.rpc:SponsorPost')		
	map.connect('accounts/rpc', controller = 'accounts.rpc:RPCHandler')	
	map.connect('accounts/rpc/post', controller = 'accounts.rpc:Post')	
	map.connect('profiles/rpc', controller = 'profiles.rpc:RPCHandler')
	map.connect('dev/rpc', controller = 'dev.rpc:RPCHandler')		
	map.connect('homepage/rpc', controller = 'homepage.rpc:RPCHandler')		
	map.connect('profiles/picture_upload', controller = 'profiles.rpc:PictureUpload')	
	
	
	# Induction & Building Quizzes
	map.connect('dev/admin', controller = 'dev.views:Admin')
	map.connect('ubiquity', controller = 'dev.ubiquity:QuizEditor')
	map.connect('dev/filter', controller = 'ranking.views:Filter')
	map.connect('ranking/graph', controller = 'ranking.views:Graph')		
	map.connect('debug', controller = 'dev.views:Debug')
	
	map.connect('headers', controller = 'dev.headers:RequestHandler')									
							

		
							
																														 
	#Utils
	map.connect('image/*img', controller = 'profiles.views:Image')
	map.connect('Redirect', 'redirect/*path', controller = 'accounts.views:Redirect')	
	map.connect('error/:error_type', controller = 'dev.views:Error')  
	map.connect('404 error', '*url/:not_found', controller = 'utils.utils:NotFoundPageHandler')
	map.connect('404 error', '*url', controller = 'utils.utils:NotFoundPageHandler')
	   
    
