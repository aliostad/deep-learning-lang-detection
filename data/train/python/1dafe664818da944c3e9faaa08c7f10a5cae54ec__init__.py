from src.database.engine import database

from job            import JobController
from robot          import RobotController
from board          import BoardController
from error          import ErrorController
from company        import CompanyController
from scraped_job    import ScrapedJobController
from mailer         import MailerController

job_controller            = JobController(database)
robot_controller          = RobotController(database)
board_controller          = BoardController(database)
error_controller          = ErrorController(database)
mailer_controller         = MailerController(database)
company_controller        = CompanyController(database)
scraped_job_controller    = ScrapedJobController(database)
