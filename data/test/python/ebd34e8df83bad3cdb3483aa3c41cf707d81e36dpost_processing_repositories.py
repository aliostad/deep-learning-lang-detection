from data_access.repository import Repository
from databases.post_processing_database import PostProcessingDatabase

class PostProcessingRepository(Repository):
    def __init__(self):
        self.database = PostProcessingDatabase()

    def refresh_database(self):
        self.database.refresh()


class TorquePostProcessingRepository(PostProcessingRepository):
    def __init__(self):
        super(TorquePostProcessingRepository, self).__init__()
        self.x_data_getter = self.database.get_rpms
        self.y_data_getter = self.database.get_torques


class PowerPostProcessingRepository(PostProcessingRepository):
    def __init__(self):
        super(PowerPostProcessingRepository, self).__init__()
        self.x_data_getter = self.database.get_rpms
        self.y_data_getter = self.database.get_powers


