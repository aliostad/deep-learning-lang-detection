#!/usr/bin/env bash
#*******************************************************************************
# Copyright (c) 2016 Stichting Yona Foundation
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#*******************************************************************************

function killListeningProcess() {
    lsof -i:$1 -sTCP:LISTEN -t | xargs kill -9
}

killListeningProcess 9001
killListeningProcess 8080
killListeningProcess 8081
killListeningProcess 8082
killListeningProcess 8083
