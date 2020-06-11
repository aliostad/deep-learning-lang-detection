#pragma once

#include <stdio.h>
#include <wchar.h>
#include "damn.h"
#include "settings.h"
#include "packet.h"
#include "protocol.h"
#include "events.h"
#include "logger.h"
#include "tablumps.h"
#include "htmlentities.h"
#include "chatenv.h"

void set_damntoken(wchar_t*);

#define HANDLER(x) void handler_##x(context *cbdata)

HANDLER(dAmnServer);
HANDLER(login);
HANDLER(ping);
HANDLER(join);
HANDLER(part);
HANDLER(property_members);
HANDLER(property_topic);
HANDLER(property_title);
HANDLER(property_privclasses);
HANDLER(recv_msg);
HANDLER(recv_action);
HANDLER(recv_join);
HANDLER(recv_part);
