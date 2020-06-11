/*
    Copyright (c) 2007-2009 FastMQ Inc.

    This file is part of 0MQ.

    0MQ is free software; you can redistribute it and/or modify it under
    the terms of the Lesser GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    0MQ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Lesser GNU General Public License for more details.

    You should have received a copy of the Lesser GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <assert.h>
#include <string.h>
#include <string>

#include <zmq/locator.hpp>
#include <zmq/config.hpp>
#include <zmq/formatting.hpp>
#include <zmq/server_protocol.hpp>

zmq::locator_t::locator_t (const char *hostname_)
{
    if (hostname_) {

        //  If port number is not explicitly specified, use the default one.
        if (!strchr (hostname_, ':')) {
            char buf [256];
            zmq_snprintf (buf, 256, "%s:%d", hostname_,
                (int) default_locator_port);
            hostname_ = buf;
        }

        //  Open connection to global locator.
        global_locator = new tcp_socket_t (hostname_, true);
        assert (global_locator);
    }
    else
        global_locator = NULL;
}

zmq::locator_t::~locator_t ()
{
    if (global_locator)
        delete global_locator;
}

void zmq::locator_t::register_endpoint (const char *name_, attr_list_t &attrs_)
{
    //  If 0MQ is used for in-process messaging, we shouldn't even get here.
    assert (global_locator);
    assert (strlen (name_) <= 255);

    //  Send to 'create' command.
    unsigned char cmd = create_id;
    global_locator->write (&cmd, 1);
    unsigned char size = (unsigned char) strlen (name_);
    global_locator->write (&size, 1);
    global_locator->write (name_, size);

    for (attr_list_t::iterator it = attrs_.begin ();
            it != attrs_.end (); it ++) {

        const std::string &key = (*it).first;
        const std::string &value = (*it).second;

        assert (key.size () < 256);
        size = key.size ();
        global_locator->write (&size, 1);
        global_locator->write (key.c_str (), size);

        assert (value.size () < 256);
        size = value.size ();
        global_locator->write (&size, 1);
        global_locator->write (value.c_str (), size);
    }

    //  Write terminator.
    size = 0;
    global_locator->write (&size, 1);

    //  Read the response.
    global_locator->read (&cmd, 1);
    assert (cmd == create_ok_id);
}

void zmq::locator_t::resolve_endpoint (const char *name_, attr_list_t &attrs_)
{
    //  If 0MQ is used for in-process messaging, we shouldn't even get here.
    assert (global_locator);

    //  Send 'get' command.
    unsigned char cmd = get_id;
    global_locator->write (&cmd, 1);
    unsigned char size = (unsigned char) strlen (name_);
    global_locator->write (&size, 1);
    global_locator->write (name_, size);

    //  Read the response.
    global_locator->read (&cmd, 1);
    assert (cmd == get_ok_id);

    //  Read attributes.
    global_locator->read (&size, 1);

    while (size > 0) {
        char buf [255];
        global_locator->read (buf, size);
        std::string key = std::string (buf, size);
        global_locator->read (&size, 1);
        global_locator->read (buf, size);
        std::string value = std::string (buf, size);
        attrs_ [key] = value;
        global_locator->read (&size, 1);
    }
}
