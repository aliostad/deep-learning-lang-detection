# -*- coding: utf8 -*-
import os
import json
import cherrypy

from libs.utils import Dispatch

CURRENT_DIR = os.path.abspath(os.path.dirname(__file__))
CONFIG_FILE = CURRENT_DIR + "".join('/../conf/config.ini')


class RootController(object):

    @cherrypy.expose
    def index(self):
        return "o-jigi"


    @cherrypy.expose
    def default(self,*args, **kwargs):

        if cherrypy.request.method == "POST":
            path = "".join(args)
            payload = json.loads(kwargs["payload"])

            dispatch = Dispatch(path.lower(), payload, CONFIG_FILE)

            script = "{0}{1}/{2}".format(dispatch.dispatch_path,
                                         dispatch.repository,
                                         dispatch.script_name)

            cherrypy.log('DISPATCH Executing: {0}'.format(script))
            result = dispatch.run()

            if result['status_code'] == 0:
                message = result['message']
                cherrypy.log('DISPATCH Successful Execution: {0}'.format(script))
            elif result['status_code'] == -1:
                message = result['error']
                cherrypy.log('DISPATCH {0}: {1}'.format(message, script))
            else:
                message = result['error']
                cherrypy.log('DISPATCH Error: {0} - {1}'.format(result['status_code'],
                                                                message))

            if len(dispatch.mails) > 0:
                message = 'Repository: {0}\nBranch: {1}\nScript: {2}\n\n{3}' \
                    .format(dispatch.repository,
                            dispatch.branch, script, message)
                cherrypy.log('DISPATCH Send mails')
                dispatch.send_mails(message)

            return "Received: repository {0} of the branch {1}".\
                format(dispatch.repository, dispatch.branch)
