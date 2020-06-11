from controller import Controller
from src.database.board_repository import BoardRepository
from src.database.scraped_list_repository import ScrapedListRepository 

class BoardController(Controller):
    
    def __init__(self, database):
        self.scraped_list_repository = ScrapedListRepository(database)
        self.board_repository        = BoardRepository(database) 
        super(BoardController, self).__init__()

    @Controller.authentication_required
    def control_panel(self):
        board = self.board_repository.find()
        scraped_list = self.scraped_list_repository.find()
        return self.render('admin/admin.html', 
            scraped_jobs = scraped_list.scraped_jobs,
            active_jobs  = board.jobs_by_status('active'),
            pending_jobs = board.jobs_by_status('pending')
        )
    
    def view(self):
        board = self.board_repository.find()
        jobs  = board.jobs_by_status('active')
        return self.render('public/index.html', jobs = jobs)

    def about(self):
        return self.render('public/about.html') 
