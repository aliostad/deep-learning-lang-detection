#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# -------------------------------------------------------------------------- #
# Copyright 2010-2013, Hector Sanjuan, David Rodríguez, Pablo Donaire        #
#                                                                            #
# Licensed under the Apache License, Version 2.0 (the "License"); you may    #
# not use this file except in compliance with the License. You may obtain    #
# a copy of the License at                                                   #
#                                                                            #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
#                                                                            #
# Unless required by applicable law or agreed to in writing, software        #
# distributed under the License is distributed on an "AS IS" BASIS,          #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
# See the License for the specific language governing permissions and        #
# limitations under the License.                                             #
#--------------------------------------------------------------------------- #

# VirtualBox commands use to perform operations on the VMs

VBOX_MANAGE = "VBoxManage"
VBOX_CREATE = VBOX_MANAGE + " createvm"
VBOX_STARTVM = VBOX_MANAGE + " startvm"
VBOX_CONTROLVM = VBOX_MANAGE + " controlvm"
VBOX_UNREGISTERVM = VBOX_MANAGE + " unregistervm"
VBOX_MODIFYVM = VBOX_MANAGE + " modifyvm"
VBOX_STORAGECTL = VBOX_MANAGE + " storagectl"
VBOX_STORAGEATTACH = VBOX_MANAGE + " storageattach"
VBOX_OPENMEDIUM = VBOX_MANAGE + " openmedium"
VBOX_CLOSEMEDIUM = VBOX_MANAGE + " closemedium"
VBOX_SHOWVMINFO = VBOX_MANAGE + " showvminfo"
VBOX_ADOPTSTATE = VBOX_MANAGE + " adoptstate"
VBOX_DISCARDSTATE = VBOX_MANAGE + " discardstate"
VBOX_SETHDUUID = VBOX_MANAGE + " internalcommands sethduuid"
VBOX_SHOWHDINFO = VBOX_MANAGE + " showhdinfo"
VBOX_CONVERTFROMRAW = VBOX_MANAGE + " convertfromraw"
