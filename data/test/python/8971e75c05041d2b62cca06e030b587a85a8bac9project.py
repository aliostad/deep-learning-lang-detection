

class ProjectHelper:

    def __init__(self, app):
        self.app = app

    def add_new_project(self):
        wd = self.app.wd
        #open manage page
        wd.find_element_by_css_selector('a[href$="manage_overview_page.php"]').click()
        #open manage project page
        wd.find_element_by_css_selector('a[href$="manage_proj_page.php"]').click()
        #open create new project page
        wd.find_element_by_css_selector('input[value$="Create New Project"]').click()
        #create new project



    