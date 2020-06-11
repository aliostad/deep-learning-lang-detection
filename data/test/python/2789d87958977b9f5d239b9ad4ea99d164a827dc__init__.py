# -*- coding: utf-8 -*-
# DiSSOmniaG (Distributed Simulation Service wit OMNeT++ and Git)
# Copyright (C) 2011, 2012 Sebastian Wallat, University Duisburg-Essen
# 
# Based on an idea of:
# Sebastian Wallat <sebastian.wallat@uni-due.de, University Duisburg-Essen
# Hakim Adhari <hakim.adhari@iem.uni-due.de>, University Duisburg-Essen
# Martin Becke <martin.becke@iem.uni-due.de>, University Duisburg-Essen
#
# DiSSOmniaG is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# DiSSOmniaG is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with DiSSOmniaG. If not, see <http://www.gnu.org/licenses/>
import logging

log = logging.getLogger("cliApi.__init__")

def users(*args):
    import ManageUsers
    ManageUsers.users().call(*args)

def keys(*args):
    import ManageUsers
    ManageUsers.keys().call(*args)

def addUser(*args):
    import ManageUsers
    ManageUsers.addUser().call(*args)
    
def addKey(*args):
    import ManageUsers
    ManageUsers.addKey().call(*args)

def modUser(*args):
    import ManageUsers
    ManageUsers.modUser().call(*args)

def delUser(*args):
    import ManageUsers
    ManageUsers.delUser().call(*args)
    
def delKey(*args):
    import ManageUsers
    ManageUsers.delKey().call(*args)
    
def passwd(*args):
    import ManageUsers
    ManageUsers.passwd().call(*args)

def whoami(*args):
    import ManageUsers
    ManageUsers.whoami().call(*args)
    
def jobs(*args):
    import ManageJobs
    ManageJobs.CliJobs().call(*args)

def stopJob(*args):
    import ManageJobs
    ManageJobs.stopJob().call(*args)
    
def addDummyJob(*args):
    import ManageJobs
    ManageJobs.addDummyJob().call(*args)
    
def hosts(*args):
    import ManageHosts
    ManageHosts.hosts().call(*args)
    
def addHost(*args):
    import ManageHosts
    ManageHosts.addHost().call(*args)
    
def modHost(*args):
    import ManageHosts
    ManageHosts.modHost().call(*args)
    
def delHost(*args):
    import ManageHosts
    ManageHosts.delHost().call(*args)
    
def checkHost(*args):
    import ManageHosts
    ManageHosts.checkHost().call(*args)

def nets(*args):
    import ManageNets
    ManageNets.nets().call(*args)

def addNet(*args):
    import ManageNets
    ManageNets.addNet().call(*args)

def delNet(*args):
    import ManageNets
    ManageNets.delNet().call(*args)
    
def startNet(*args):
    import ManageNets
    ManageNets.startNet().call(*args)

def stopNet(*args):
    import ManageNets
    ManageNets.stopNet().call(*args)
    
def refreshNet(*args):
    import ManageNets
    ManageNets.refreshNet().call(*args)
    
def vms(*args):
    import ManageVms
    ManageVms.vms().call(*args)

def addVm(*args):
    import ManageVms
    ManageVms.addVm().call(*args)

def delVm(*args):
    import ManageVms
    ManageVms.delVm().call(*args)
    
def startVm(*args):
    import ManageVms
    ManageVms.startVm().call(*args)

def stopVm(*args):
    import ManageVms
    ManageVms.stopVm().call(*args)
    
def refreshVm(*args):
    import ManageVms
    ManageVms.refreshVm().call(*args)
    
def vmAddInterface(*args):
    import ManageVms
    ManageVms.vmAddInterface().call(*args)
    
def vmDelInterface(*args):
    import ManageVms
    ManageVms.vmDelInterface().call(*args)

def prepareVm(*args):
    import ManageVms
    ManageVms.prepareVm().call(*args)
    
def deployVm(*args):
    import ManageVms
    ManageVms.deployVm().call(*args)
    
def resetVm(*args):
    import ManageVms
    ManageVms.resetVm().call(*args)

def totalResetVm(*args):
    import ManageVms
    ManageVms.totalResetVm().call(*args)
    
def apps(*args):
    import ManageApps
    ManageApps.apps().call(*args)
    
def addApp(*args):
    import ManageApps
    ManageApps.addApp().call(*args)
    
def delApp(*args):
    import ManageApps
    ManageApps.delApp().call(*args)
    
def addAppUser(*args):
    import ManageApps
    ManageApps.addAppUser().call(*args)
    
def delAppUser(*args):
    import ManageApps
    ManageApps.delAppUser().call(*args)
    
def addAppVm(*args):
    import ManageApps
    ManageApps.addAppVm().call(*args)
    
def delAppVm(*args):
    import ManageApps
    ManageApps.delAppVm().call(*args)
    
def resetApp(*args):
    import ManageApps
    ManageApps.resetApp().call(*args)

def compileApp(*args):
    import ManageApps
    ManageApps.compileApp().call(*args)
    
def startApp(*args):
    import ManageApps
    ManageApps.startApp().call(*args)
    
def stopApp(*args):
    import ManageApps
    ManageApps.stopApp().call(*args)

def interruptApp(*args):
    import ManageApps
    ManageApps.interruptApp().call(*args)
    
def refreshGitApp(*args):
    import ManageApps
    ManageApps.refreshGitApp().call(*args)
    
def refreshAndResetApp(*args):
    import ManageApps
    ManageApps.refreshAndResetApp().call(*args)
    
def cloneApp(*args):
    import ManageApps
    ManageApps.cloneApp().call(*args)
    
def cleanApp(*args):
    import ManageApps
    ManageApps.cleanApp().call(*args)

def testSubprocess(terminal, user, *args):
    import sys
    sys.stdout = terminal
    sys.stderr = terminal
    import subprocess
    
    terminal.write("One line at a time:")
    terminal.nextLine()
    
    proc = subprocess.Popen("python repeater.py",
                            shell = True,
                            stdin = subprocess.PIPE,
                            stdout = subprocess.PIPE,
                            )
    for i in range(5):
        proc.stdin.write(" % d\n" % i)
        output = proc.stdout.readline()
        terminal.write(str(output.rstrip()))
        terminal.nextLine()
    remainder = proc.communicate()[0]
    terminal.write(str(remainder))
    terminal.nextLine()
