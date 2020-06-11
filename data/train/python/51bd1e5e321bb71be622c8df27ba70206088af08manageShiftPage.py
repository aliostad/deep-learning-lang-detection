from basePage import *
from pom.locators.eventSignUpPageLocators import EventSignUpPageLocators
from pom.locators.manageShiftPageLocators import ManageShiftPageLocators
from pom.pages.homePage import HomePage
from pom.pageUrls import PageUrls

class ManageShiftPage(BasePage):

    shift_page = PageUrls.manage_volunteer_shift_page
    shift_assignment_text = 'Assign Shift'
    no_volunteer_shift_message = 'This volunteer does not have any upcoming shifts.'
    live_server_url = ''

    def __init__(self, driver):
        self.driver = driver
        self.home_page = HomePage(self.driver)
        self.sign_up_elements = EventSignUpPageLocators()
        self.manage_elements = ManageShiftPageLocators()
        super(ManageShiftPage, self).__init__(driver)

    def navigate_to_manage_shift_page(self):
        self.get_page(self.live_server_url, self.shift_page)

    def submit_form(self):
        self.element_by_xpath(self.manage_elements.SUBMIT_PATH).submit()

    def assign_shift(self):
        self.click_link(self.shift_assignment_text)

    def select_volunteer(self, number):
        link_path = '//table//tbody//tr[' + str(number) + ']//td[10]//a'
        self.element_by_xpath(link_path).click()

    def navigate_to_shift_assignment_page(self):
        self.element_by_xpath(self.sign_up_elements.VIEW_JOBS_PATH + "//a").click()
        self.element_by_xpath(self.sign_up_elements.VIEW_SHIFTS_PATH + "//a").click()
        self.element_by_xpath(self.sign_up_elements.ASSIGN_SHIFTS_PATH + "//a").click()

    def get_info_box(self):
        return self.element_by_class_name(self.manage_elements.INFO_BOX).text

    def find_table_row(self):
        return self.element_by_tag_name('tr')

    def get_cancel_shift(self):
        return self.element_by_xpath(self.manage_elements.CANCEL_SHIFT_PATH)

    def cancel_shift(self):
        self.element_by_xpath(self.manage_elements.CANCEL_SHIFT_PATH + "//a").click()

    def get_cancellation_box(self):
        return self.element_by_class_name(self.manage_elements.CANCELLATION_PANEL)

    def get_cancellation_header(self):
        return self.element_by_class_name(self.manage_elements.CANCELLATION_HEAD).text

    def get_cancellation_message(self):
        return self.element_by_class_name(self.manage_elements.CANCELLATION_CONFIRMATION).text
