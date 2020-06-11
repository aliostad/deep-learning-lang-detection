from View.TodayView import TodayView
from View.ActivityView import ActivityView
from View.FindView import FindView
from Controller.TodayController import TodayController
from Controller.activityController import ActivityController
from Controller.FindController import FindController
from Controller.myThread import myThread

class mainController:
    def __init__(self, wTree, user, session):
        self.wTree = wTree
        self.user = user
        self.session = session
        self.loadTodayCard()
        self.loadActivityCard()
        self.loadFindCard()

    def loadTodayCard(self):
        today_view = TodayView(self.wTree)
        today_controller = TodayController(today_view, self.user, self.session)
        # self.thread = myThread([today_controller])
        # self.thread.start()

    def loadActivityCard(self):
        activity_view = ActivityView(self.wTree)
        ActivityController(self.wTree, activity_view, self.user, self.session)

    def loadFindCard(self):
        find_view = FindView(self.wTree)
        FindController(self.wTree, find_view, self.session, self.user)
