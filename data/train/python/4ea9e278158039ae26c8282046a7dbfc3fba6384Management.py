##############################################################################
#
# Copyright (c) 2001 Zope Corporation and Contributors. All Rights Reserved.
#
# This software is subject to the provisions of the Zope Public License,
# Version 2.0 (ZPL).  A copy of the ZPL should accompany this distribution.
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY AND ALL EXPRESS OR IMPLIED
# WARRANTIES ARE DISCLAIMED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF TITLE, MERCHANTABILITY, AGAINST INFRINGEMENT, AND FITNESS
# FOR A PARTICULAR PURPOSE
#
##############################################################################

"""Standard management interface support

$Id: Management.py,v 1.61 2002/08/14 21:31:40 mj Exp $"""

__version__='$Revision: 1.61 $'[11:-2]

import sys, Globals, ExtensionClass, urllib
from Dialogs import MessageDialog
from Globals import DTMLFile, HTMLFile
from AccessControl import getSecurityManager, Unauthorized

class Tabs(ExtensionClass.Base):
    """Mix-in provides management folder tab support."""

    manage_tabs__roles__=('Anonymous',)
    manage_tabs=DTMLFile('dtml/manage_tabs', globals())


    manage_options  =()

    filtered_manage_options__roles__=None
    def filtered_manage_options(self, REQUEST=None):

        validate=getSecurityManager().validate

        result=[]

        try: options=tuple(self.manage_options)
        except: options=tuple(self.manage_options())

        for d in options:

            filter=d.get('filter', None)
            if filter is not None and not filter(self):
                continue

            path=d.get('path', None)
            if path is None: path=d['action']

            o=self.unrestrictedTraverse(path, None)
            if o is None: continue

            try:
                if validate(None, self, None, o):
                    result.append(d)
            except:
                if not hasattr(o, '__roles__'):
                    result.append(d)

        return result


    manage_workspace__roles__=('Authenticated',)
    def manage_workspace(self, REQUEST):
        """Dispatch to first interface in manage_options
        """
        options=self.filtered_manage_options(REQUEST)
        try:
            m=options[0]['action']
            if m=='manage_workspace': raise TypeError
        except:
            raise Unauthorized, (
                'You are not authorized to view this object.')

        if m.find('/'):
            raise 'Redirect', (
                "%s/%s" % (REQUEST['URL1'], m))

        return getattr(self, m)(self, REQUEST)

    def tabs_path_default(self, REQUEST,
                          # Static var
                          unquote=urllib.unquote,
                          ):
        steps = REQUEST._steps[:-1]
        script = REQUEST['BASEPATH1']
        linkpat = '<a href="%s/manage_workspace">%s</a>'
        out = []
        url = linkpat % (script, '&nbsp;/')
        if not steps:
            return url
        last = steps.pop()
        for step in steps:
            script = '%s/%s' % (script, step)
            out.append(linkpat % (script, unquote(step)))
        script = '%s/%s' % (script, last)
        out.append('<a class="strong-link" href="%s/manage_workspace">%s</a>'%
                   (script, unquote(last)))
        return '%s%s' % (url, '/'.join(out))

    def tabs_path_info(self, script, path,
                       # Static vars
                       quote=urllib.quote,
                       ):
        out=[]
        while path[:1]=='/': path=path[1:]
        while path[-1:]=='/': path=path[:-1]
        while script[:1]=='/': script=script[1:]
        while script[-1:]=='/': script=script[:-1]
        path=path.split('/')[:-1]
        if script: path=[script]+path
        if not path: return ''
        script=''
        last=path[-1]
        del path[-1]
        for p in path:
            script="%s/%s" % (script, quote(p))
            out.append('<a href="%s/manage_workspace">%s</a>' % (script, p))
        out.append(last)
        return '/'.join(out)

    class_manage_path__roles__=None
    def class_manage_path(self):
        if self.__class__.__module__[:1] != '*': return
        path = getattr(self.__class__, '_v_manage_path_roles', None)
        if path is None:
            meta_type = self.meta_type
            for zclass in self.getPhysicalRoot()._getProductRegistryData(
                'zclasses'):
                if zclass['meta_type'] == meta_type:
                    break
            else:
                self.__class__._v_manage_path_roles = ''
                return
            path = self.__class__._v_manage_path_roles = (
                '%(product)s/%(id)s' % zclass)
        if path:
            return '/Control_Panel/Products/%s/manage_workspace' % path

Globals.default__class_init__(Tabs)


class Navigation(ExtensionClass.Base):
    """Basic navigation UI support"""

    __ac_permissions__=(
        ('View management screens',
         ('manage', 'manage_menu', 'manage_top_frame',
          'manage_page_header',
          'manage_page_footer',
          )),
        )

    manage            =DTMLFile('dtml/manage', globals())
    manage_menu       =DTMLFile('dtml/menu', globals())

    manage_top_frame  =DTMLFile('dtml/manage_top_frame', globals())
    manage_page_header=DTMLFile('dtml/manage_page_header', globals())
    manage_page_footer=DTMLFile('dtml/manage_page_footer', globals())

    manage_form_title =DTMLFile('dtml/manage_form_title', globals(),
                                form_title='Add Form',
                                help_product=None,
                                help_topic=None)
    manage_form_title._setFuncSignature(
        varnames=('form_title', 'help_product', 'help_topic') )
    manage_form_title__roles__ = None

    zope_quick_start=DTMLFile('dtml/zope_quick_start', globals())
    zope_quick_start__roles__=None

    manage_copyright=DTMLFile('dtml/copyright', globals())
    manage_copyright__roles__ = None

    manage_zmi_logout__roles__ = None
    def manage_zmi_logout(self, REQUEST, RESPONSE):
        """Logout current user"""
        p = getattr(REQUEST, '_logout_path', None)
        if p is not None:
            return apply(self.restrictedTraverse(p))

        realm=RESPONSE.realm
        RESPONSE.setStatus(401)
        RESPONSE.setHeader('WWW-Authenticate', 'basic realm="%s"' % realm, 1)
        RESPONSE.setBody("""<html>
<head><title>Logout</title></head>
<body>
<p>
You have been logged out.
</p>
</body>
</html>""")
        return


    manage_zmi_prefs=DTMLFile('dtml/manage_zmi_prefs', globals())
    manage_zmi_prefs__roles__ = None

file = DTMLFile('dtml/manage_page_style.css', globals())
setattr(Navigation, 'manage_page_style.css', file)
setattr(Navigation, 'manage_page_style.css__roles__', None)

Globals.default__class_init__(Navigation)
