from google.appengine.ext import ndb

from . import NdbBaseModel, NdbUtcDateTimeProperty
from ext.wtforms import validators, fields, widgets
from ext.wtforms.form import Form


Manage_Restricted_Pages = {
    "ManageHandler": (0, ("/manage", "Change Log")),
    "Manage_HomePageSlides_BaseHandler": (1, ("/manage/homepage_slides", "Homepage Slides")),
    "Manage_HousingApplications_BaseHandler": (2, ("/manage/housing_applications", "Applications")),
    "Manage_NewsletterArchive_BaseHandler": (3, ("/manage/newsletter_archive", "Newsletter Archive")),
    "Manage_GelGroups_BaseHandler": (4, ("/manage/gel_groups", "Small Groups")),
    "Manage_SemesterSeries_BaseHandler": (4, ("/manage/semester_series", "Semester Series")),
    "Manage_TopTen_BaseHandler": (4, ("/manage/top_ten", "Top Ten")),
    "Manage_StudentOfficers_BaseHandler": (5, ("/manage/student_officers", "Officers")),
    "Manage_StaffPositions_BaseHandler": (5, ("/manage/staff_positions", "Staff")),
}

Other_Restricted_Pages = {
    "ApplicationComments": (100, ("/housing/comments", "Housing Application Comments"))
}

All_Restricted_Pages = dict(Manage_Restricted_Pages.items() + Other_Restricted_Pages.items())

class MultiCheckboxField(fields.SelectMultipleField):
    """
    A multiple-select, except displays a list of checkboxes.

    Iterating the field will produce subfields, allowing custom rendering of
    the enclosed checkbox fields.
    """
    widget = widgets.ListWidget(prefix_label=False)
    option_widget = widgets.CheckboxInput()


class UserPermission_Form(Form):
    id = fields.StringField(
        label=u"User Email",
        validators=[validators.required()],
        filters=[lambda x: x.lower() if x else x],
    )
    PermittedPageClasses = MultiCheckboxField(
        label="Permitted Pages",
        validators=[validators.Required()],
        choices=[(x, All_Restricted_Pages[x][1][1]) for x in sorted(All_Restricted_Pages.keys())],
    )


class UserPermission(NdbBaseModel):
    CreatedBy = ndb.UserProperty(auto_current_user_add=True)
    CreationDateTime = NdbUtcDateTimeProperty(auto_now_add=True)
    ModifiedBy = ndb.UserProperty(auto_current_user=True)
    ModifiedDateTime = NdbUtcDateTimeProperty(auto_now=True)

    PermittedPageClasses = ndb.StringProperty(
        repeated=True,
    )

    def check_permission(self, input_class):
        if input_class.__name__ in self.PermittedPageClasses:
            return True
        for base_class in input_class.__bases__:
            if self.check_permission(base_class):
                return True
        return False

    @property
    def HumanReadablePermittedPageClasses(self):
        return [All_Restricted_Pages[x][1][1] for x in self.PermittedPageClasses]

    @property
    def id(self):
        """
        For editing the obj with WTForms
        """
        return self.key.string_id()
