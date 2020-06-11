from flask import Blueprint

from ctflorals.controllers import HomeController
from ctflorals.controllers import AboutController
from ctflorals.controllers import GalleryController
from ctflorals.controllers import TestimonialsController

ctflorals = Blueprint('ctflorals', __name__,
                      template_folder='views',
                      static_folder='../resources')


@ctflorals.route("/")
def home():
    return HomeController().index()


@ctflorals.route("/about/")
def about():
    return AboutController().index()


@ctflorals.route("/gallery/")
def gallery():
    return GalleryController().index()


@ctflorals.route("/testimonials/")
def testimonials():
    return TestimonialsController().index()
