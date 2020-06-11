/*
 Copyright 2014 Canonical Ltd.

 This program is free software: you can redistribute it and/or modify it
 under the terms of the GNU General Public License version 3, as published
 by the Free Software Foundation.

 This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranties of
 MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
 PURPOSE.  See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along
 with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// package curldispatcher wraps liburl-dispatch1
package curldispatcher

/*
#cgo pkg-config: url-dispatcher-1

#include <liburl-dispatcher-1/url-dispatcher.h>
#include <glib.h>

char* handleDispatchURLResult(const gchar * url, gboolean success, gpointer user_data);

static void url_dispatch_callback(const gchar * url, gboolean success, gpointer user_data) {
    handleDispatchURLResult(url, success, user_data);
}

void dispatch_url(const gchar* url, gpointer user_data) {
    url_dispatch_send(url, (URLDispatchCallback)url_dispatch_callback, user_data);
}

gchar** test_url(const gchar** urls) {
    char** result = url_dispatch_url_appid(urls);
    return result;
}
*/
import "C"
