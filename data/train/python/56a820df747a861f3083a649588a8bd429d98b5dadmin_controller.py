from flask import render_template
from . import *

bp = Blueprint('admin', __name__)
before_request_extract_page_params(bp)
# prefix feed
@bp.route("/")
def index():
    menu_tree = {
        'text': 'root',
        'href': '#',
        'leaf': False,
        'children': [
            { 'text': 'feed',
              'href': '#/feed/manage',
              'leaf': True, },
            { 'text': 'feed entries',
              'href': '#/feed_entries/manage',
              'leaf': True, },
        ]
    }
    menu_urls = ['/', '/feed/manage', '/feed_entries/manage']
    return render_template('index.html', 
            menu_tree=menu_tree, 
            menu_urls=menu_urls)

