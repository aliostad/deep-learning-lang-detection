from hubcheck.pageobjects.po_hubucoursemanage import HubUCourseManagePage

class HubUCourseManageEmailPage(HubUCourseManagePage):
    """hub u course manager email
       there is no tab for this page, you can get to it by direct url or
       select some users from the membership tab and do the "send email"
       action. it is slightly different from the "Send Invites" tab.
       the form widget's locator is a little different.
    """

    def __init__(self,browser,catalog,groupid=''):
        super(HubUCourseManageEmailPage,self).__init__(browser,catalog,groupid)
        self.path = "/groups/%s/manage?tab=send-email" % (groupid)

        # load hub's classes
        HubUCourseManageEmailPage_Locators = self.load_class('HubUCourseManageEmailPage_Locators')
        HubUCourseManageEmailForm = self.load_class('HubUCourseManageEmailForm')

        # update this object's locator
        self.locators.update(HubUCourseManageEmailPage_Locators.locators)

        # setup page object's components
        self.form         = HubUCourseManageEmailForm(self,{'base':'emailform'})

    def send_email(self,tolist,templateName):
        self.form.send_email(tolist,templateName)

class HubUCourseManageEmailPage_Locators_Base(object):
    """locators for HubUCourseManageEmailPage object"""

    locators = {
        'emailform' : "css=#send-email",
    }

