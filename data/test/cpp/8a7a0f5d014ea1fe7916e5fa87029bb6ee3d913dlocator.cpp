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

void zmq::locator_t::register_endpoint (const char *name_,
    const char *location_)
{
    //  If 0MQ is used for in-process messaging, we shouldn't even get here.
    assert (global_locator);
    assert (strlen (name_) <= 255);
    assert (strlen (location_) <= 255);

    //  Send to 'create' command.
    unsigned char cmd = create_id;
    global_locator->write (&cmd, 1);
    unsigned char size = (unsigned char) strlen (name_);
    global_locator->write (&size, 1);
    global_locator->write (name_, size);
    size = (unsigned char) strlen (location_);
    global_locator->write (&size, 1);
    global_locator->write (location_, size);

    //  Read the response.
    global_locator->read (&cmd, 1);
    assert (cmd == create_ok_id);

}

void zmq::locator_t::resolve_endpoint (const char *name_, char *location_,
    size_t location_size_)
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
    assert (location_size_ >= 256);
    global_locator->read (&size, 1);
    global_locator->read (location_, size);
    location_ [size] = 0;
}

