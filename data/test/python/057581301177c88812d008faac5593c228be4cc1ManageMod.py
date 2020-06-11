import flask
import os
import os.path as osp

script_dir = osp.dirname(osp.abspath(__file__))
import sys

sys.path.append("../../..")
from RIMSAuth import requires_auth

class ManageMod(flask.Blueprint):

  def __init__(self,parent_app):
    super(ManageMod, self).__init__(
            'manage', __name__,
            template_folder=osp.join(script_dir, 'templates')
        )
    @self.route('/manage', methods=['get'])
    @requires_auth
    def login():
    # Render the login page, then continue on to a previously requested
    # page, or the home page.
      return flask.render_template('manage.html')
      
    @self.route('/_upload', methods=["POST"])
    def upload():
      print "This is an attempted upload"